//
//  ConversationsTVC.swift
//  ZenThea
//
//  Created by felix on 28/01/2025.
//

import UIKit

class ConversationsVC: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateIV: UIImageView!
    @IBOutlet weak var connectionState: UILabel!
    
    private var conversations : [Conversation]!
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ConversationsVC: UITableViewDataSource, UITableViewDelegate, ConversationTVCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // on fait un test
        self.conversations = [
            Conversation("chatGpt", "manger de l'herbe", 0),
            Conversation("Claude AI : emission interessant", "commentaire de l'emission interessant", 1),
            Conversation("abstractionw worlds", "art théorique", 2),
            Conversation("test de conversation", "msg app", 3)
        ]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // affichange de la connexion
        if self.isConnected(){
            self.connectionState.text = "connected"
            self.stateIV! = UIImageView(
                image: UIImage(systemName: "checkmark.circle.fill")
            )
            self.stateIV.tintColor = .green
        } else {
            self.connectionState.text = "disconnected"
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
