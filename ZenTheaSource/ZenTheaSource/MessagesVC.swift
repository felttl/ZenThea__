//
//  MessagesMAVC.swift
//  ZenTheaSource
//
//  Created by felix on 02/12/2024.
//
import UIKit

class MessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // pour avoir plus de flexibilité on modifie tout
    // avec la prog pour avoir toutes les options
    // que l'assistant/inspecteur ne propose pas
    private var tableView = UITableView()
    private var messageInputView = UIView()
    private var textField = UITextField()
    private var sendButton = UIButton()
    private var microphoneButton = UIButton()
    
    // identifiant récupéré du controlleur précédent
    public var cid : Int!
    
    private var msgs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.msgs = ConnexionJsonDoc.getConnexion().getConversationDAOs().getMessage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDAOs.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "conversationCell",
            for: indexPath
        ) as! ConversationTVCell
        let conversation = self.messageDAOs[indexPath.row]
        cell.textLabel!.text = conversation.getTitle()
        cell.detailTextLabel!.text = conversation.getSubTitle()
        cell.delegate = self
        return cell
    }
    
    
    
}
