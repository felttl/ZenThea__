//
//  ConversationTVCell.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit



/// create custom cells
class GMessageTVCell: UITableViewCell {
    
    public let bubbleImageView: UIImageView
    public let messageL : UILabel
    public let dateL: UILabel
    
    public var isReceived: Bool!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // setupe message view
        self.bubbleImageView = UIImageView()
        self.bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        self.bubbleImageView.layer.cornerRadius = 15
        self.bubbleImageView.clipsToBounds = true
        self.bubbleImageView.contentMode = .scaleToFill
        // setup message label
        self.messageL = UILabel()
        self.messageL.numberOfLines = 0
        self.messageL.font = UIFont.systemFont(ofSize: 16)
        self.messageL.textColor = .black
        self.messageL.translatesAutoresizingMaskIntoConstraints = false
        // setup date label
        self.dateL = UILabel()
        self.dateL.font = UIFont.boldSystemFont(ofSize: 12)
        self.dateL.textColor = .black
        self.dateL.textAlignment = .right
        self.dateL.translatesAutoresizingMaskIntoConstraints = false

        // only init after creating components
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
            bubbleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        // Contraintes pour le message et la date dans la bulle
        NSLayoutConstraint.activate([
            messageL.topAnchor.constraint(
                equalTo: bubbleImageView.topAnchor, constant: 10
            ),
            messageL.leadingAnchor.constraint(
                equalTo: bubbleImageView.leadingAnchor, constant: 10
            ),
            messageL.trailingAnchor.constraint(
                equalTo: bubbleImageView.trailingAnchor, constant: -10
            ),

            dateL.topAnchor.constraint(
                equalTo: messageL.bottomAnchor, constant: 5
            ),
            dateL.leadingAnchor.constraint(
                equalTo: bubbleImageView.leadingAnchor, constant: 10
            ),
            dateL.trailingAnchor.constraint(
                equalTo: bubbleImageView.trailingAnchor, constant: -10
            ),
            dateL.bottomAnchor.constraint(
                equalTo: bubbleImageView.bottomAnchor, constant: -5
            )
        ])
        
    }
    
    private func customize(){
        // avoir 70% de largeur de des contraintes
        // sur les cotés semple impossible
        var activationList : [NSLayoutConstraint] = [
            // 70% largeur max
            self.bubbleImageView.widthAnchor.constraint(
                equalTo: self.contentView.widthAnchor,
                multiplier: 0.7
            )
        ]
        var color : UIColor
        var dateLColor : UIColor
        var msgLColor : UIColor
        let ratio : CGFloat = 255.0
        // Évite la division par zéro
        let safeRatio = ratio == 0 ? 0.001 : ratio
        if(self.isReceived){
            activationList.append(
                bubbleImageView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: 15
                )
            )
            color = UIColor(
                red: 0.0/safeRatio,
                green: 0.0/safeRatio,
                blue: 0.0/safeRatio,
                alpha: 0.5
            )
            dateLColor = .white
            msgLColor = .white
        } else {
            // white
            color = UIColor(
                red: 255.0/safeRatio,
                green: 255.0/safeRatio,
                blue: 255.0/safeRatio,
                alpha: 0.5
            )
            // Positionner la bulle à droite
            activationList.append(
                self.bubbleImageView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor,
                    constant: -15
                )
            )
            dateLColor = .black
            msgLColor = .black
        }
        NSLayoutConstraint.activate(activationList)
        dateL.textColor  = dateLColor
        messageL.textColor = msgLColor
        self.bubbleImageView.backgroundColor = color
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    func configure(with message: String, date: String,_ isReceived: Bool) {
        self.messageL.text = message
        self.dateL.text = date
        self.isReceived = isReceived
        self.customize()
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// lorsque l'utilisateur clique sur la cellule (mode focus)
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    

}
