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
    private let textFieldFrameHeightDp: Int
    private let borderWidthDp: Int

    public var sheetCornerRadius: CGFloat {
        return CGFloat(sheetCornerRadiusDp)
    }
    public var componentCornerRadius: CGFloat {
        return CGFloat(componentCornerRadiusDp)
    }
    public var buttonCornerRadius: CGFloat {
        return CGFloat(buttonCornerRadiusDp)
    }
  
    public var textFieldFrameHeight: CGFloat {
        return CGFloat(textFieldFrameHeightDp)
    }
    public var borderWidth: CGFloat {
        return CGFloat(borderWidthDp)
    }

    public init(
        sheetCornerRadius: CGFloat,
        componentCornerRadius: CGFloat,
        buttonCornerRadius: CGFloat,
        textFieldFrameHeight: CGFloat,
        borderWidth: CGFloat
    ) {
        self.sheetCornerRadiusDp = Int(sheetCornerRadius)
        self.componentCornerRadiusDp = Int(componentCornerRadius)
        self.buttonCornerRadiusDp = Int(buttonCornerRadius)
        self.textFieldFrameHeightDp = Int(textFieldFrameHeight)
        self.borderWidthDp = Int(borderWidth)
    }
}
