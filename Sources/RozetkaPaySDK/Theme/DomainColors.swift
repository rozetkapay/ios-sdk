//
//  DomainColors.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import UIKit
import PassKit

public struct DomainColorScheme {
    let surfaceInt: Int
    let onSurfaceInt: Int
    let appBarIconInt: Int
    let titleInt: Int
    let subtitleInt: Int
    let errorInt: Int
    let primaryInt: Int
    let onPrimaryInt: Int
    let placeholderInt: Int
    let componentSurfaceInt: Int
    let componentDividerInt: Int
    let onComponentInt: Int
    let applePayButtonStyle: PKPaymentButtonStyle

    var surface: UIColor {
        return UIColor(rgb: surfaceInt)
    }
    var onSurface: UIColor {
        return UIColor(rgb: onSurfaceInt)
    }
    var appBarIcon: UIColor {
        return UIColor(rgb: appBarIconInt)
    }
    var title: UIColor {
        return UIColor(rgb: titleInt)
    }
    var subtitle: UIColor {
        return UIColor(rgb: subtitleInt)
    }
    var error: UIColor {
        return UIColor(rgb: errorInt)
    }
    var primary: UIColor {
        return UIColor(rgb: primaryInt)
    }
    var onPrimary: UIColor {
        return UIColor(rgb: onPrimaryInt)
    }
    var placeholder: UIColor {
        return UIColor(rgb: placeholderInt)
    }
    var componentSurface: UIColor {
        return UIColor(rgb: componentSurfaceInt)
    }
    var componentDivider: UIColor {
        return UIColor(rgb: componentDividerInt)
    }
    var onComponent: UIColor {
        return UIColor(rgb: onComponentInt)
    }

    init(
        surface: UIColor,
        onSurface: UIColor,
        appBarIcon: UIColor,
        title: UIColor,
        subtitle: UIColor,
        error: UIColor,
        primary: UIColor,
        onPrimary: UIColor,
        placeholder: UIColor,
        componentSurface: UIColor,
        componentDivider: UIColor,
        onComponent: UIColor,
        applePayButtonStyle: PKPaymentButtonStyle
    ) {
        self.surfaceInt = surface.toInt()
        self.onSurfaceInt = onSurface.toInt()
        self.appBarIconInt = appBarIcon.toInt()
        self.titleInt = title.toInt()
        self.subtitleInt = subtitle.toInt()
        self.errorInt = error.toInt()
        self.primaryInt = primary.toInt()
        self.onPrimaryInt = onPrimary.toInt()
        self.placeholderInt = placeholder.toInt()
        self.componentSurfaceInt = componentSurface.toInt()
        self.componentDividerInt = componentDivider.toInt()
        self.onComponentInt = onComponent.toInt()
        self.applePayButtonStyle = applePayButtonStyle
    }
}

