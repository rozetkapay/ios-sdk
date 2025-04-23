//
//  ThreeDSWebViewWrapper.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 18.04.2025.
//
import SwiftUI
import WebKit

// MARK: - WebView Wrapper for WKWebView + 3DS Logic
struct ThreeDSWebViewWrapper: UIViewRepresentable {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: ThreeDSViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        let backgroundColor = UIColor(
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface
        )

        webView.backgroundColor = backgroundColor
        webView.scrollView.backgroundColor = backgroundColor
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator

        context.coordinator.webView = webView
        context.coordinator.load3DSUrl()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if viewModel.isRetry {
            context.coordinator.load3DSUrl()
            DispatchQueue.main.async {
                viewModel.isRetry = false
            }
        }
    }

    // MARK: - Navigation Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: ThreeDSViewModel
        weak var webView: WKWebView?

        init(viewModel: ThreeDSViewModel) {
            self.viewModel = viewModel
        }

        func load3DSUrl() {
            guard let webView = webView, let request = viewModel.makeURLRequest() else {
                return
            }
            startLoader(in: webView)
            webView.load(request)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            stopLoader(in: webView)
            guard (error as NSError).code != NSURLErrorCancelled else {
                return
            }
            viewModel.handleFailure(error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            stopLoader(in: webView)

            guard (error as NSError).code != NSURLErrorCancelled else {
                return
            }
            viewModel.handleFailure(error)
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            stopLoader(in: webView)
            if let termUrl = viewModel.request.termUrl,
               let currentUrl = navigationAction.request.url?.absoluteString,
               currentUrl.hasPrefix(termUrl) {
                viewModel.handleSuccess()
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            startLoader(in: webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            stopLoader(in: webView)
        }
        
        private func startLoader(in webView: WKWebView) {
            DispatchQueue.main.async {
                if webView.viewWithTag(999) == nil {
                    let loader = UIActivityIndicatorView(style: .large)
                    loader.center = webView.center
                    loader.tag = 999
                    loader.startAnimating()
                    loader.translatesAutoresizingMaskIntoConstraints = false
                    webView.addSubview(loader)

                    NSLayoutConstraint.activate([
                        loader.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
                        loader.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
                    ])
                }
            }
        }

        private func stopLoader(in webView: WKWebView) {
            DispatchQueue.main.async {
                if let loader = webView.viewWithTag(999) as? UIActivityIndicatorView {
                    loader.stopAnimating()
                    loader.removeFromSuperview()
                }
            }
        }
    }
}
