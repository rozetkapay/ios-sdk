//
//  PayService.swift
//
//
//  Created by Ruslan Kasian Dev on 12.09.2024.
//

import Foundation
import OSLog

open class PayService {
    
    static func createPayment(key: String, model: PaymentRequestModel, result: @escaping (PaymentResult) -> Void) {
        result(.cancelled)
//        Task {
//            do {
//                let response = try await TokenizationServiceEndpoint
//                    .tokenizationCard(data: model, apiKey: apiKey)
//                    .execute(TokenizationResponse.self, errorType: TokenizationError.self)
//                
//                Logger.tokenizedCard.info("✅ Success: TokenizedCard is success")
//                
//                result(.success(response.convertToTokenizedCard()))
//            } catch let error as TokenizationError {
//                
//                switch error {
//                case .cancelled:
//                    Logger.tokenizedCard.warning("⚠️ WARNING: TokenizeCard cancelled")
//                case let .failed(message, errorDescription):
//                    Logger.tokenizedCard.warning("⚠️ WARNING: Error tokenizeCard: \n message:\(message ?? "") \n errorDescription: \(errorDescription ?? "")")
//                }
//               
//                result(.failure(error))
//            } catch {
//                result(.failure(.failed(message: nil, errorDescription: error.localizedDescription)))
//                Logger.tokenizedCard.warning("⚠️ WARNING: Error tokenizeCard request: \(error.localizedDescription)")
//            }
//        }
    }
    
    static func paymentInfo(key: String, model: PaymentRequestModel, result: @escaping (PaymentResult) -> Void) {
        result(.complete(orderId: "test", paymentId: "test"))
    }
}

fileprivate enum PayServiceEndpoint: APIConfiguration {
    case createPayment(token: String)
    case paymentInfo(token: String)
    
    var method: HTTPMethod {
        switch self {
        case .createPayment:
            return .POST
        case .paymentInfo:
            return .GET
        }
    }

    
    private var path: String {
        switch self {
        case .createPayment:
            return "/api/payments/v1/new"
        case .paymentInfo:
            return "/api/payments/v1/info"
        }
    }
    
    var endpoint: String {
        switch self {
        case .createPayment,
                .paymentInfo:
           return EnvironmentProviderImpl.environment.paymentsApiProviderUrl + path
        }
    }
    
    var headers: Headers? {
        switch self {
        case let .createPayment(token),
            let .paymentInfo(token):
            return [
                RequestHeaderField.contentType.rawValue: RequestHeaderFieldValue.json.rawValue,
                RequestHeaderField.authorization.rawValue: RequestHeaderFieldValue.basic(token: token).rawValue
            ]
        }
    }

    var body: Encodable? {
        return nil
//        switch self {
//        case let .tokenizationCard(model, _, _):
//            return model
//        }
    }
}
