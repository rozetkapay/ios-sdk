//
//  ThreeDSHandlerView.swift
//  RozetkaPaySDK
//
//  Created by Ruslan Kasian Dev on 15.04.2025.
//

import SwiftUI

// MARK: - Public ThreeDS View Entry Point
struct ThreeDSHandlerView: View {
    //MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    private let themeConfigurator: RozetkaPayThemeConfigurator
    
    @Binding private var isPresented: Bool
    private let request: ThreeDSRequest
    private let onResultCallback: ThreeDSCompletionHandler
    
    init(
        themeConfigurator: RozetkaPayThemeConfigurator,
        request: ThreeDSRequest,
        isPresented: Binding<Bool>,
        onResultCallback: @escaping ThreeDSCompletionHandler
    ) {
        self.themeConfigurator = themeConfigurator
        self.request = request
        self.onResultCallback = onResultCallback
        self._isPresented = isPresented
    }
    
    var body: some View {
        ThreeDSView(
            themeConfigurator: themeConfigurator,
            request: request,
            isPresented: $isPresented,
            onResultCallback: onResultCallback
        )
        .background(
            themeConfigurator
                .colorScheme(colorScheme)
                .surface
        )
        .cornerRadius(
            themeConfigurator
                .sizes
                .sheetCornerRadius
        )
        .padding()
    }
}


//MARK: - Preview
#Preview {
    @State var show3DS = false
    
    ThreeDSHandlerView(
        themeConfigurator: RozetkaPayThemeConfigurator(),
        request: ThreeDSRequest(
            acsUrl: "test",
            termUrl: nil,
            orderId: "test",
            paymentId: "test"
        ),
        isPresented: $show3DS,
        onResultCallback: { result in
            
            print("ThreeDSHandler is \(result)")
        }
    )
    
}
