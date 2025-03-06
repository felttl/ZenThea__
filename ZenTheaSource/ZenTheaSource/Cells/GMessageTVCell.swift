//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit



/// create custom cells
class GMessageTVCell: UITableViewCell {
    
    // label pour le message
    public let messageL : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
     }()

    // label pour afficher la date en bas a droite
    private let dateL: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    /// contrainte système a respecter
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// créer une View correcte pour notre message
    private func setupViews() {
        contentView.addSubview(self.messageL)
        contentView.addSubview(self.dateL)
        // contraites pour avoir les éléments au bon endroit
        NSLayoutConstraint.activate([
            self.messageL.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            self.messageL.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 15
            ),
            self.messageL.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -15
            ),
            self.dateL.topAnchor.constraint(
                equalTo: self.messageL.bottomAnchor,
                constant: 5
            ),
            self.dateL.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -15
            ),
            self.dateL.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            )
        ])
    }
    
    func configure(with message: String, date: String) {
        self.messageL.text = message
        self.dateL.text = date
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    

}
