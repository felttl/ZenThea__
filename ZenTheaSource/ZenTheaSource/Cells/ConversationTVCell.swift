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
    func onLongClickEdit(in cell:ConversationTVCell)
}

/// create custom cells
class ConversationTVCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleTF: UITextField!
    
    var delegate : ConversationTVCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorner()
        self.titleTF.delegate = self
        self.stopEditing() // désactivé par défaut
        let longPressGR = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress)
        )
        self.addGestureRecognizer(longPressGR)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // effet round border
        // Réappliquer les styles pour éviter les resets visuels
        self.roundCorner()
    }

    
    /// lorsque l'utilisateur reste appuyé sur la cellule
    @objc private func handleLongPress(){
        self.delegate?.onLongClickEdit(in: self)
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// one fois que l'utilisateur a cliqué dessus suffisament longtemps
    /// on passe en mode édition en affichant le textfield et en désactivant le label
    func startEditing() {
        self.titleL.isHidden = true
        self.titleTF.isHidden = false
        self.titleTF.text = titleL.text
        self.titleTF.becomeFirstResponder()
    }
    
    /// pareil que startEditing mais dans le sens inverse
    func stopEditing() {
        self.titleL.isHidden = false
        self.titleTF.isHidden = true
        self.titleL.text = self.titleTF.text
        self.roundCorner()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.stopEditing()
        return true
    }
    
}
