//
//  ViewController.swift
//  ZenTheaSource
//
//  Created by felix on 02/02/2025.
//

import UIKit

class ConversationsVC: UIViewController {

    private var conversationDAOs : [ConversationDAO]!
    
    @IBOutlet weak var connectionStateL: UILabel!
    @IBOutlet weak var stateIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sexeSC: UISegmentedControl!
    
    
    @IBAction func ajouterConv(_ sender: Any) {
        self.performSegue(
            withIdentifier: <#T##String#>,
            sender: <#T##Any?#>
        )
    }
    
    
    private func testConversations(){
        self.conversationDAOs=[
            ConversationDAO(0,"msg test",Date(timeIntervalSinceNow: 30)),
            ConversationDAO(1,"test",Date(timeIntervalSinceNow: 29)),
            ConversationDAO(2, "test 2", Date(timeIntervalSinceNow: 28)),
            ConversationDAO(3, "test 3", Date(timeIntervalSinceNow: 27))
        ]
    }
    
    /// AppDelegate réucupère la liste pour la sauvegarder avant de fermer l'app
    public func getConversations()->[ConversationDAO]{
        return self.conversationDAOs
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
           // a implémenter
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
           return self.conversationDAOs.count
       }

       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(
               withIdentifier: "conversationCell",
               for: indexPath
           ) as! ConversationTVCell
           let conversation = self.conversationDAOs[indexPath.row]
           cell.dateL.text = getFormattedDate(
            conversation.getDate()
           )
           cell.titleL.text = conversation.getTitle()
           cell.delegate = self
           return cell
       }
    
}

