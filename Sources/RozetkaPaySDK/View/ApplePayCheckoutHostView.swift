//
//  ApplePayCheckoutHostView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.08.2026.
//
import SwiftUI

/// UI-less host for the imperative Apple Pay flow (`RozetkaPaySdk.payByApplePay`).
///
/// Renders nothing: it starts the Apple Pay sheet as soon as it appears and presents
/// the 3DS screen when the payment requires confirmation. Unlike `ApplePayFormView`
/// it draws no button, so hosts that cannot embed SwiftUI (React Native, UIKit) get
/// the same flow behind a single imperative call.
///
/// Presented by `ApplePayCheckoutPresenter` inside a transparent
/// `UIHostingController`; the presenter tears that overlay down before the terminal
/// result reaches the caller.
struct ApplePayCheckoutHostView: View {

    //MARK: - Properties
    @StateObject private var viewModel: ApplePayFormViewModel
    @State private var didStart = false

    private var tags: AccessibilityTag.ApplePayForm {
        AccessibilityTag.ApplePayForm()
    }

    //MARK: - Inits
    init(
        parameters: ApplePayFormParameters,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: ApplePayFormViewModel(
                parameters: parameters,
                onResultCallback: onResultCallback,
                stateUICallback: { _ in },
                deliversCancelledOnSheetDismiss: true
            )
        )
    }

    init(
        batchParameters: BatchApplePayFormParameters,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler
    ) {
        self._viewModel = StateObject(
            wrappedValue: ApplePayFormViewModel(
                parameters: batchParameters,
                onResultCallback: onResultCallback,
                stateUICallback: { _ in },
                deliversCancelledOnSheetDismiss: true
            )
        )
    }

    //MARK: - Body
    var body: some View {
        Color.clear
            .onAppear(perform: startIfNeeded)
            .fullScreenCover(isPresented: $viewModel.isThreeDSConfirmationPresented) {
                threeDSView
            }
    }
}

//MARK: UI
private extension ApplePayCheckoutHostView {

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

//MARK: - Methods
private extension ApplePayCheckoutHostView {

    /// `onAppear` fires again when the 3DS cover is dismissed, so the payment
    /// must be started exactly once per presentation.
    func startIfNeeded() {
        guard !didStart else {
            return
        }
        didStart = true
        viewModel.startPayByApplePay()
    }
}
