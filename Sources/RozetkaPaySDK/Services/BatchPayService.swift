//
//  BatchPayService.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 05.06.2025.
//
import Foundation
import OSLog

open class BatchPayService {
 
    static func createBatchPayment(
        key: String,
        model: BatchPaymentRequestModel,
        result: @escaping CreateBatchPaymentResultCompletionHandler
    ) {
        Logger.payServices.info("🔷 Create batch-payment API request start" )
        Task {
            do {
                let response = try await BatchPayServiceEndpoint
                    .createBatchPayment(data: model, key: key)
                    .execute(CreateBatchPaymentResponse.self, errorType: PaymentError.self)
                
                handleCreateBatchPaymentStatuses(batchExternalId: model.batchExternalId, response, result: result)
            } catch let apiError as APIError<PaymentError> {
                Logger.payServices.error("🔴 ERROR: Error createBatchPayment request: \(apiError.localizedDescription)")
                let errorResult = PaymentError.convertFrom(
                    apiError,
                    externalId: model.batchExternalId
                )
                
                result(
                    .failed(
                        batchExternalId: model.batchExternalId,
                        error: errorResult
                    )
                )
            } catch let error {
                
                let errorResult = PaymentError(
                    externalId: model.batchExternalId,
                    errorDescription: error.localizedDescription
                )
                
                Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorResult.localizedDescription)")
                result(
                    .failed(
                        batchExternalId: model.batchExternalId,
                        error: errorResult
                    )
                )
            }
        }
    }
    
    static func checkBatchPayment(
        key: String,
        model: CheckBatchPaymentRequestModel,
        result: @escaping BatchPaymentResultCompletionHandler
    ) {
        
        Task {
            let startTime = Date.now
            let timeout: TimeInterval = RozetkaPayConfig.DEFAULT_RETRY_TIMEOUT
            let delay: TimeInterval = RozetkaPayConfig.DEFAULT_RETRY_DELAY
            
            do {
                var finalResponse: BatchPaymentDetailsResponse?
                
                repeat {
                    let response = try await BatchPayServiceEndpoint
                        .checkBatchPayment(data: model, key: key)
                        .execute(BatchPaymentDetailsResponse.self, errorType: PaymentError.self)
                    
                    if let data = response.convertToCheckBatchPaymentData(ordersPayments: model.ordersPayments),
                       data.status.isTerminated {
                        finalResponse = response
                        break
                    }
                    
                    Logger.payServices.info("⚠️ PENDING: BatchPayment has not been terminated yet, retrying after \(Int(delay))s delay")
                    
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    
                } while Date().timeIntervalSince(startTime) < timeout
                
                if let finalResponse = finalResponse {
                    handleCheckBatchPaymentStatuses(finalResponse, model, result: result)
                } else {
                    Logger.payServices.warning("⚠️ Payment status still pending after timeout")
                    let error = PaymentError(
                        code: ErrorResponseCode.pending.rawValue,
                        message: "BatchPayment status still pending after timeout",
                        externalId: model.batchExternalId,
                        type: ErrorResponseType.paymentError.rawValue
                    )
                    
                    result(
                        .pending(
                            batchExternalId: model.batchExternalId,
                            ordersPayments: model.ordersPayments,
                            message: error.localizedDescription,
                            error: error
                        )
                    )
                }
            } catch let apiError as APIError<PaymentError> {
                Logger.payServices.error("🔴 ERROR: Error checkBatchPayment request: \(apiError.localizedDescription)")
                let errorResult = PaymentError.convertFrom(apiError, externalId: model.batchExternalId)
                
                result(
                    .failed(
                        batchExternalId: model.batchExternalId,
                        error: errorResult,
                        ordersPayments: model.ordersPayments
                    )
                )
            } catch let error {
                
                let errorResult = PaymentError(
                    externalId: model.batchExternalId,
                    errorDescription: error.localizedDescription
                )
                
                Logger.payServices.error("🔴 ERROR: Error checkBatchPayment request: \(errorResult.localizedDescription)")
                result(
                    .failed(
                        batchExternalId: model.batchExternalId,
                        error: errorResult,
                        ordersPayments: model.ordersPayments
                    )
                )
            }
        }
    }
}

private extension BatchPayService {
    
    static func handleCheckBatchPaymentStatuses(
        _ response: BatchPaymentDetailsResponse,
        _ model: CheckBatchPaymentRequestModel,
        result: @escaping BatchPaymentResultCompletionHandler
    ) {
        
        guard let data = response.convertToCheckBatchPaymentData(ordersPayments: model.ordersPayments) else {
            
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToFinishTransaction.rawValue,
                message: "BatchPayment with id \( model.batchExternalId) not found",
                externalId: model.batchExternalId,
                paymentId: "Without paymentId",
                type: ErrorResponseType.paymentError.rawValue
            )
            
            Logger.payServices.error("🔴 ERROR: Error createBatchPayment request: \(errorModel.message ?? "")")
            
            result(
                .failed(
                    batchExternalId:  model.batchExternalId,
                    error: errorModel,
                    ordersPayments: model.ordersPayments
                )
            )
            
            return
        }
        
