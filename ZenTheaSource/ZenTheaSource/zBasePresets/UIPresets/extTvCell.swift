//
//  extTvCell.swift
//  ZenTheaSource
//
//  Created by felix on 05/02/2025.
//

import UIKit

extension UITableViewCell {
    /// arrondis les bords d'une cellule
    public func roundCorner(){
        // nécessite d'être utilisée dans un
        // override func layoutSubviews() pour ne pas avoir de bugs
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 5
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .white
    }
}
