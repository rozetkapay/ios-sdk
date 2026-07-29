//
//  ApplePayFormView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.07.2026.
//
import SwiftUI

/// Embeddable Apple Pay button backed by the full RozetkaPay payment flow.
///
/// Unlike `PayView`, this component renders **only** the Apple Pay button and is
/// designed to be dropped inside a host's own screen. Supports both single
/// payments (`ApplePayFormParameters`) and batch payments
/// (`BatchApplePayFormParameters`). The 3DS confirmation screen is presented
/// by the SDK (via `fullScreenCover`), while loading and error presentation
/// are delegated to the host:
/// - `onResultCallback` delivers a terminal `PaymentResult` (or
///   `BatchPaymentResult` for the batch initializer) for every payment attempt.
/// - `stateUICallback` emits `ApplePayFormUIState`
///   (`.startLoading / .stopLoading / .success / .error(String)`) so the host can
///   drive its own loader and show errors in its own UI — the SDK does not render
///   an error screen in this flow.
///
/// The button stays interactive after a failed attempt, so the user can simply
/// tap it again to retry. If Apple Pay is unavailable on the device for the given
/// configuration, the view renders nothing.
public struct ApplePayFormView: View {

    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel: ApplePayFormViewModel

    private var tags: AccessibilityTag.ApplePayForm {
        AccessibilityTag.ApplePayForm()
    }

    //MARK: - Inits
    public init(
        parameters: ApplePayFormParameters,
        onResultCallback: @escaping PaymentResultCompletionHandler,
        stateUICallback: @escaping ApplePayFormUIStateCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: ApplePayFormViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback,
                stateUICallback: stateUICallback
            )
        )
    }

    public init(
        batchParameters: BatchApplePayFormParameters,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler,
        stateUICallback: @escaping ApplePayFormUIStateCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: ApplePayFormViewModel(
                parameters: batchParameters,
                onResultCallback: onResultCallback,
                stateUICallback: stateUICallback
            )
        )
    }

    //MARK: - Body
    public var body: some View {
        contentView
            .fullScreenCover(isPresented: $viewModel.isThreeDSConfirmationPresented) {
                threeDSView
            }
    }
}

//MARK: UI
private extension ApplePayFormView {

    @ViewBuilder
    var contentView: some View {
        if viewModel.isApplePayAvailable {
            applePayButton
        }
    }

    var applePayButton: some View {
        ApplePayButton(
            action: viewModel.startPayByApplePay,
            paymentButtonStyle:
                viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .applePayButtonStyle,
            paymentButtonType: viewModel.applePayButtonType
        )
        .accessibilityIdentifier(tags.applePayButton)
        .frame(
            height:
                viewModel
                .themeConfigurator
                .sizes
                .applePayButtonFrameHeight
        )
        .cornerRadius(
            viewModel
                .themeConfigurator
                .sizes
                .buttonCornerRadius
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    viewModel
                    .themeConfigurator
                    .sizes
                    .buttonCornerRadius
            )
        )
        .disabled(viewModel.isLoading)
    }

    @ViewBuilder
    var threeDSView: some View {
        if let request = viewModel.getThreeDSModel() {
            ThreeDSHandlerView(
                accessibilityNamespace: tags.base,
                themeConfigurator: viewModel.themeConfigurator,
                request: request,
                isPresented: $viewModel.isThreeDSConfirmationPresented,
                onResultCallback: viewModel.handleThreeDSResult
            )
            .accessibilityIdentifier(tags.threeDSView)
        }
    }
}

#Preview {
    ApplePayFormView(
        parameters: ApplePayFormParameters(
            client: ClientAuthParameters(token: "test", widgetKey: "test"),
            applePayConfig: ApplePayConfig.Test(
                merchantIdentifier: "merchant.test"
            ),
            amountParameters: AmountParameters(
                amount: 10000,
                currencyCode: "UAH"
            ),
            externalId: "test"
        ),
        onResultCallback: { _ in },
        stateUICallback: { _ in }
    )
}