        switch data.status {
        case .success:
            Logger.payServices.info("✅ Success: Check batch payment API request success")
            result(
                .complete(
                    batchExternalId: data.batchExternalId,
                    ordersPayments: model.ordersPayments,
                    tokenizedCard: model.tokenizedCard
                )
            )
            
        case .failure:
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToFinishTransaction.rawValue,
                message: data.statusDescription ?? "BatchPayment with id \( model.batchExternalId) is failure",
                externalId: model.batchExternalId,
                type: ErrorResponseType.paymentError.rawValue
            )
            Logger.payServices.error("🔴 ERROR: Error createPayment request: \(errorModel.message ?? "")")
            result(
                .failed(
                    batchExternalId: model.batchExternalId,
                    error: errorModel,
                    ordersPayments: model.ordersPayments
                )
            )
            
        case .start, .pending:
            Logger.payServices.info("⚠️ PENDING: BatchPayment of order \(model.batchExternalId) has not been terminated yet")
            
            let error = PaymentError(
                code: ErrorResponseCode.pending.rawValue,
                message: "BatchPayment status still pending after timeout",
                externalId: model.batchExternalId,
                type: data.statusCode
            )
            
            result(
                .pending(
                    batchExternalId: model.batchExternalId,
                    ordersPayments: model.ordersPayments,
                    message: error.localizedDescription,
                    error: error
                )
            )
        }
        
    }
    
    static func handleCreateBatchPaymentStatuses(
        batchExternalId: String,
        _ response: CreateBatchPaymentResponse,
        result: @escaping CreateBatchPaymentResultCompletionHandler
    ) {
        
        let data = response.convertToCreateBatchPaymentData()
        
        switch data.status {
        case .success:
            Logger.payServices.info("✅ Success: BatchPayment is created")
            result(
                .success(
                    batchExternalId: batchExternalId,
                    ordersPayments: data.ordersPayments
                )
            )
        case .failure:
            let errorModel = PaymentError(
                code: ErrorResponseCode.failedToCreateTransaction.rawValue,
                message: data.statusDescription ?? "",
                externalId: batchExternalId,
                paymentId: data.transactionId,
                type: ErrorResponseType.paymentError.rawValue
            )
            Logger.payServices.error("🔴 ERROR: Error createBatchPayment request: \(errorModel.message ?? "")")
            
            result(
                .failed(
                    batchExternalId: batchExternalId,
                    error: errorModel
                )
            )
            
        case .start, .pending:
            if case let .confirm3Ds(url) = data.action {
                result(
                    .confirmation3DsRequired(
                        batchExternalId: batchExternalId,
                        ordersPayments: data.ordersPayments,
                        url: url,
                        callbackUrl: EnvironmentProvider.environment.paymentsConfirmation3DsCallbackUrl
                    )
                )
            } else {
                
                let errorModel = PaymentError(
                    code: ErrorResponseCode.unknownAction.rawValue,
                    message: "3DS confirmation action expected, but action is \(String(describing: data.action)), batch-payment can't be finished",
                    externalId: batchExternalId,
                    paymentId: data.transactionId,
                    type: ErrorResponseType.unknownAction.rawValue
                )
                Logger.payServices.error("🔴 ERROR: Error createBatchPayment request: \(errorModel.localizedDescription)")
                
                result(
                    .failed(
                        batchExternalId: batchExternalId,
                        error: errorModel
                    )
                )
            }
        }
    }
}

//MARK: - Endpoint
fileprivate enum BatchPayServiceEndpoint: APIConfiguration {

    case createBatchPayment(
        data: BatchPaymentRequestModel,
        key: String
    )
    
    case checkBatchPayment(
        data: CheckBatchPaymentRequestModel,
        key: String
    )
    
    var method: HTTPMethod {
        switch self {
        case .createBatchPayment:
            return .POST
        case .checkBatchPayment:
            return .GET
        }
    }
    
    private var path: String {
        switch self {
        case .createBatchPayment:
            return "/api/payments/batch/v1/new"
        case .checkBatchPayment:
            return "/api/payments/batch/v1/status"
        }
    }
    
    var endpoint: String {
        switch self {
        case .createBatchPayment,
                .checkBatchPayment:
            return EnvironmentProvider.environment.paymentsApiProviderUrl + path
        }
    }
    
    var headers: Headers? {
        switch self {
        case let .createBatchPayment(_, key),
            let .checkBatchPayment(_, key):
            return [
                RequestHeaderField.contentType.rawValue: RequestHeaderFieldValue.json.rawValue,
                RequestHeaderField.authorization.rawValue: RequestHeaderFieldValue.basic(token: key).rawValue
            ]
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .checkBatchPayment(model, _):
            return [
                ParametersType.batchExternalId.rawValue: model.batchExternalId
            ]
        default:
            return nil
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .createBatchPayment(model, _):
            return model
        default:
            return nil
        }
    }
}
