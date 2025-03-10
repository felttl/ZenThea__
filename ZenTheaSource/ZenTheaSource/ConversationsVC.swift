//
//  ConversationsVC.swift
//  ZenThéaSource
//
//
//

import UIKit

class ConversationsVC: UIViewController {
    
    @IBOutlet weak var sexeSC: UISegmentedControl!
    @IBOutlet weak var connectionStateL: UILabel!
    @IBOutlet weak var stateIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    private var isUserModified : Bool = false
    private var isMsgsModified : Bool = false
    
    // MARK: - Navigation

    /// l'utilisateur crée une conversation
    @IBAction func addConv(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conv : Conversation = Conversation(
            "nouvelle conversation",
            Date()
        )
        appDelegate.mediator.addConversation(conv)
        let idx : Int = appDelegate.mediator.getConversations().count - 1
        let newIndexPath = IndexPath(
            row: idx,
            section: 0
        )
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        self.performSegue(
            withIdentifier: "conv2Messages",
            sender: idx
        )
    }
    
    /// envoie les données dans une autre view
    /// je rapelle que le prepare récupère le sender utilisé dans un performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conv2Messages" {
            if let destinationVC = segue.destination as? MessagesVC{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if let idx = sender as? Int{
                    destinationVC.cid = appDelegate.mediator.getConversation(idx)?.getCid()
                    destinationVC.convIdx = idx
                }
            }
        } else {
            print("error in ConversationsVC.prepare(): unknown segue id: (\(segue.identifier!))")
        }
    }
    
    
    /// lorsque l'utilisateur selectionne une cellule on l'envoie dans la liste d'échanges
    /// on sauvegarde également l'état de l'utilisateur et les modification éventielles
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(
            withIdentifier: "conv2Messages",
            sender: indexPath.row
        )
//        let cell = tableView.cellForRow(at: indexPath) as! ConversationTVCell
//        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTVCell
        cell.backgroundColor = .clear  // Remettre à la couleur d'origine
    }

    
    /// lorsque l'utilisateur clique sur le segmented control
    @IBAction func onChangeSex(_ sender: Any, forEvent event: UIEvent) {
        // si l'utilisateur existe ...
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user : User = appDelegate.mediator.getUser()
        let sexes : [Sexe] = [Sexe.homme,Sexe.femme,Sexe.autre]
        user.setSexe(sexes[self.sexeSC.selectedSegmentIndex])
        appDelegate.mediator.setUser(user)
    }
    
    
}
extension ConversationsVC: UITableViewDataSource, UITableViewDelegate, ConversationTVCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.sexeSC.selectedSegmentIndex = [Sexe.homme,Sexe.femme,Sexe.autre].lastIndex(
            of: appDelegate.mediator.getUser().getSexe()
        )!
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // affichage de la connexion
        if self.isConnected(){
            self.connectionStateL.text = "connecté"
            self.stateIV.image = UIImage(systemName: "checkmark.circle.fill")
            self.stateIV.tintColor = .white
        } else {
            self.connectionStateL.text = "déconnecté"
            self.stateIV.image = UIImage(systemName: "xmark.circle.fill")
            self.stateIV.tintColor = UIColor(
                red: 0.6, green: 0.3, blue: 0.23, alpha: 1.0
            )
        }
        tableView.separatorStyle = .none
    }

    /// vérifie que le serveur est connecté a l'application
    private func isConnected()->Bool{
        var res : Bool = false
        // a implémenter
        return res
    }

    /// lorsque l'utilisateur clique longtemps dessus il
    /// peut modifier le titre d'une conversation
    func onLongClickEdit(in cell: ConversationTVCell) {
        cell.startEditing()
    }

    /// lorsque l'utilisateur a fini de modifier le titre
    func onFinishEditing(in cell: ConversationTVCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let conv = appDelegate.mediator.getConversation(indexPath.row)
            if let titleCell = cell.titleTF.text {
                cell.titleL.text = titleCell
                conv!.setTitle(titleCell)
                appDelegate.mediator.setConversation(indexPath.row, conv!)
            }
        }

    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.mediator.getConversations().count
    }
    
    /// suppression d'une conversation au swipe horizontal (droite ver gauche)
    /// cette méthode n'as pas changé depuis plus de 2 ans
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // manière simple de faire une suppression au swipe
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mediator.removeConv(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
           withIdentifier: "conversationCell",
           for: indexPath
        ) as! ConversationTVCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conversation : Conversation? = appDelegate.mediator.getConversation(indexPath.row)
        cell.dateL.text = getFormattedDate(conversation!.getDate())
        cell.titleL.text = conversation!.getTitle()
        cell.delegate = self
        cell.selectedBackgroundView = UIView()
        cell.accessoryType = .none
        let spaceView = UIView(frame: CGRect(
            x: 0, y: 0,
            width: tableView.frame.width,
            height: cell.contentView.frame.height)
        )
        spaceView.backgroundColor = .clear
        cell.contentView.addSubview(spaceView)
        cell.separatorInset = UIEdgeInsets(
            top: 0, left: 0, bottom: 5, right: 0
        )
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    




    
    
}

