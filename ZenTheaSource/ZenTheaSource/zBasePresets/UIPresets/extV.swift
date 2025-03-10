//
//  extV.swift
//  ZenTheaSource
//
//  Created by felix on 09/03/2025.
//

import UIKit

extension UIView {
    /// arrondis les bords d'une cellule
    public func roundCorner(){
        // nécessite d'être utilisée dans un
        // override func layoutSubviews() pour ne pas avoir de bugs
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
