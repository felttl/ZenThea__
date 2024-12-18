//
//  DiscussionsTVC.swift
//  proj_ZenThéa
//
//  Created by Felix Ton that-Lavarini on 20/11/2024.
//

import UIKit

class DiscussionsTVC: UITableViewController {
    
    /// remplissage des données de la vue actuelle par segue de la vue précédente
    private static var conversations : [ConversationMO] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // <#warning#> charge les conversations dans la variable privée statique
        
        self.tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /// renvoie le nombre de lignes a afficher par le controleur
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiscussionsTVC.conversations.count
    }
    
    /// charge les cellules a chaque iterations du ViewController
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "aDiscussion",
            for: indexPath
        )
        // <#warning#> récupérations des données de la segue de la view précédente (ConversationVC)
        cell.textLabel!.text = ""
        cell.detailTextLabel!.text = ""

        return cell
    }

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
/// geters & setters
extension DiscussionsTVC {
    /// récupère la liste de conversations stockées dans DiscussionTVC
    public static func getConversations() -> [ConversationMO] {
        return DiscussionsTVC.conversations
    }
    public static func setConversations(_ conv: [ConversationMO]){
        DiscussionsTVC.conversations = conv
    }
}
