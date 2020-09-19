//
//  ImpactFeedbackComponent.swift
//  Homeworld
//
//  Created by Christopher Thiebaut on 3/20/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import GameplayKit

class ImpactFeedbackComponent: GKComponent {
    
    let impactFeedbackGenerator: UIImpactFeedbackGenerator
    
    init(feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func impactDetected(){
        impactFeedbackGenerator.impactOccurred()
    }
    
}
