//
//  TokenizationService.swift
//
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation
import OSLog

open class TokenizationService {
    static func tokenizeCard(apiKey: String, model: CardRequestModel, result: @escaping (TokenizationResult) -> Void) {
        Task {
            do {
                let response = try await TokenizationServiceEndpoint
                    .tokenizationCard(data: model, apiKey: apiKey)
                    .execute(TokenizationResponse.self, errorType: TokenizationError.self)
                
                Logger.tokenizedCard.info("✅ Success: TokenizedCard is success")
                
                result(.success(response.convertToTokenizedCard()))
            } catch let error as TokenizationError {
                
                switch error {
                case .cancelled:
                    Logger.tokenizedCard.warning("⚠️ WARNING: TokenizeCard cancelled")
                case let .failed(message, errorDescription):
                    Logger.tokenizedCard.warning("⚠️ WARNING: Error tokenizeCard: \n message:\(message ?? "") \n errorDescription: \(errorDescription ?? "")")
                }
               
                result(.failure(error))
            } catch {
                result(.failure(.failed(message: nil, errorDescription: error.localizedDescription)))
                Logger.tokenizedCard.warning("⚠️ WARNING: Error tokenizeCard request: \(error.localizedDescription)")
            }
        }
    }
}

fileprivate enum TokenizationServiceEndpoint: APIConfiguration {
    case tokenizationCard(
        data: CardRequestModel,
        apiKey: String,
        signer: RequestSignerImpl = RequestSignerImpl()
    )
    
    var method: HTTPMethod {
        return .POST
    }
    
    private var path: String {
        switch self {
        case .tokenizationCard:
            return "/api/v2/sdk/tokenize"
        }
    }
    
    var endpoint: String {
        switch self {
        case .tokenizationCard:
           return EnvironmentProviderImpl.environment.tokenizationApiProviderUrl + path
        }
    }
    
    var headers: Headers? {
        switch self {
        case let .tokenizationCard(model, apiKey, signer):
            do {
                let signature = try signer.sign(key: apiKey, data: model)
                return [
                    RequestHeaderField.contentType.rawValue: RequestHeaderFieldValue.json.rawValue,
                    RequestHeaderField.requested.rawValue: RequestHeaderFieldValue.xml.rawValue,
                    RequestHeaderField.sign.rawValue: signature,
                    RequestHeaderField.widget.rawValue: apiKey
                ]
            } catch {
                Logger.network.warning("⚠️ WARNING: Error signing request: \(error)")
                return nil
            }
        }
    }

    var body: Encodable? {
        switch self {
        case let .tokenizationCard(model, _, _):
            return model
        }
    }
}
