//
//  PayService.swift
//
//
//  Created by Ruslan Kasian Dev on 12.09.2024.
//

import Foundation
import OSLog

open class PayService {
    
    static func createPayment(
        key: String,
        model: PaymentRequestModel,
        result: @escaping CreatePaymentResultCompletionHandler
    ) {
        Logger.payServices.info("🔷 Create payment API request start" )
        Task {
            do {
                let response = try await PayServiceEndpoint
                    .createPayment(data: model, key: key)
                    .execute(CreatePaymentResponse.self, errorType: PaymentError.self)
                
                handleCreatePaymentStatuses(orderId: model.externalId, response, result: result)
            } catch let apiError as APIError<PaymentError> {
                Logger.payServices.error("🔴 ERROR: Error createPayment request: \(apiError.localizedDescription)")
                let errorResult = PaymentError.convertFrom(apiError, orderId: model.externalId)
                
                result(
                    .failed(error: errorResult)
                )
            } catch let error {
                
                let errorResult = PaymentError(
                    orderId: model.externalId,
                    errorDescription: error.localizedDescription
                )
                
                Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorResult.localizedDescription)")
                result(
                    .failed(error: errorResult)
                )
            }
        }
    }
    
    static func checkPayment(
        key: String,
        model: CheckPaymentRequestModel,
        result: @escaping PaymentResultCompletionHandler
    ) {

        Task {
            let startTime = Date.now
            let timeout: TimeInterval = RozetkaPayConfig.DEFAULT_RETRY_TIMEOUT
            let delay: TimeInterval = RozetkaPayConfig.DEFAULT_RETRY_DELAY
            
            do {
                var finalResponse: PaymentDetailsResponse?
                
                repeat {
                    let response = try await PayServiceEndpoint
                        .checkPayment(data: model, key: key)
                        .execute(PaymentDetailsResponse.self, errorType: PaymentError.self)
                    
                    if let data = response.convertToCheckPaymentData(paymentId: model.paymentId),
                       data.status.isTerminated {
                        finalResponse = response
                        break
                    }
                    
                    Logger.payServices.info("⚠️ PENDING: Payment has not been terminated yet, retrying after \(Int(delay))s delay")
                    
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    
                } while Date().timeIntervalSince(startTime) < timeout
                
                if let finalResponse = finalResponse {
                    handleCheckPaymentStatuses(finalResponse, model, result: result)
                } else {
                    Logger.payServices.warning("⚠️ Payment status still pending after timeout")
                    let error = PaymentError(
                        code: ErrorResponseCode.pending.rawValue,
                        message: "Payment status still pending after timeout",
                        orderId: model.orderId,
                        paymentId: model.paymentId,
                        type: ErrorResponseType.paymentError.rawValue
                    )
                    
                    result(
                        .pending(
                            orderId: model.orderId,
                            paymentId: model.paymentId,
                            message: error.localizedDescription,
                            error: error
                        )
                    )
                }
            } catch let apiError as APIError<PaymentError> {
                Logger.payServices.error("🔴 ERROR: Error checkPayment request: \(apiError.localizedDescription)")
                let errorResult = PaymentError.convertFrom(apiError, orderId: model.externalId)
                
                result(
                    .failed(error: errorResult)
                )
            } catch let error {
                
                let errorResult = PaymentError(
                    orderId: model.orderId,
                    paymentId: model.paymentId,
                    errorDescription: error.localizedDescription
                )
                
                Logger.payServices.error("🔴 ERROR: Error checkPayment request: \(errorResult.localizedDescription)")
                result(
                    .failed(error: errorResult)
                )
            }
        }
    }
}


private extension PayService {

    static func handleCheckPaymentStatuses(_ response: PaymentDetailsResponse,_ model: CheckPaymentRequestModel, result: @escaping PaymentResultCompletionHandler) {
        
        guard let data = response.convertToCheckPaymentData(paymentId: model.paymentId) else {
            
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToFinishTransaction.rawValue,
                message: "Payment with id \( model.paymentId) not found in purchase details of order \(model.orderId)",
                orderId: model.orderId,
                paymentId: model.paymentId,
                type: ErrorResponseType.paymentError.rawValue
            )
           
            Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorModel.message ?? "")")
            
