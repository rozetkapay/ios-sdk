//
//  DomainSizes.swift
//
//
//  Created by Ruslan Kasian Dev on 20.08.2024.
//

import UIKit

public struct DomainSizes: Codable {
    let sheetCornerRadiusDp: Int
    let componentCornerRadiusDp: Int
    let buttonCornerRadiusDp: Int
    let borderWidthDp: Int

    var sheetCornerRadius: CGFloat {
        return CGFloat(sheetCornerRadiusDp)
    }
    var componentCornerRadius: CGFloat {
        return CGFloat(componentCornerRadiusDp)
    }
    var buttonCornerRadius: CGFloat {
        return CGFloat(buttonCornerRadiusDp)
    }
    var borderWidth: CGFloat {
        return CGFloat(borderWidthDp)
    }

    public init(
        sheetCornerRadius: CGFloat,
        componentCornerRadius: CGFloat,
        buttonCornerRadius: CGFloat,
        borderWidth: CGFloat
    ) {
        self.sheetCornerRadiusDp = Int(sheetCornerRadius)
        self.componentCornerRadiusDp = Int(componentCornerRadius)
        self.buttonCornerRadiusDp = Int(buttonCornerRadius)
        self.borderWidthDp = Int(borderWidth)
    }
}
