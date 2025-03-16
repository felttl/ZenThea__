//
//  GMsgLTVCell.swift
//  ZenTheaSource
//
//

import UIKit


/// create custom cell aligned on left for app messages
/// meaning G : general (class can be reuse in other projects
/// Msg = message
/// LTVCell = LeftTableViewCell
/// all these infos are sorted by importance order (first is the most important)
/// for all messages that are **not received**
class GMsgRTVCell: UITableViewCell {
    
    
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
        //self.messageL.textColor = nil
        self.messageL.translatesAutoresizingMaskIntoConstraints = false
        // setup date label
        self.dateL = UILabel()
        self.dateL.font = UIFont.boldSystemFont(ofSize: 12)
        //self.dateL.textColor = .black
        self.dateL.textAlignment = .right
        self.dateL.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        setupViews()
        bubbleImageView.backgroundColor = UIColor(
            red: colorRatio(255.0),
            green: colorRatio(255.0),
            blue: colorRatio(255.0),
            alpha: 0.5
        )
        messageL.textColor = .black
        dateL.textColor = .black
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public let bubbleImageView: UIImageView
    public let messageL : UILabel
    public let dateL: UILabel
    
    static func getCellId()->String{
        return "GMsgTVCell"
    }
    
    
    /// créer une View correcte pour notre message
    internal func setupViews() {
        // ajout des éléments au bon endroit
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageL)
        bubbleImageView.addSubview(dateL)
        // Contraintes pour la bulle 70% de largeur totale
        self.bubbleImageView.widthAnchor.constraint(
            equalTo: self.contentView.widthAnchor,
            multiplier: 0.7
        ).isActive=true
        NSLayoutConstraint.activate(
            [
                bubbleImageView.topAnchor
                    .constraint(
                        equalTo: contentView.topAnchor,
                        constant: 10
                    ),
                bubbleImageView.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -10
                ),
                bubbleImageView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor,
                    constant: -15
                )
            ]
        )

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
    
    /// fill the cell with informations
    /// - Parameters:
    ///   - message: message displayed inside the cell
    ///   - date: date when the message was sent
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
