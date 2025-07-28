//
//  TokenizationFormViewModel.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 11.07.2025.
//
import SwiftUI

final class TokenizationFormViewModel: BaseViewModel {
    
    //MARK: - Properties
    private let onResultCallback: (TokenizationFormResultCompletionHandler)?
    private let stateUICallback: (TokenizationFormUIStateCompletionHandler)?
    
    //MARK: - Init
    init(
        parameters: TokenizationFormParameters,
        provideCardPaymentSystemUseCase: ProvideCardPaymentSystemUseCase? = nil,
        onResultCallback: @escaping TokenizationFormResultCompletionHandler,
        stateUICallback: @escaping TokenizationFormUIStateCompletionHandler
    ) {
        self.onResultCallback = onResultCallback
        self.stateUICallback = stateUICallback
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
extension TokenizationFormViewModel {
    
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
}

//MARK: - Private Methods

private extension TokenizationFormViewModel {
    func tokenizeCard(key: String, model: CardRequestModel) {
        
        self.stateUICallback?(
            .startLoading
        )
        
        TokenizationService.tokenizeCard(key: key, model: model) { [weak self] result in
            DispatchQueue.main.async {
                self?.stateUICallback?(
                    .stopLoading
                )
                
                switch result {
                case .complete(let success):
                    self?.isError = false
                    var successModel = success
                    successModel.setup(name: model.cardName)
                    successModel.setup(expiry: "\(model.cardExpMonth)/\(model.cardExpYear)")
                    self?.onResultCallback?(
                        .complete(tokenizedCard: successModel)
                    )
                case .failed(let error):
                    self?.onResultCallback?(
                        .failed(error: error)
                    )
                case .cancelled:
                    self?.onResultCallback?(
                        .cancelled
                    )
                }
            }
        }
    }
}
