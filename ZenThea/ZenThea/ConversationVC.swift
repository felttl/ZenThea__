//
//  ViewController.swift
//  ZenThea
//
//  Created by Felix Ton that-Lavarini on 21/11/2024.
//

import UIKit

/// chargement de la discussion dans la View
class ConversationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    
    // MARK: prises
    
    @IBOutlet weak var title_: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    /// gère le table view pour afficher la liste des messages
    @IBOutlet weak var tableView: UITableView!
    
    /// appel au chargement de la View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(
            UITableView.self,
            forCellReuseIdentifier: <#T##String#>
        )
        // récupération de données (id) de la vue précédente (discussions)
        
        // 7:25 (cell id = "cell")

    }

    /// renvoie le nombre de messages a afficher
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    /// renvoie une cellule de la tableView pour toutes les iterations des messages
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // afficher une fleche et avertir que c'est clickable
        
        // click long = panneau supprimer + date heure et autres infos
        
    }

}
/// partie données avec get & set
extension ConversationVC{
    
    // MARK: données
    
    /// envoie des données par segue (reciever)(jamais=-1)
    private static var discussionId : Int = -1
    
    // MARK: get set
    
    public static func getDiscussionId() -> Int{
        return ConversationVC.discussionId
    }
    
    public static func setDiscussionId(_ discussionId: Int){
        ConversationVC.discussionId = discussionId
    }
    
    // ///
}

