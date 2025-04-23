//
//  TokenizationService.swift
//
//
//  Created by Ruslan Kasian Dev on 05.09.2024.
//

import Foundation
import OSLog

open class TokenizationService {
    
    static func tokenizeCard(key: String, model: CardRequestModel, result: @escaping TokenizationResultCompletionHandler) {
        Task {
            do {
                let response = try await TokenizationServiceEndpoint
                    .tokenizationCard(data: model, key: key)
                    .execute(TokenizationResponse.self, errorType: TokenizationError.self)
                
                Logger.tokenizedCard.info("✅ Success: TokenizedCard is success")
                
                result(
                    .success(response.convertToTokenizedCard())
                )
                
            } catch let apiError as APIError<TokenizationError> {
                Logger.tokenizedCard.error("🔴 ERROR: Error tokenizeCard request: \(apiError.localizedDescription)")
                
                let errorResult = TokenizationError.convertFrom(apiError)
                switch errorResult {
                case .cancelled:
                    Logger.tokenizedCard.warning("⚠️ WARNING: TokenizeCard cancelled")
                case let .failed(message, errorDescription):
                    Logger.tokenizedCard.error("🔴 ERROR: Error tokenizeCard: \n message:\(message ?? "") \n errorDescription: \(errorDescription ?? "")")
                }
                result(
                    .failure(errorResult)
                )
            } catch {
                Logger.tokenizedCard.error("🔴 ERROR: Error tokenizeCard request: \(error.localizedDescription)")
                
                let errorResult: TokenizationError = .failed(
                    message: nil,
                    errorDescription: error.localizedDescription
                )
                result(
                    .failure(errorResult)
                )
            }
        }
    }
    
}

fileprivate enum TokenizationServiceEndpoint: APIConfiguration {
    
    case tokenizationCard(
        data: CardRequestModel,
        key: String,
        signer: RequestSigner = RequestSigner()
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
           return EnvironmentProvider.environment.tokenizationApiProviderUrl + path
        }
    }
    
    var headers: Headers? {
        switch self {
        case let .tokenizationCard(model, key, signer):
            do {
                let signature = try signer.sign(key: key, data: model)
                return [
                    RequestHeaderField.contentType.rawValue: RequestHeaderFieldValue.json.rawValue,
                    RequestHeaderField.requested.rawValue: RequestHeaderFieldValue.xml.rawValue,
                    RequestHeaderField.sign.rawValue: signature,
                    RequestHeaderField.widget.rawValue: key
                ]
            } catch {
                Logger.network.error("🔴 ERROR: Error signing request: \(error)")
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
