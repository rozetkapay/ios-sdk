//
//  DomainSizes.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import SwiftUI

public struct DomainSizes {
    private let sheetCornerRadiusDp: Int
    private let componentCornerRadiusDp: Int
    private let buttonCornerRadiusDp: Int
    private let textFieldCornerRadiusDp: Int
    private let textFieldFrameHeightDp: Int
    private let borderWidthDp: Int

    var sheetCornerRadius: CGFloat {
        return CGFloat(sheetCornerRadiusDp)
    }
    var componentCornerRadius: CGFloat {
        return CGFloat(componentCornerRadiusDp)
    }
    var buttonCornerRadius: CGFloat {
        return CGFloat(buttonCornerRadiusDp)
    }
    var textFieldCornerRadius: CGFloat {
        return CGFloat(textFieldCornerRadiusDp)
    }
    var textFieldFrameHeight: CGFloat {
        return CGFloat(textFieldFrameHeightDp)
    }
    var borderWidth: CGFloat {
        return CGFloat(borderWidthDp)
    }

    public init(
        sheetCornerRadius: CGFloat,
        componentCornerRadius: CGFloat,
        buttonCornerRadius: CGFloat,
        textFieldCornerRadius: CGFloat,
        textFieldFrameHeight: CGFloat,
        borderWidth: CGFloat
    ) {
        self.sheetCornerRadiusDp = Int(sheetCornerRadius)
        self.componentCornerRadiusDp = Int(componentCornerRadius)
        self.buttonCornerRadiusDp = Int(buttonCornerRadius)
        self.borderWidthDp = Int(borderWidth)
        self.textFieldCornerRadiusDp = Int(textFieldCornerRadius)
        self.textFieldFrameHeightDp = Int(textFieldFrameHeight)
    }
}
