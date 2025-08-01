//
//  TokenizationView.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//
import SwiftUI

public struct TokenizationView: View {
    
    //MARK: - Properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: TokenizationViewModel
    
    //MARK: - Init
    public init(
        parameters: TokenizationParameters,
        onResultCallback: @escaping TokenizationResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: TokenizationViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback
            )
        )
    }
    
    //MARK: - Body
    public var body: some View {
        NavigationView {
            contentView
                .background(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .surface
                )
        }
    }
}

//MARK: UI
private extension TokenizationView {
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.isError {
            errorView
        } else {
            mainView
        }
        
    }
    
    ///
    var headerView: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(
                    Localization.rozetka_pay_tokenization_title.description
                )
                .font(
                    viewModel
                        .themeConfigurator
                        .typography
                        .title
                )
                .lineSpacing(
                    viewModel
                        .themeConfigurator
                        .typography
                        .titleLineSpacing
                )
                .foregroundColor(
                    viewModel
                        .themeConfigurator
                        .colorScheme(colorScheme)
                        .title
                    
                )
                Spacer()
            }
        }
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            headerView
            cardInfoView
            mainButton
            if viewModel.viewParameters.isVisibleCardInfoLegalView {
                legalView
            }
            Spacer()
        }
        .padding()
        .navigationBarItems(leading: closeButton)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    ///
    var loadingView: some View {
        ZStack {
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface
                .opacity(0.8)
                .ignoresSafeArea()
            LoadingView (themeConfigurator: viewModel.themeConfigurator)
        }
    }
    ///
    var errorView: some View {
        ErrorView(
            themeConfigurator: viewModel.themeConfigurator,
            errorMessage: viewModel.errorMessage,
            onCancel: {
                viewModel.cancelled()
            },
            onRetry: {
                viewModel.retryLoading()
            }
        )
        .padding()
    }
    
    ///
    var cardInfoView: some View {
        CardInfoView(
            viewParameters: viewModel.viewParameters,
            themeConfigurator: viewModel.themeConfigurator,
            cardNumber: $viewModel.cardNumber,
            cvv: $viewModel.cvv,
            expiryDate: $viewModel.expiryDate,
            cardName: $viewModel.cardName,
            cardholderName: $viewModel.cardholderName,
            email: $viewModel.email,
            errorMessageCardNumber: $viewModel.errorMessageCardNumber,
            errorMessageCvv: $viewModel.errorMessageCvv,
            errorMessageExpiryDate: $viewModel.errorMessageExpiryDate,
            errorMessageCardName: $viewModel.errorMessageCardName,
            errorMessageCardholderName: $viewModel.errorMessageCardholderName,
            errorMessageEmail: $viewModel.errorMessageEmail
        )
        .padding(.top, viewModel.getVStackSpacing())
    }
    ///
    var closeButton: some View {
        Button(action: {
            viewModel.cancelled()
            presentationMode.wrappedValue.dismiss()
        }) {
            DomainImages.xmark.image(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
            )
            .renderingMode(.template)
            .foregroundColor(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .appBarIcon
            )
        }
    }
    ///
    var legalView: some View {
        CardInfoFooterView(themeConfigurator: viewModel.themeConfigurator)
            .padding(.top,
                     viewModel
                        .themeConfigurator
                        .sizes
                        .cardInfoLegalViewTopPadding
            )
    }
    
    ///
    private var mainButton: some View {
        Button(action: {
            viewModel.startLoading()
        }) {
            Text(
                Localization.rozetka_pay_form_save_card.description
            )
            .font(
                viewModel
                    .themeConfigurator
                    .typography
                    .labelLarge
            )
            .lineSpacing(
                viewModel
                    .themeConfigurator
                    .typography
                    .labelLargeLineSpacing
            )
            .foregroundColor(
                viewModel
                    .themeConfigurator
                    .colorScheme(colorScheme)
                    .onPrimary
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height:
            viewModel
                .themeConfigurator
                .sizes
                .buttonFrameHeight
        )
        .background(
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .primary
        )
        .cornerRadius(
            viewModel
                .themeConfigurator
                .sizes
                .buttonCornerRadius
        )
        .padding(.top,
                 viewModel
                    .themeConfigurator
                    .sizes
                    .mainButtonTopPadding
        )
    }
}


//MARK: Private Methods
private extension TokenizationView {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

//MARK: Preview
#Preview {
    TokenizationView(
        parameters: TokenizationParameters(
            client: ClientWidgetParameters(widgetKey: "test")
        ),
        onResultCallback: {
            _ in
        })
}
