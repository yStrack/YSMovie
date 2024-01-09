//
//  CAGradientLayer+Extension.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(colors: [CGColor], in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors
        layer.frame = frame
        return layer
    }
}
