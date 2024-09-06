////
////  NetworkRequest.swift
////
////
////  Created by Ruslan Kasian Dev on 05.09.2024.
////
//
//import Foundation
//
//public typealias Parameters = [String:Any]
//
//enum HTTPMethod: String {
//    case POST
//    case GET
//}
//
//enum NetworkRequest{
//    //MARK: - Auth
//    case tokenization
//    case createPayment
//    case paymentInfo
//    
//    
//    //MARK: - Path
//    private var path: String {
//        switch self {
//        case .tokenization:
//            return "/api/v2/sdk/tokenize"
//        case .createPayment:
//            return "/api/payments/v1/new"
//        case .paymentInfo:
//            return "/api/payments/v1/info"
//        }
//    }
//    
//    var requestPath: URL? {
//        let str: String
//        
//        switch self {
//        case .tokenization:
//            str = EnvironmentProviderImpl.environment.tokenizationApiProviderUrl + path
//        case .createPayment:
//            str = EnvironmentProviderImpl.environment.paymentsApiProviderUrl + path
//        case .paymentInfo:
//            str = EnvironmentProviderImpl.environment.paymentsApiProviderUrl + path
//        }
//        
//        return URL(string: str)
//    }
//    
//    var method: HTTPMethod {
//        switch self {            
//        case .tokenization:
//            return .POST
//        case .createPayment:
//            return .POST
//        case .paymentInfo:
//            return .GET
//        }
//    }
//    
//    var timeInterval: TimeInterval {
//        return  EnvironmentProviderImpl.environment.timeInterval
//    }
//    
////    func getData(completion: @escaping (Result<Data, Error>) -> Void) {
////        
////        
////    }
////    
////    func getData(completion: @escaping (Result<Data, Error>) -> Void) {
////        guard let request = Request.init(requestData: self) else {
////            return completion(
////                .failure(URLError(.badURL))
////            )
////        }
////        
////        ApiService.dataTask(with: request)
////        
////        
////        
//        
////        ApiService.execute(request: request, success: success, fail: { response in
////            self.validateFail(response, tryAgain: {
////                let request = HTTPMethod.GET.baseRequest(path: self, authorization: authorization).buildRequest()
////                ApiService.execute(request: request, success: success, fail: fail)
////            }, fail: {
////                fail(response)
////            })
////        })
////    }
//        
//        
//        
//}
//
//class ApiService {
//    static let shared = ApiService()
//    
//    func dataTask(with urlRequest: URLRequest) async throws -> (URLResponse, Data) {
//        try await withCheckedThrowingContinuation { continuation in
//            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//                if let error = error {
//                    continuation.resume(throwing: error)
//                    return
//                }
//                guard let response = response, let data = data else {
//                    let error = NSError(domain: "error", code: 0, userInfo: nil)
//                    continuation.resume(throwing: error)
//                    return
//                }
//                continuation.resume(returning: (response, data))
//            }
//            task.resume()
//        }
//    }
//}
//
//
//struct Request {
//    
//    private var request: URLRequest
//    
//    init?(requestData: NetworkRequest){
//        guard let request = requestData.requestPath else {
//            return nil
//        }
//        var baseRequest = URLRequest(
//            url: request,
//            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
//            timeoutInterval: requestData.timeInterval
//        )
//        baseRequest.httpMethod = requestData.method.rawValue
//        Request.setDefaultHeaders(to: &baseRequest)
//        self.request = baseRequest
//    }
//    
//    private static func setDefaultHeaders(to request: inout URLRequest) {
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("XmlHttpRequest", forHTTPHeaderField: "X-Requested-With")
//    }
//    
//    func buildApplicationJSONRequest<T: Codable>(with data: T) -> Request? {
//           do {
//               request.httpBody = try JSONEncoder().encode(data)
//               return Request(urlRequest: request)
//           } catch {
//               return nil
//           }
//       }
//}
//
//
//enum ResponseStatus: Int {
//    case OK = 200
//    case NoContent = 204
//    case BAD_REQUEST = 400
//    case UNAUTHORIZED = 401
//    case Forbidden = 403
//    case NOT_FOUND = 404
//    case TOO_MANY_REQUESTS = 429
//    case INTERNAL_SERVER_ERROR = 500
//}
//
//
////import Foundation
////
////struct APIResponse: Codable {
////    let data: String
////}
////
////func fetchData(from urlString: String) async throws -> APIResponse {
////    // Подготовка URL
////    guard let url = URL(string: urlString) else {
////        throw URLError(.badURL)
////    }
////    
////    // Подготовка запроса
////    var request = URLRequest(url: url)
////    request.httpMethod = "GET"
////    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
////    
////    // Выполнение запроса
////    do {
////        let (data, response) = try await URLSession.shared.data(for: request)
////        
////        // Проверка статуса ответа
////        guard let httpResponse = response as? HTTPURLResponse,
////              (200...299).contains(httpResponse.statusCode) else {
////            throw URLError(.badServerResponse)
////        }
////        
////        // Декодирование ответа
////        let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
////        return decodedResponse
////    } catch {
////        // Обработка ошибок
////        throw error
////    }
////}
////
////// Использование функции
////Task {
////    do {
////        let response = try await fetchData(from: "https://api.example.com/data")
////        print("Data received: \(response.data)")
////    } catch {
////        print("Failed to fetch data: \(error)")
////    }
////}
