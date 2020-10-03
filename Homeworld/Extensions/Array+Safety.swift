//
//  Array+Safety.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 10/3/20.
//  Copyright © 2020 Christopher Thiebaut. All rights reserved.
//

import Foundation

public extension Array {
    func object(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
}
