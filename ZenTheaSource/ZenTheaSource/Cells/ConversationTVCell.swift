//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit

/// actions delegate to perform
protocol ConversationTVCellDelegate : AnyObject {
    func onLongClickEdit(int cell:ConversationTVCell)
}

/// create custom cells
class ConversationTVCell: UITableViewCell {
    
    var delegate : ConversationTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
