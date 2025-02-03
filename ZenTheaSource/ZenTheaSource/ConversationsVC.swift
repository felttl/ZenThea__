//
//  ViewController.swift
//  ZenTheaSource
//
//  Created by felix on 02/02/2025.
//

import UIKit

class ConversationsVC: UIViewController {

    private var conversations : [Conversation]!
    
    @IBOutlet weak var connectionStateL: UILabel!
    @IBOutlet weak var stateIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sexeSC: UISegmentedControl!
    
    private func testConversations(){
        self.conversations = [
            Conversation("chatGpt", "manger de l'herbe", 0),
            Conversation("Claude AI : emission interessant", "commentaire de l'emission interessant", 1),
            Conversation("abstractionw worlds", "art théorique", 2),
            Conversation("test de conversation", "msg app", 3)
        ]

    }
}
extension ConversationsVC: UITableViewDataSource, UITableViewDelegate, ConversationTVCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // on fait un test
        self.testConversations()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // affichange de la connexion
        if self.isConnected(){
            self.connectionStateL.text = "connected"
            self.stateIV! = UIImageView(
                image: UIImage(systemName: "checkmark.circle.fill")
            )
            self.stateIV.tintColor = .green
        } else {
            self.connectionStateL.text = "disconnected"
            self.stateIV! = UIImageView(
                image: UIImage(systemName: "xmark.circle.fill")
            )
            self.stateIV.tintColor = .red
        }
    }

    
       /// vérifie que le serveur est connecté a l'application
       private func isConnected()->Bool{
           var res : Bool = false
           // code a mettre
           return res
       }
       
       /// lorsque l'utilisateur clique longtemps dessus il
       /// peut modifier le titre d'une conversation
       func onLongClickEdit(int cell: ConversationTVCell) {
           // a implémenter
       }
       
       
       // MARK: - Table view data source

       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.conversations.count
       }

       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(
               withIdentifier: "conversationCell",
               for: indexPath
           ) as! ConversationTVCell
           let conversation = self.conversations[indexPath.row]
           cell.textLabel!.text = conversation.getTitle()
           cell.detailTextLabel!.text = conversation.getSubTitle()
           cell.delegate = self
           return cell
       }
    
}

