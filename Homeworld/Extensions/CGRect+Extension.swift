//
//  CGRect+Extension.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 1/14/21.
//  Copyright © 2021 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
