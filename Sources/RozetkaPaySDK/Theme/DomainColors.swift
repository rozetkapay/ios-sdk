//
//  DomainColors.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI
import PassKit

public struct DomainColorScheme {
    private let surfaceHex: UInt
    private let onSurfaceHex: UInt
    private let appBarIconHex: UInt
    private let titleHex: UInt
    private let subtitleHex: UInt
    private let errorHex: UInt
    private let primaryHex: UInt
    private let onPrimaryHex: UInt
    private let placeholderHex: UInt
    private let componentSurfaceHex: UInt
    private let componentDividerHex: UInt
    private let onComponentHex: UInt
    private let applePayButtonStyleDp: PKPaymentButtonStyle

    public var surface: Color {
        return Color(hex: surfaceHex)
    }
    public var onSurface: Color {
        return Color(hex: onSurfaceHex)
    }
    public var appBarIcon: Color {
        return Color(hex: appBarIconHex)
    }
    public var title: Color {
        return Color(hex: titleHex)
    }
    public var subtitle: Color {
        return Color(hex: subtitleHex)
    }
    public var error: Color {
        return Color(hex: errorHex)
    }
    public var primary: Color {
        return Color(hex: primaryHex)
    }
    public var onPrimary: Color {
        return Color(hex: onPrimaryHex)
    }
    public var placeholder: Color {
        return Color(hex: placeholderHex)
    }
    public var componentSurface: Color {
        return Color(hex: componentSurfaceHex)
    }
    public var componentDivider: Color {
        return Color(hex: componentDividerHex)
    }
    public var onComponent: Color {
        return Color(hex: onComponentHex)
    }
    
    public var applePayButtonStyle: PKPaymentButtonStyle {
        return applePayButtonStyleDp
    }

    public init(
        surface: Color,
        onSurface: Color,
        appBarIcon: Color,
        title: Color,
        subtitle: Color,
        error: Color,
        primary: Color,
        onPrimary: Color,
        placeholder: Color,
        componentSurface: Color,
        componentDivider: Color,
        onComponent: Color,
        applePayButtonStyle: PKPaymentButtonStyle
    ) {
        self.surfaceHex = surface.toHex()
        self.onSurfaceHex = onSurface.toHex()
        self.appBarIconHex = appBarIcon.toHex()
        self.titleHex = title.toHex()
        self.subtitleHex = subtitle.toHex()
        self.errorHex = error.toHex()
        self.primaryHex = primary.toHex()
        self.onPrimaryHex = onPrimary.toHex()
        self.placeholderHex = placeholder.toHex()
        self.componentSurfaceHex = componentSurface.toHex()
        self.componentDividerHex = componentDivider.toHex()
        self.onComponentHex = onComponent.toHex()
        self.applePayButtonStyleDp = applePayButtonStyle
    }
}
