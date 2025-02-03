//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit

/// actions delegate to perform
protocol MessageTVCellDelegate : AnyObject {
    func onLongClickRemove(int cell:MessageTVCell)
}

/// create custom cells
class MessageTVCell: UITableViewCell {
    
    var delegate : MessageTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    

}
