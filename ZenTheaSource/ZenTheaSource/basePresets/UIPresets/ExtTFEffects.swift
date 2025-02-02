//
//  Effects.swift
//  projet 21 SuivAct
//
//  Created by felix on 05/01/2025.
//

import UIKit

extension UITextField {

    /// secoue une saisie (si elle a échoué par exemple)
    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let shakeAmount: CGFloat = 10.0
        animation.values = [
            NSValue(
                cgPoint: CGPoint(
                    x: self.center.x - shakeAmount,
                    y: self.center.y
                )
            ),
            NSValue(
                cgPoint: CGPoint(
                    x: self.center.x + shakeAmount,
                    y: self.center.y
                )
            ),
            NSValue(
                cgPoint: CGPoint(
                    x: self.center.x - shakeAmount,
                    y: self.center.y
                )
            ),
            NSValue(
                cgPoint: CGPoint(
                    x: self.center.x + shakeAmount,
                    y: self.center.y
                )
            ),
            NSValue(
                cgPoint: CGPoint(
                    x: self.center.x,
                    y: self.center.y
                )
            )
        ]
        animation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        animation.duration = 0.5
        self.layer.add(animation, forKey: "shake")
    }

    
}

