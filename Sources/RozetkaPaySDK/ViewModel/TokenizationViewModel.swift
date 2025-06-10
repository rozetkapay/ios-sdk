//
//  TokenizationViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI

final class TokenizationViewModel: BaseViewModel {
    
    //MARK: - Properties
    private let onResultCallback: (TokenizationResultCompletionHandler)?
    
    //MARK: - Init
    init(
        parameters: TokenizationParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping TokenizationResultCompletionHandler
    ) {
        self.onResultCallback = onResultCallback
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        setTestData()
    }
}


    //MARK: - Methods
extension TokenizationViewModel {
    func startLoading() {
        guard let validModel: ValidationResultModel = self.validateAll() else {
            return
        }
        let model = CardRequestModel(
            cardName: validModel.cardName,
            cardNumber: validModel.cardNumber,
            cardExpMonth: validModel.cardExpMonth,
            cardExpYear: validModel.cardExpYear,
            cardCvv: validModel.cardCvv,
            cardholderName: validModel.cardholderName,
            customerEmail: validModel.customerEmail
        )
        tokenizeCard(key: client.key, model: model)
    }
    
    func retryLoading() {
        startLoading()
    }
    
    func cancelled() {
        resetState()
        stopLoader()
        
        onResultCallback?(
            .failure(.cancelled)
        )
    }
    
    func resetState() {
        DispatchQueue.main.async {
            self.isError = false
            self.errorMessage = nil
        }
    }
}

//MARK: - Private Methods
private extension TokenizationViewModel {
     func tokenizeCard(key: String, model: CardRequestModel) {
        resetState()
        startLoader()
        
        TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoader()
                
                switch result {
                case .success(let success):
                    self?.isError = false
                    var successModel = success
                    successModel.setup(name: model.cardName)
                    self?.onResultCallback?(
                        .success(successModel)
                    )
                case .failure(let error):
                    switch error {
                    case .cancelled:
                        self?.cancelled()
                    case let .failed(message, _):
                        self?.isError = true
                        self?.errorMessage = message
                    }
                }
            }
        }
    }
}
