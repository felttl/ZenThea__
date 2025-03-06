//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit



/// create custom cells
class GMessageTVCell: UITableViewCell {
    
    // Bulle de message
    public let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
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
        label.textColor = .white
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
        // ajout des éléments au bon endroit
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageL)
        bubbleImageView.addSubview(dateL)
        // Contraintes pour la bulle
        NSLayoutConstraint.activate([
            bubbleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bubbleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bubbleImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7)
        ])

        // Contraintes pour le message et la date dans la bulle
        NSLayoutConstraint.activate([
            messageL.topAnchor.constraint(equalTo: bubbleImageView.topAnchor, constant: 10),
            messageL.leadingAnchor.constraint(equalTo: bubbleImageView.leadingAnchor, constant: 10),
            messageL.trailingAnchor.constraint(equalTo: bubbleImageView.trailingAnchor, constant: -10),

            dateL.topAnchor.constraint(equalTo: messageL.bottomAnchor, constant: 5),
            dateL.leadingAnchor.constraint(equalTo: bubbleImageView.leadingAnchor, constant: 10),
            dateL.trailingAnchor.constraint(equalTo: bubbleImageView.trailingAnchor, constant: -10),
            dateL.bottomAnchor.constraint(equalTo: bubbleImageView.bottomAnchor, constant: -10)
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
