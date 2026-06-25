//
//  NetworkManager.swift
//
//
//  Created by Ruslan Kasian Dev on 31.08.2024.
//

import Foundation
import OSLog

public enum HTTPMethod: String {
    case GET
    case POST
}

public typealias Parameters = [String: String]
public typealias Headers = [String: String]

protocol APIConfiguration {
    var method: HTTPMethod { get }
    var endpoint: String { get }
    var timeInterval: TimeInterval { get }
    var body: Encodable? { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var contentType: RequestContentType? { get }
}

enum RequestContentType: String {
    case json = "application/json"
}

enum ParametersType: String, Encodable {
    case externalId = "external_id"
    case batchExternalId = "batch_external_id"
}

enum RequestHeaderField: String {
    case sign = "X-Sign"
    case widget = "X-Widget-Id"
    case contentType = "Content-Type"
    case requested = "X-Requested-With"
    case authorization = "Authorization"
}

enum RequestHeaderFieldValue {
    case json
    case xml
    case basic(token: String)
    
    
    var rawValue: String {
        switch self {
        case .json:
            return "application/json"
        case .xml:
            return "XmlHttpRequest"
        case .basic(let token):
            return "Basic \(token)"
        }
    }
}

public struct Request {
    let urlRequest: URLRequest
    
    init?(config: APIConfiguration) {
        guard let url = URL(string: config.endpoint) else {
           return nil
        }
        
        var baseRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: config.timeInterval
        )
        baseRequest.httpMethod = config.method.rawValue
        baseRequest.allHTTPHeaderFields = config.headers
        
        if let parameters = config.parameters {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            baseRequest.url = urlComponents?.url
        }
        
        if let httpBody = Request.encoded(body: config.body) {
            baseRequest.httpBody = httpBody
        }
        
        self.urlRequest = baseRequest
    }
    
    private static func encoded(body: Encodable?) -> Data? {
        guard let body = body else {
            return nil
        }
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            return jsonData
        } catch {
            Logger.network.error("🔴 Error: Error encoding body: \(error)")
            return nil
        }
    }
}


public enum APIError<ValidationError: Decodable & Swift.Error>: Swift.Error {
    case decodingFailure(Swift.Error)
    case networkUnreachable(code: Int, message: String?)
    case external(code: Int, message: String?)
    case validation(ValidationError)
    case unknown(code: Int, message: String?)
}

extension APIConfiguration {
    var timeInterval: TimeInterval {
        return RozetkaPayConfig.DEFAULT_REQUEST_TIMEOUT
    }
    
    var headers: Headers? { nil }
    var parameters: Parameters? { nil }
    var body: Encodable? { nil }
    var contentType: RequestContentType? { nil }
}

extension APIConfiguration {
    public func execute<T: Decodable, E: Decodable & Swift.Error>(_ success: T.Type, errorType: E.Type?) async throws -> T {
        Logger.network.info("***************************************************************")
        guard let request = Request(config: self) else {
            Logger.network.error("🔴 Error: An error network - badURL. \(URLError(.badURL).localizedDescription) 🔴")
            throw URLError(.badURL)
        }
        Logger.network.info("⚠️ Request URL: \(request.urlRequest.url?.absoluteString ?? "unknown") ⚠️")
        Logger.network.info("⚠️ Request: \n \(String(data: request.urlRequest.httpBody ?? Data(), encoding: .utf8).debugDescription ?? "Unable to convert data to String")\n⚠️")
        
        if let body = request.urlRequest.httpBody {
            Logger.network.info("⚠️ Request Body:\n\(prettyPrintedJSON(from: body))⚠️")
        }
        
        do {
            let (response, data) = try await dataTask(with: request.urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                try await self.validateFail(response: response, data: data, errorType: errorType)
                return try await execute(success, errorType: errorType)
            }
            
            Logger.network.info("⚠️ Response debugDescription: \n \(response.debugDescription) \n⚠️")
            Logger.network.info("⚠️ Response data: \n \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String") \n⚠️")

            Logger.network.info("⚠️ Response Headers: \(httpResponse.allHeaderFields)⚠️")
            Logger.network.info("⚠️ Response Data:\n\(prettyPrintedJSON(from: data))⚠️")

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                Logger.network.info("✅ SUCCESS: \(T.self)")
                return decodedResponse
            } catch let decodingError {
                Logger.network.error("🔴 Error: An error decodingError. \(decodingError.localizedDescription) ⚠️")
                throw APIError<E>.decodingFailure(decodingError)
            }
        } catch let urlError as URLError {
            Logger.network.error("🔴 Error: An error network. \(urlError.localizedDescription) ⚠️")
            throw APIError<E>.networkUnreachable(
                code: urlError.errorCode,
                message: "An error network. \(urlError.localizedDescription)"
            )
        } catch let apiError as APIError<E> {
            Logger.network.error("🔴 Error: An error. \(apiError.localizedDescription) ⚠️")
            throw apiError
        } catch {
            switch error {
            case let urlError as URLError:
                switch urlError.code {
                case .timedOut, .notConnectedToInternet, .networkConnectionLost:
                    Logger.network.error("🔴 Error: Network unreachable. \(request.urlRequest.debugDescription) ⚠️")
                    throw APIError<E>.networkUnreachable(
                        code: urlError.code.rawValue,
                        message: "Network unreachable. \(request.urlRequest.debugDescription)"
                    )
                default:
                    Logger.network.error("🔴 Error: URLError \(urlError.localizedDescription) ⚠️")
                    throw APIError<E>.external(
                        code: urlError.code.rawValue,
                        message: urlError.localizedDescription
                    )
                }
            case is DecodingError:
                throw APIError<E>.decodingFailure(error)
            default:
                Logger.network.error("🔴 Error: Unknown error. \(error.localizedDescription) ⚠️")
                throw APIError<E>.unknown(
                    code: (error as NSError).code,
                    message: error.localizedDescription
                )
            }
        }
    }
    
    private func dataTask(with urlRequest: URLRequest) async throws -> (URLResponse, Data) {
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(URLResponse, Data), Error>) in
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let response = response, let data = data else {
                    let error = NSError(domain: "error", code: 0, userInfo: nil)
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: (response, data))
            }
            task.resume()
        }
    }
    
    private func validateFail<E: Decodable & Swift.Error>(response: URLResponse, data: Data, errorType: E.Type? = nil) async throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError<E>.unknown(
                code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                message: "Response is not HTTPURLResponse"
            )
        }
        
        var decodingError: APIError<E>
        
        Logger.network.info("⚠️ Response Data:\n\(prettyPrintedJSON(from: data))⚠️")
        
        if let errorType = errorType {
            do {
                let decodedError = try JSONDecoder().decode(errorType, from: data)
                Logger.network.warning("⚠️ WARNING: error. \(decodedError) ⚠️")
                decodingError = APIError<E>.validation(decodedError)
            } catch {
                Logger.network.error("🔴 Error: Decoded validation error. \(error) 🔴")
                decodingError = APIError<E>.decodingFailure(error)
            }
        } else {
            let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            decodingError = APIError<E>.external(
                code: httpResponse.statusCode,
                message: message
            )
        }
        
        
        throw decodingError
    }
    
    private func prettyPrintedJSON(from data: Data) -> String {
        guard
            let object = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return String(data: data, encoding: .utf8) ?? "Failed to format JSON"
        }
        return prettyString
    }
}
