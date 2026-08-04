//
//  ApplePayCheckoutPresenter.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 03.08.2026.
//
import SwiftUI

/// Hosts `ApplePayCheckoutHostView` in a transparent modal controller and keeps
/// itself alive until the flow delivers its terminal result.
///
/// The overlay is required because the SDK presents the 3DS screen through SwiftUI
/// (`fullScreenCover`) — the imperative entry points (`RozetkaPaySdk.payByApplePay`)
/// have no view of their own to attach it to.
@MainActor
final class ApplePayCheckoutPresenter {

    /// Presenters of the flows currently in progress. Without this the presenter would
    /// be released as soon as `payByApplePay` returns, since the caller holds no reference.
    private static var active: [ApplePayCheckoutPresenter] = []

    private var overlay: UIViewController?

    //MARK: - Presenting
    static func present(
        parameters: ApplePayFormParameters,
        on host: UIViewController,
        onResultCallback: @escaping PaymentResultCompletionHandler
    ) {
        let presenter = ApplePayCheckoutPresenter()
        active.append(presenter)

        let contentView = ApplePayCheckoutHostView(
            parameters: parameters,
            onResultCallback: { [weak presenter] result in
                presenter?.finish { onResultCallback(result) }
            }
        )

        presenter.show(AnyView(contentView), on: host)
    }

    static func present(
        batchParameters: BatchApplePayFormParameters,
        on host: UIViewController,
        onResultCallback: @escaping BatchPaymentResultCompletionHandler
    ) {
        let presenter = ApplePayCheckoutPresenter()
        active.append(presenter)

        let contentView = ApplePayCheckoutHostView(
            batchParameters: batchParameters,
            onResultCallback: { [weak presenter] result in
                presenter?.finish { onResultCallback(result) }
            }
        )

        presenter.show(AnyView(contentView), on: host)
    }

    /// Top-most presented controller of the key window, used when the host does not
    /// pass a presenting controller explicitly.
    static func topMostViewController() -> UIViewController? {
        var controller = RozetkaPaySdk.appContext.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController

        while let presented = controller?.presentedViewController {
            controller = presented
        }

        return controller
    }
}

//MARK: - Private Methods
private extension ApplePayCheckoutPresenter {

    func show(_ contentView: AnyView, on host: UIViewController) {
        let controller = UIHostingController(rootView: contentView)
        controller.view.backgroundColor = .clear
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        self.overlay = controller
        host.present(controller, animated: false)
    }

    /// Dismisses the overlay, hands the result to the caller and releases the presenter.
    func finish(_ deliverResult: @escaping () -> Void) {
        guard let overlay = self.overlay else {
            deliverResult()
            Self.release(self)
            return
        }

        self.overlay = nil
        overlay.dismiss(animated: false) {
            deliverResult()
            Self.release(self)
        }
    }

    static func release(_ presenter: ApplePayCheckoutPresenter) {
        active.removeAll { $0 === presenter }
    }
}
