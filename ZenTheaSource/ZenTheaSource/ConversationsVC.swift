//
//  ViewController.swift
//  ZenTheaSource
//
//  Created by felix on 02/02/2025.
//

import UIKit

class ConversationsVC: UIViewController {
    
    @IBOutlet weak var connectionStateL: UILabel!
    @IBOutlet weak var stateIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sexeSC: UISegmentedControl!
    
    private var conversations : [Conversation]!
    private var isUserModified : Bool = false
    private var isMsgsModified : Bool = false
    
    /// l'utilisateur crée une conversation
    @IBAction func ajouterConv(_ sender: Any) {
        self.performSegue(
            withIdentifier: "conv2Messages",
            sender: <#T##Any?#>
        )
    }
    
    /// lorsque l'utilisateur selectionne une cellule on l'envoie dans la liste d'échanges
    /// on sauvegarde également l'état de l'utilisateur et les modification éventielles
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConv = self.
    }

    /// envoie les données dans une autre view
    /// je rapelle que le prepare récupère le sender utilisé dans un performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conv2Messages" {
            if let destinationVC = segue.destination as! MessagesVC{
                destinationVC.cid = 0
            }
        } else {
            print("id de segue inconnu (\(segue.identifier!))")
        }
    }
    
    
    private func testConversations(){
        self.conversations=[
            Conversation("msg test",Date(timeIntervalSinceNow: 30)),
            Conversation("test",Date(timeIntervalSinceNow: 29)),
            Conversation("test 2", Date(timeIntervalSinceNow: 28)),
            Conversation("test 3", Date(timeIntervalSinceNow: 27))
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

