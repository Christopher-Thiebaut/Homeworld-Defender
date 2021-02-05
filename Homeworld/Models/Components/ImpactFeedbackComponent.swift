//
//  ImpactFeedbackComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import GameplayKit

class ImpactFeedbackComponent: NonDecodableComponent {
    
    let impactFeedbackGenerator: UIImpactFeedbackGenerator
    
    init(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        super.init()
    }

    func impactDetected(){
        impactFeedbackGenerator.impactOccurred()
    }
    
}
