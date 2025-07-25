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
    private let buttonFrameHeightDp: Int
    private let applePayButtonFrameHeightDp: Int
    private let textFieldFrameHeightDp: Int
    private let borderWidthDp: Int
    private let cardInfoTopPaddingDp: Int
    private let mainButtonTopPaddingDp: Int
    private let cardInfoLegalViewTopPaddingDp: Int

    public var sheetCornerRadius: CGFloat {
        return CGFloat(sheetCornerRadiusDp)
    }
    public var componentCornerRadius: CGFloat {
        return CGFloat(componentCornerRadiusDp)
    }
    public var buttonCornerRadius: CGFloat {
        return CGFloat(buttonCornerRadiusDp)
    }
  
    public var buttonFrameHeight: CGFloat {
        return CGFloat(buttonFrameHeightDp)
    }
    
    public var applePayButtonFrameHeight: CGFloat {
        return CGFloat(applePayButtonFrameHeightDp)
    }
    
    public var textFieldFrameHeight: CGFloat {
        return CGFloat(textFieldFrameHeightDp)
    }
    
    public var borderWidth: CGFloat {
        return CGFloat(borderWidthDp)
    }

    public var cardInfoTopPadding: CGFloat {
        return CGFloat(cardInfoTopPaddingDp)
    }
    
    public var mainButtonTopPadding: CGFloat {
        return CGFloat(mainButtonTopPaddingDp)
    }
    
    public var cardInfoLegalViewTopPadding: CGFloat {
        return CGFloat(cardInfoLegalViewTopPaddingDp)
    }
    
    public init(
        sheetCornerRadius: CGFloat,
        componentCornerRadius: CGFloat,
        buttonCornerRadius: CGFloat,
        buttonFrameHeight: CGFloat,
        applePayButtonFrameHeight: CGFloat,
        textFieldFrameHeight: CGFloat,
        borderWidth: CGFloat,
        cardInfoTopPadding: CGFloat,
        mainButtonTopPadding: CGFloat,
        cardInfoLegalViewTopPadding: CGFloat
    ) {
        self.sheetCornerRadiusDp = Int(sheetCornerRadius)
        self.componentCornerRadiusDp = Int(componentCornerRadius)
        self.buttonCornerRadiusDp = Int(buttonCornerRadius)
        self.buttonFrameHeightDp = Int(buttonFrameHeight)
        self.applePayButtonFrameHeightDp = Int(applePayButtonFrameHeight)
        self.textFieldFrameHeightDp = Int(textFieldFrameHeight)
        self.borderWidthDp = Int(borderWidth)
        self.cardInfoTopPaddingDp = Int(cardInfoTopPadding)
        self.mainButtonTopPaddingDp = Int(mainButtonTopPadding)
        self.cardInfoLegalViewTopPaddingDp = Int(cardInfoLegalViewTopPadding)
    }
}