            result(
                .failed(error: errorModel)
            )
            
            return
        }
        
        switch data.status {
        case .success:
            Logger.payServices.info("✅ Success: Check payment API request success")
            result(
                .complete(
                    orderId: model.orderId,
                    paymentId: model.paymentId ?? "Whithout paymentId"
                )
            )
            
        case .failure:
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToFinishTransaction.rawValue,
                message: data.statusDescription ?? "",
                orderId: model.orderId,
                paymentId: data.paymentId,
                type: ErrorResponseType.paymentError.rawValue
            )
            Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorModel.message ?? "")")
            result(
                .failed(error: errorModel)
            )
            
        case .start, .pending:
            Logger.payServices.info("⚠️ PENDING: Payment with id \( model.paymentId) of order \(model.orderId) has not been terminated yet")
            
            let error = PaymentError(
                code: ErrorResponseCode.pending.rawValue,
                message: "Payment status still pending after timeout",
                paymentId: data.paymentId,
                type: data.statusCode
            )
            
            result(
                .pending(
                    orderId: model.orderId,
                    paymentId: data.paymentId,
                    message: error.localizedDescription,
                    error: error
                )
            )
        }
        
    }
    
    static func handleCreatePaymentStatuses(orderId: String, _ response: CreatePaymentResponse, result: @escaping CreatePaymentResultCompletionHandler) {
        
        let data = response.convertToCreatePaymentData()
        
        switch data.status {
        case .success:
            Logger.payServices.info("✅ Success: Payment is created")
            result(
                .success(
                    orderId: orderId,
                    paymentId: data.paymentId
                )
            )
        case .failure:
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToCreateTransaction.rawValue,
                message: data.statusDescription ?? "",
                orderId: orderId,
                paymentId: data.paymentId,
                type: ErrorResponseType.paymentError.rawValue
            )
            Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorModel.message ?? "")")
            
            result(
                .failed(error: errorModel)
            )
            
        case .start, .pending:
            if case let .confirm3Ds(url) = data.action {
                result(
                    .confirmation3DsRequired(
                        orderId: orderId,
                        paymentId: data.paymentId,
                        url: url,
                        callbackUrl: EnvironmentProvider.environment.paymentsConfirmation3DsCallbackUrl
                    )
                )
            } else {
                
                let errorModel = PaymentError(
                    code: ErrorResponseCode.unknownAction.rawValue,
                    message: "3DS confirmation action expected, but action is \(String(describing: data.action)), payment can't be finished",
                    orderId: orderId,
                    paymentId: data.paymentId,
                    type: ErrorResponseType.unknownAction.rawValue
                )
                Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorModel.localizedDescription)")
                
                result(
                    .failed(error: errorModel)
                )
            }
        }
    }
}



//MARK: - Endpoint
fileprivate enum PayServiceEndpoint: APIConfiguration {
    case createPayment(
        data: PaymentRequestModel,
        key: String
    )
    
    case checkPayment(
        data: CheckPaymentRequestModel,
        key: String
    )
    
    var method: HTTPMethod {
        switch self {
        case .createPayment:
            return .POST
        case .checkPayment:
            return .GET
        }
    }
    
    private var path: String {
        switch self {
        case .createPayment:
            return "/api/payments/v1/new"
        case .checkPayment:
            return "/api/payments/v1/info"
        }
    }
    
    var endpoint: String {
        switch self {
        case .createPayment,
                .checkPayment:
            return EnvironmentProvider.environment.paymentsApiProviderUrl + path
        }
    }
    
    var headers: Headers? {
        switch self {
        case let .createPayment(_, key),
            let .checkPayment(_, key):
            return [
                RequestHeaderField.contentType.rawValue: RequestHeaderFieldValue.json.rawValue,
                RequestHeaderField.authorization.rawValue: RequestHeaderFieldValue.basic(token: key).rawValue
            ]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .checkPayment(model, _):
            return [
                ParametersType.externalId.rawValue: model.externalId
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .createPayment(model, _):
            return model
        default:
            return nil
        }
    }
}
