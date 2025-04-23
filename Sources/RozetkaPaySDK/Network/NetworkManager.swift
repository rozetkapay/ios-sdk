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
            print("Error encoding body: \(error)")
            return nil
        }
    }
}


public enum APIError<ValidationError: Decodable & Swift.Error>: Swift.Error {
    case decodingFailure(Swift.Error)
    case networkUnreachable
    case external(code: Int, message: String?)
    case validation(ValidationError)
    case unknown
}

extension APIConfiguration {
    var timeInterval: TimeInterval {
        return 60.0
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
            Logger.network.warning("⚠️ WARNING: An error network - badURL. \(URLError(.badURL).localizedDescription) ⚠️")
            throw URLError(.badURL)
        }
        
        do {
            
            Logger.network.info("⚠️ Request.url: \n \(request.urlRequest.debugDescription)\n⚠️")
            Logger.network.info("⚠️ Request: \n \(String(data: request.urlRequest.httpBody ?? Data(), encoding: .utf8).debugDescription ?? "Unable to convert data to String")\n⚠️")
            
            let (response, data) = try await dataTask(with: request.urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                try await self.validateFail(response: response, data: data, errorType: errorType)
                return try await execute(success, errorType: errorType) // Retry request
            }
            
            Logger.network.info("⚠️ Response debugDescription: \n \(response.debugDescription) \n⚠️")
            Logger.network.info("⚠️ Response data: \n \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String") \n⚠️")
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                Logger.network.info(
                    "✅ SUCCESS \n Response: \(response.debugDescription) \n Data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String") ✅"
                )
                return decodedResponse
            } catch let decodingError {
                Logger.network.warning("⚠️ WARNING: An error decodingError. \(decodingError.localizedDescription) ⚠️")
                throw APIError<E>.decodingFailure(decodingError)
            }
        } catch let urlError as URLError {
            Logger.network.warning("⚠️ WARNING: An error network. \(urlError.localizedDescription) ⚠️")
            throw APIError<E>.networkUnreachable
        } catch let apiError as APIError<E> {
            Logger.network.warning("⚠️ WARNING: An error. \(apiError.localizedDescription) ⚠️")
            throw apiError
        } catch {
            switch error {
            case URLError.timedOut, URLError.notConnectedToInternet, URLError.networkConnectionLost:
                Logger.network.warning("⚠️ WARNING: An error network. \(request.urlRequest.debugDescription) ⚠️")
                throw APIError<E>.networkUnreachable
            case is DecodingError:
                throw APIError<E>.decodingFailure(error)
            default:
                Logger.network.warning("⚠️ WARNING: An error network. \(error.localizedDescription) ⚠️")
                throw APIError<E>.unknown
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
            throw APIError<E>.unknown
        }
        
        var decodingError: APIError<E>
        
        if let errorType = errorType {
            do {
                let decodedError = try JSONDecoder().decode(errorType, from: data)
                Logger.network.warning("⚠️ WARNING: Decoded validation error. \(decodedError) ⚠️")
                decodingError = APIError<E>.validation(decodedError)
            } catch {
                decodingError = APIError<E>.decodingFailure(error)
            }
        } else {
            decodingError = APIError<E>.external(
                code: httpResponse.statusCode,
                message: "Unknown error"
            )
        }
        
        
        throw decodingError
    }
    
}
