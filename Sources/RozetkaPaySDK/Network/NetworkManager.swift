//
//  NetworkManager.swift
//
//
//  Created by Ruslan Kasian Dev on 31.08.2024.
//

import Foundation


//protocol NetworkManagerProtocol: AnyObject {
//    func createCard(cardInfo: _ , completion (SomeData) -> ())
//}
//
//class NetworkManager: NetworkManagerProtocol {
//    func func createCard(cardInfo: _ ) {
//        дергаєш розетку
//    }
//}

import Foundation

enum HTTPMethod: String {
    case POST
    case GET
}

enum ApiProvider {
    //MARK: - Auth
    case tokenization(data: CardRequestModel)
    case createPayment
    case paymentInfo
    
    //MARK: - Path
    private var path: String {
        switch self {
        case .tokenization:
            return "/api/v2/sdk/tokenize"
        case .createPayment:
            return "/api/payments/v1/new"
        case .paymentInfo:
            return "/api/payments/v1/info"
        }
    }
    
    var requestPath: URL? {
        let str: String
        
        switch self {
        case .tokenization:
            str = EnvironmentProviderImpl.environment.tokenizationApiProviderUrl + path
        case .createPayment:
            str = EnvironmentProviderImpl.environment.paymentsApiProviderUrl + path
        case .paymentInfo:
            str = EnvironmentProviderImpl.environment.paymentsApiProviderUrl + path
        }
        
        return URL(string: str)
    }
    
    var method: HTTPMethod {
        switch self {
        case .tokenization:
            return .POST
        case .createPayment:
            return .POST
        case .paymentInfo:
            return .GET
        }
    }
    
    var timeInterval: TimeInterval {
        return EnvironmentProviderImpl.environment.timeInterval
    }
    
    var data
}
    
extension ApiProvider {
    
    // Асинхронный запрос данных
    func getData() async throws -> Data {
        guard let request = Request(requestData: self) else {
            throw URLError(.badURL)
        }
        
        let (response, data) = try await ApiService.shared.dataTask(with: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    // Асинхронный метод для отправки данных
    func send<T: Codable>(_ data: T, dataToEncrypt: String? = nil, authorization: Bool = true) async throws -> Data {
        // Проверка на разрешение запроса
        guard allowRequest(authorization: authorization) else {
            throw URLError(.notConnectedToInternet)
        }
        
        // Создание запроса с данными
        guard let request = HTTPMethod.POST.baseRequest(path: self, authorization: authorization, dataToEncrypt: dataToEncrypt).buildApplicationJSONRequest(with: data) else {
            throw URLError(.badURL)
        }
        
        do {
            let (response, data) = try await ApiService.shared.dataTask(with: request.urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                try await self.validateFail(response)
                return try await send(data, dataToEncrypt: dataToEncrypt, authorization: authorization) // Повторная отправка запроса
            }
            
            return data
        } catch {
            throw error
        }
    }
    
    // Проверка разрешения на выполнение запроса
    private func allowRequest(authorization: Bool) -> Bool {
        // Ваш код проверки разрешения запроса
        return true
    }
    
    // Валидация ошибки и повторная отправка при необходимости
    private func validateFail(_ response: URLResponse) async throws {
        // Ваш код валидации и обработки неудачных запросов
    }
}

// Сервис для выполнения запросов
class ApiService {
    static let shared = ApiService()
    
    func dataTask(with urlRequest: URLRequest) async throws -> (URLResponse, Data) {
        try await withCheckedThrowingContinuation { continuation in
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
}

// Структура для создания URLRequest
struct Request {
    let urlRequest: URLRequest
    
    init?(requestData: NetworkRequest) {
        guard let url = requestData.requestPath else {
            return nil
        }
        var baseRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: requestData.timeInterval
        )
        baseRequest.httpMethod = requestData.method.rawValue
        Request.setDefaultHeaders(to: &baseRequest)
        self.urlRequest = baseRequest
    }
    
    private static func setDefaultHeaders(to request: inout URLRequest) {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("XmlHttpRequest", forHTTPHeaderField: "X-Requested-With")
    }
}

// Примеры базовых запросов и методов для сериализации JSON
extension HTTPMethod {
    func baseRequest(path: NetworkRequest, authorization: Bool, dataToEncrypt: String? = nil) -> RequestBuilder {
        // Создание базового запроса и настройка
        RequestBuilder(url: path.requestPath!, method: self)
    }
}

// Построитель запроса
struct RequestBuilder {
    private var request: URLRequest
    
    init(url: URL, method: HTTPMethod) {
        request = URLRequest(url: url)
        request.httpMethod = method.rawValue
    }
    
    func buildApplicationJSONRequest<T: Codable>(with data: T) -> Request? {
        do {
            request.httpBody = try JSONEncoder().encode(data)
            return Request(urlRequest: request)
        } catch {
            return nil
        }
    }
}
