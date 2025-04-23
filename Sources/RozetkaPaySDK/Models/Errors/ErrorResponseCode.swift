//
//  ErrorResponseCode.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 16.04.2025.
//
import Foundation

public enum ErrorResponseCode: Error, Decodable, Equatable {
    case applePayUnavailable
    case applePayFailed
    case applePayTokenError
    case authorizationFailed
    case customerAuthNotFound
    case requestFailed
    case internalError
    case accessNotAllowed
    case invalidRequestBody
    case paymentSettingsNotFound
    case transactionAlreadyPaid
    case actionNotAllowed
    case actionAlreadyDone
    case transactionSuccessPrimaryNotFound
    case paymentMethodNotAllowed
    case walletNotConfigured
    case paymentMethodAlreadyConfirmed
    case paymentMethodNotFound
    case invalidCardToken
    case customerAuthTokenExpiredOrInvalid
    case customerProfileNotFound
    case customerIdNotPassed
    case transactionNotFound
    case waitingForVerification
    case transactionAmountLimit
    case invalidData
    case transactionDeclined
    case authorizationError
    case transactionRejected
    case transactionSuccessful
    case antiFraudCheck
    case cardNotSupported
    case confirmationTimeout
    case invalidCardData
    case invalidCurrency
    case pending
    case waitingForComplete
    case accessError
    case cardExpired
    case receiverInfoError
    case transactionLimitExceeded
    case transactionNotSupported
    case threeDSNotSupported
    case threeDSRequired
    case failedToCreateTransaction
    case failedToFinishTransaction
    case insufficientFunds
    case invalidPhoneNumber
    case cardHasConstraints
    case pinTriesExceeded
    case sessionExpired
    case timeout
    case transactionCreated
    case waitingForRedirect
    case wrongAmount
    case testTransaction
    case subscriptionSuccessful
    case unsubscribedSuccessfully
    case wrongPin
    case wrongAuthorizationCode
    case wrongCavv
    case wrongCvv
    case wrongAccountNumber
    case confirmRequired
    case cvvIsRequired
    case confirmationRequired
    case senderInfoRequired
    case missedPayoutMethodData
    case cardVerificationRequired
    case incorrectRefundSumOrCurrency
    case paymentCardHasInvalidStatus
    case wrongCardNumber
    case userNotFound
    case failedToSendSms
    case wrongSmsPassword
    case cardNotFound
    case paymentSystemNotSupported
    case countryNotSupported
    case noDiscountFound
    case failedToLoadWallet
    case invalidVerificationCode
    case additionalInformationIsPending
    case transactionIsNotRecurring
    case confirmAmountCannotBeMoreThanTheTransactionAmount
    case cardBinNotFound
    case currencyRateNotFound
    case invalidRecipientName
    case dailyCardUsageLimitReached
    case invalidTransactionAmount
    case cardTypeIsNotSupported
    case storeIsBlocked
    case storeIsNotActive
    case transactionCannotBeProcessed
    case invalidTransactionStatus
    case publicKeyNotFound
    case terminalNotFound
    case feeNotFound
    case failedToVerifyCard
    case invalidTransactionType
    case restrictedIp
    case invalidToken
    case preauthNotAllowed
    case tokenDoesNotExist
    case reachedTheLimitOfAttemptsForIp
    case cardBranchIsBlocked
    case cardBranchDailyLimitReached
    case completionLimitReached
    case recurringTransactionsNotAllowed
    case transactionIsCanceledByPayer
    case paymentWasRefunded
    case cardIsLostOrStolen
    case planNotFound
    case planNotActive
    case subscriptionNotFound
    case subscriptionNotActive
    case orderCanceled
    case tooManyRequests
    case unknownAction
    case networkUnreachable
    case unknown(code: String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = ErrorResponseCode.from(rawValue: raw)
    }

