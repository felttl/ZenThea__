//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit

/// actions delegate to perform
protocol ConversationTVCellDelegate : AnyObject {
    /// clique long on modifie
    func onLongClickEdit(int cell:ConversationTVCell)
}

/// create custom cells
class ConversationTVCell: UITableViewCell {
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    
    var delegate : ConversationTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
