//
//  TokenizationViewModel.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI

final class TokenizationViewModel: BaseViewModel {
    
    private let callback: ((TokenizationResult) -> Void)?
    init(
        parameters: TokenizationParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        callback: @escaping (TokenizationResult) -> Void
    ) {
        self.callback = callback
        super.init(
            client: parameters.client,
            viewParameters: parameters.viewParameters,
            themeConfigurator: parameters.themeConfigurator,
            provideCardPaymentSystemUseCase: provideCardPaymentSystemUseCase ?? ProvideCardPaymentSystemUseCase()
        )
        
        
        
#warning("to do - Удалить тестовые данные")
        cardName = "test"
        cardNumber = "4242 4242 4242 4243"
        expiryDate = "12/29"
        cvv = "123"
        cardholderName = "Test Test"
        email = "casiocompa@gmail.com"
        
    }
    
    override func loading(validModel: ValidationResultModel) {
        let model = CardRequestModel(
            cardNumber: validModel.cardNumber,
            cardExpMonth: validModel.cardExpMonth,
            cardExpYear: validModel.cardExpYear,
            cardCvv: validModel.cardCvv,
            cardholderName: validModel.cardholderName,
            customerEmail: validModel.customerEmail
        )
        tokenizeCard(key: client.key, model: model)
    }
    
    
    override func cancelled() {
        self.isLoading = false
        self.isError = false
        self.errorMessage = nil
        callback?(.failure(.cancelled))
    }
    
    private func tokenizeCard(key: String, model: CardRequestModel) {
        self.isLoading = true
        self.isError = false
        self.errorMessage = nil
        
        TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let success):
                    self?.isError = false
                    self?.callback?(.success(success))
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
