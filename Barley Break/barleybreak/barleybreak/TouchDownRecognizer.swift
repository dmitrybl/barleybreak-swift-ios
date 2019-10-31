//
//  SingleTouchDownGestureRecognizer.swift
//  barleybreak
//
//  Created by Dmitry Belyaev on 12/08/2019.
//  Copyright © 2019 Dmitry Belyaev. All rights reserved.
//
import UIKit

class SingleTouchDownGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .recognized
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}
