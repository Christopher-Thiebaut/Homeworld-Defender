//
//  WeaklyReferencingAgent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/19/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import GameplayKit

protocol WeaklyReferencingAgent: class where Self: GKAgent2D {
    var weakEntity: GKEntity? { get }
}
