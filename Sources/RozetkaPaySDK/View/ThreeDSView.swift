//
//  ThreeDSView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 18.04.2025.
//

import SwiftUI


// MARK: - Internal 3DS View with WebView and Cancel Button
struct ThreeDSView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    @StateObject var viewModel: ThreeDSViewModel
    
    //MARK: - Init
    init(
        themeConfigurator: RozetkaPayThemeConfigurator,
        request: ThreeDSRequest,
        isPresented: Binding<Bool>,
        onResultCallback: @escaping ThreeDSCompletionHandler
    ) {
        self._isPresented = isPresented
        let wrappedCallback: ThreeDSCompletionHandler = { result in
            isPresented.wrappedValue = false
            onResultCallback(result)
        }
        
        self._viewModel = StateObject(
            wrappedValue: ThreeDSViewModel(
                themeConfigurator: themeConfigurator,
                request: request,
                onResultCallback: wrappedCallback
            )
        )
        
    }
    
    var body: some View {
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

private extension ThreeDSView {
    
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
    var mainView: some View {
        VStack {
            ThreeDSWebViewWrapper(
                viewModel: viewModel
            )
        }
        .padding()
        .navigationBarItems(
            leading: closeButton
        )
    }
    
    ///
    var closeButton: some View {
        Button(action: {
            viewModel.handleCancelled()
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
    var loadingView: some View {
        ZStack {
            viewModel
                .themeConfigurator
                .colorScheme(colorScheme)
                .surface.opacity(0.8)
                .ignoresSafeArea()
            LoadingView (themeConfigurator: viewModel.themeConfigurator)
        }
    }
    
    ///О
    var errorView: some View {
        ErrorView(
            themeConfigurator: viewModel.themeConfigurator,
            errorMessage: viewModel.error?.localizedDescription,
            onCancel: {
                viewModel.handleCancelled()
            },
            isButtonRetryEnabled: false
        )
        .padding()
    }
}