    public static func from(rawValue: String? ) -> ErrorResponseCode {
        guard let rawValue else {
            return .unknown(code: "unknown")
        }
        
        switch rawValue {
        case "apple_pay_unavailable": return .applePayUnavailable
        case "apple_pay_failed": return .applePayFailed
        case "apple_pay_token_error": return .applePayTokenError
        case "authorization_failed": return .authorizationFailed
        case "customer_auth_not_found": return .customerAuthNotFound
        case "request_failed": return .requestFailed
        case "internal_error": return .internalError
        case "access_not_allowed": return .accessNotAllowed
        case "invalid_request_body": return .invalidRequestBody
        case "payment_settings_not_found": return .paymentSettingsNotFound
        case "transaction_already_paid": return .transactionAlreadyPaid
        case "action_not_allowed": return .actionNotAllowed
        case "action_already_done": return .actionAlreadyDone
        case "transaction_success_primary_not_found": return .transactionSuccessPrimaryNotFound
        case "payment_method_not_allowed": return .paymentMethodNotAllowed
        case "wallet_not_configured": return .walletNotConfigured
        case "payment_method_already_confirmed": return .paymentMethodAlreadyConfirmed
        case "payment_method_not_found": return .paymentMethodNotFound
        case "invalid_card_token": return .invalidCardToken
        case "customer_auth_token_expired_or_invalid": return .customerAuthTokenExpiredOrInvalid
        case "customer_profile_not_found": return .customerProfileNotFound
        case "customer_id_not_passed": return .customerIdNotPassed
        case "transaction_not_found": return .transactionNotFound
        case "waiting_for_verification": return .waitingForVerification
        case "transaction_amount_limit": return .transactionAmountLimit
        case "invalid_data": return .invalidData
        case "transaction_declined": return .transactionDeclined
        case "authorization_error": return .authorizationError
        case "transaction_rejected": return .transactionRejected
        case "transaction_successful": return .transactionSuccessful
        case "anti_fraud_check": return .antiFraudCheck
        case "card_not_supported": return .cardNotSupported
        case "confirmation_timeout": return .confirmationTimeout
        case "invalid_card_data": return .invalidCardData
        case "invalid_currency": return .invalidCurrency
        case "pending": return .pending
        case "waiting_for_complete": return .waitingForComplete
        case "access_error": return .accessError
        case "card_expired": return .cardExpired
        case "receiver_info_error": return .receiverInfoError
        case "transaction_limit_exceeded": return .transactionLimitExceeded
        case "transaction_not_supported": return .transactionNotSupported
        case "3ds_not_supported": return .threeDSNotSupported
        case "3ds_required": return .threeDSRequired
        case "failed_to_create_transaction": return .failedToCreateTransaction
        case "failed_to_finish_transaction": return .failedToFinishTransaction
        case "insufficient_funds": return .insufficientFunds
        case "invalid_phone_number": return .invalidPhoneNumber
        case "card_has_constraints": return .cardHasConstraints
        case "pin_tries_exceeded": return .pinTriesExceeded
        case "session_expired": return .sessionExpired
        case "timeout": return .timeout
        case "transaction_created": return .transactionCreated
        case "waiting_for_redirect": return .waitingForRedirect
        case "wrong_amount": return .wrongAmount
        case "test_transaction": return .testTransaction
        case "subscription_successful": return .subscriptionSuccessful
        case "unsubscribed_successfully": return .unsubscribedSuccessfully
        case "wrong_pin": return .wrongPin
        case "wrong_authorization_code": return .wrongAuthorizationCode
        case "wrong_cavv": return .wrongCavv
        case "wrong_cvv": return .wrongCvv
        case "wrong_account_number": return .wrongAccountNumber
        case "confirm_required": return .confirmRequired
        case "cvv_is_required": return .cvvIsRequired
        case "confirmation_required": return .confirmationRequired
        case "sender_info_required": return .senderInfoRequired
        case "missed_payout_method_data": return .missedPayoutMethodData
        case "card_verification_required": return .cardVerificationRequired
        case "incorrect_refund_sum_or_currency": return .incorrectRefundSumOrCurrency
        case "payment_card_has_invalid_status": return .paymentCardHasInvalidStatus
        case "wrong_card_number": return .wrongCardNumber
        case "user_not_found": return .userNotFound
        case "failed_to_send_sms": return .failedToSendSms
        case "wrong_sms_password": return .wrongSmsPassword
        case "card_not_found": return .cardNotFound
        case "payment_system_not_supported": return .paymentSystemNotSupported
        case "country_not_supported": return .countryNotSupported
        case "no_discount_found": return .noDiscountFound
        case "failed_to_load_wallet": return .failedToLoadWallet
        case "invalid_verification_code": return .invalidVerificationCode
        case "additional_information_is_pending": return .additionalInformationIsPending
        case "transaction_is_not_recurring": return .transactionIsNotRecurring
        case "confirm_amount_cannot_be_more_than_the_transaction_amount": return .confirmAmountCannotBeMoreThanTheTransactionAmount
        case "card_bin_not_found": return .cardBinNotFound
        case "currency_rate_not_found": return .currencyRateNotFound
        case "invalid_recipient_name": return .invalidRecipientName
        case "daily_card_usage_limit_reached": return .dailyCardUsageLimitReached
        case "invalid_transaction_amount": return .invalidTransactionAmount
        case "card_type_is_not_supported": return .cardTypeIsNotSupported
        case "store_is_blocked": return .storeIsBlocked
        case "store_is_not_active": return .storeIsNotActive
        case "transaction_cannot_be_processed": return .transactionCannotBeProcessed
        case "invalid_transaction_status": return .invalidTransactionStatus
        case "public_key_not_found": return .publicKeyNotFound
        case "terminal_not_found": return .terminalNotFound
        case "fee_not_found": return .feeNotFound
        case "failed_to_verify_card": return .failedToVerifyCard
        case "invalid_transaction_type": return .invalidTransactionType
        case "restricted_ip": return .restrictedIp
        case "invalid_token": return .invalidToken
        case "preauth_not_allowed": return .preauthNotAllowed
        case "token_does_not_exist": return .tokenDoesNotExist
        case "reached_the_limit_of_attempts_for_ip": return .reachedTheLimitOfAttemptsForIp
        case "card_branch_is_blocked": return .cardBranchIsBlocked
        case "card_branch_daily_limit_reached": return .cardBranchDailyLimitReached
        case "completion_limit_reached": return .completionLimitReached
        case "recurring_transactions_not_allowed": return .recurringTransactionsNotAllowed
        case "transaction_is_canceled_by_payer": return .transactionIsCanceledByPayer
        case "payment_was_refunded": return .paymentWasRefunded
        case "card_is_lost_or_stolen": return .cardIsLostOrStolen
        case "plan_not_found": return .planNotFound
        case "plan_not_active": return .planNotActive
        case "subscription_not_found": return .subscriptionNotFound
        case "subscription_not_active": return .subscriptionNotActive
        case "order_canceled": return .orderCanceled
        case "too_many_requests": return .tooManyRequests
        case "unknown_action": return .unknownAction
        case "network_unreachable": return .networkUnreachable
        default: return .unknown(code: rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .applePayFailed: return "apple_pay_failed"
        case .applePayUnavailable: return "apple_pay_unavailable"
        case .applePayTokenError: return "apple_pay_token_error"
        case .authorizationFailed: return "authorization_failed"
        case .customerAuthNotFound: return "customer_auth_not_found"
        case .requestFailed: return "request_failed"
        case .internalError: return "internal_error"
        case .accessNotAllowed: return "access_not_allowed"
        case .invalidRequestBody: return "invalid_request_body"
        case .paymentSettingsNotFound: return "payment_settings_not_found"
        case .transactionAlreadyPaid: return "transaction_already_paid"
        case .actionNotAllowed: return "action_not_allowed"
        case .actionAlreadyDone: return "action_already_done"
        case .transactionSuccessPrimaryNotFound: return "transaction_success_primary_not_found"
        case .paymentMethodNotAllowed: return "payment_method_not_allowed"
        case .walletNotConfigured: return "wallet_not_configured"
        case .paymentMethodAlreadyConfirmed: return "payment_method_already_confirmed"
        case .paymentMethodNotFound: return "payment_method_not_found"
        case .invalidCardToken: return "invalid_card_token"
        case .customerAuthTokenExpiredOrInvalid: return "customer_auth_token_expired_or_invalid"
        case .customerProfileNotFound: return "customer_profile_not_found"
        case .customerIdNotPassed: return "customer_id_not_passed"
        case .transactionNotFound: return "transaction_not_found"
        case .waitingForVerification: return "waiting_for_verification"
        case .transactionAmountLimit: return "transaction_amount_limit"
        case .invalidData: return "invalid_data"
        case .transactionDeclined: return "transaction_declined"
        case .authorizationError: return "authorization_error"
        case .transactionRejected: return "transaction_rejected"
        case .transactionSuccessful: return "transaction_successful"
        case .antiFraudCheck: return "anti_fraud_check"
        case .cardNotSupported: return "card_not_supported"
        case .confirmationTimeout: return "confirmation_timeout"
        case .invalidCardData: return "invalid_card_data"
        case .invalidCurrency: return "invalid_currency"
        case .pending: return "pending"
        case .waitingForComplete: return "waiting_for_complete"
        case .accessError: return "access_error"
        case .cardExpired: return "card_expired"
        case .receiverInfoError: return "receiver_info_error"
        case .transactionLimitExceeded: return "transaction_limit_exceeded"
        case .transactionNotSupported: return "transaction_not_supported"
        case .threeDSNotSupported: return "3ds_not_supported"
        case .threeDSRequired: return "3ds_required"
        case .failedToCreateTransaction: return "failed_to_create_transaction"
        case .failedToFinishTransaction: return "failed_to_finish_transaction"
        case .insufficientFunds: return "insufficient_funds"
        case .invalidPhoneNumber: return "invalid_phone_number"
        case .cardHasConstraints: return "card_has_constraints"
        case .pinTriesExceeded: return "pin_tries_exceeded"
        case .sessionExpired: return "session_expired"
        case .timeout: return "timeout"
        case .transactionCreated: return "transaction_created"
        case .waitingForRedirect: return "waiting_for_redirect"
        case .wrongAmount: return "wrong_amount"
        case .testTransaction: return "test_transaction"
        case .subscriptionSuccessful: return "subscription_successful"
        case .unsubscribedSuccessfully: return "unsubscribed_successfully"
        case .wrongPin: return "wrong_pin"
        case .wrongAuthorizationCode: return "wrong_authorization_code"
        case .wrongCavv: return "wrong_cavv"
        case .wrongCvv: return "wrong_cvv"
        case .wrongAccountNumber: return "wrong_account_number"
        case .confirmRequired: return "confirm_required"
        case .cvvIsRequired: return "cvv_is_required"
        case .confirmationRequired: return "confirmation_required"
        case .senderInfoRequired: return "sender_info_required"
        case .missedPayoutMethodData: return "missed_payout_method_data"
        case .cardVerificationRequired: return "card_verification_required"
        case .incorrectRefundSumOrCurrency: return "incorrect_refund_sum_or_currency"
        case .paymentCardHasInvalidStatus: return "payment_card_has_invalid_status"
        case .wrongCardNumber: return "wrong_card_number"
        case .userNotFound: return "user_not_found"
        case .failedToSendSms: return "failed_to_send_sms"
        case .wrongSmsPassword: return "wrong_sms_password"
        case .cardNotFound: return "card_not_found"
        case .paymentSystemNotSupported: return "payment_system_not_supported"
        case .countryNotSupported: return "country_not_supported"
        case .noDiscountFound: return "no_discount_found"
        case .failedToLoadWallet: return "failed_to_load_wallet"
        case .invalidVerificationCode: return "invalid_verification_code"
        case .additionalInformationIsPending: return "additional_information_is_pending"
        case .transactionIsNotRecurring: return "transaction_is_not_recurring"
        case .confirmAmountCannotBeMoreThanTheTransactionAmount: return "confirm_amount_cannot_be_more_than_the_transaction_amount"
        case .cardBinNotFound: return "card_bin_not_found"
        case .currencyRateNotFound: return "currency_rate_not_found"
        case .invalidRecipientName: return "invalid_recipient_name"
        case .dailyCardUsageLimitReached: return "daily_card_usage_limit_reached"
        case .invalidTransactionAmount: return "invalid_transaction_amount"
        case .cardTypeIsNotSupported: return "card_type_is_not_supported"
        case .storeIsBlocked: return "store_is_blocked"
        case .storeIsNotActive: return "store_is_not_active"
        case .transactionCannotBeProcessed: return "transaction_cannot_be_processed"
        case .invalidTransactionStatus: return "invalid_transaction_status"
        case .publicKeyNotFound: return "public_key_not_found"
        case .terminalNotFound: return "terminal_not_found"
        case .feeNotFound: return "fee_not_found"
        case .failedToVerifyCard: return "failed_to_verify_card"
        case .invalidTransactionType: return "invalid_transaction_type"
        case .restrictedIp: return "restricted_ip"
        case .invalidToken: return "invalid_token"
        case .preauthNotAllowed: return "preauth_not_allowed"
        case .tokenDoesNotExist: return "token_does_not_exist"
        case .reachedTheLimitOfAttemptsForIp: return "reached_the_limit_of_attempts_for_ip"
        case .cardBranchIsBlocked: return "card_branch_is_blocked"
        case .cardBranchDailyLimitReached: return "card_branch_daily_limit_reached"
        case .completionLimitReached: return "completion_limit_reached"
        case .recurringTransactionsNotAllowed: return "recurring_transactions_not_allowed"
        case .transactionIsCanceledByPayer: return "transaction_is_canceled_by_payer"
        case .paymentWasRefunded: return "payment_was_refunded"
        case .cardIsLostOrStolen: return "card_is_lost_or_stolen"
        case .planNotFound: return "plan_not_found"
        case .planNotActive: return "plan_not_active"
        case .subscriptionNotFound: return "subscription_not_found"
        case .subscriptionNotActive: return "subscription_not_active"
        case .orderCanceled: return "order_canceled"
        case .tooManyRequests: return "too_many_requests"
        case .unknownAction: return "unknown_action"
        case .networkUnreachable: return "network_unreachable"
        case .unknown(let code): return code
        }
    }
}
