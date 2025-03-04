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
    
    
    private var conversations : [Conversation]!
    private var isUserModified : Bool = false
    private var isMsgsModified : Bool = false
    
    

    // MARK: - Navigation


    /// l'utilisateur crée une conversation
    @IBAction func ajouterConv(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.manageUser()
        var convs : [Conversation] = self.conversations
        let conv : Conversation = Conversation("inconnu",Date())
        convs.append(conv)
        appDelegate.mediator.setConversations(convs)
        self.performSegue(
            withIdentifier: "conv2Messages",
            sender: conv.getCid()
        )
    }
    
    /// envoie les données dans une autre view
    /// je rapelle que le prepare récupère le sender utilisé dans un performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conv2Messages" {
            if let destinationVC = segue.destination as? MessagesVC{
                destinationVC.cid = sender as? Int
            }
        } else {
            print("id de segue inconnu (\(segue.identifier!))")
        }
    }
    
    private func manageUser(){
        // si l'utilisateur existe ...
        // si l'utilisateur a modifié l'état de User...
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var user : User? = appDelegate.mediator.getUser()
        let sexes : [Sexe] = [Sexe.homme,Sexe.femme,Sexe.autre]
        if(user == nil){
            user = User(
                sexes[self.sexeSC.selectedSegmentIndex]
            )
        } else if(self.sexeSC.selectedSegmentIndex != 0){
            user!.setSexe(sexes[self.sexeSC.selectedSegmentIndex])
        }
        appDelegate.mediator.setUser(user!)
    }
    
    /// lorsque l'utilisateur selectionne une cellule on l'envoie dans la liste d'échanges
    /// on sauvegarde également l'état de l'utilisateur et les modification éventielles
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedConv : Conversation = self.conversations[indexPath.row]
        self.performSegue(
            withIdentifier: "conv2Messages",
            sender: selectedConv.getCid()
        )
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTVCell
        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.2)  // Assombrir légèrement
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ConversationTVCell
        cell.backgroundColor = .clear  // Remettre à la couleur d'origine
    }



    
}
extension ConversationsVC: UITableViewDataSource, UITableViewDelegate, ConversationTVCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 250
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.conversations = appDelegate.mediator.getConversations()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // affichage de la connexion
        if self.isConnected(){
            self.connectionStateL.text = "connected"
            self.stateIV.image = UIImage(systemName: "checkmark.circle.fill")
            self.stateIV.tintColor = .white
        } else {
            self.connectionStateL.text = "disconnected"
            self.stateIV.image = UIImage(systemName: "xmark.circle.fill")
            self.stateIV.tintColor = UIColor(
                red: 0.6, green: 0.3, blue: 0.23, alpha: 1.0
            )
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
    func onLongClickEdit(in cell: ConversationTVCell) {
        cell.startEditing()
    }


    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversations.count
    }
    
    /// suppression d'une conversation au swipe horizontal (droite ver gauche)
    /// cette méthode n'as pas changé depuis plus de 2 ans
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // manière simple de faire une suppression au swipe
        if editingStyle == .delete{
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
           withIdentifier: "conversationCell",
           for: indexPath
        ) as! ConversationTVCell
        let conversation = self.conversations[indexPath.row]
        cell.dateL.text = getFormattedDate(conversation.getDate())
        cell.titleL.text = conversation.getTitle()
        cell.delegate = self
        cell.selectedBackgroundView = UIView()
        cell.accessoryType = .none
        let disclosureImageView = UIImageView(image:
            UIImage(systemName: "chevron.right")
        )
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        disclosureImageView.tintColor = .systemGray
        cell.contentView.addSubview(disclosureImageView)
        NSLayoutConstraint.activate([
            disclosureImageView.trailingAnchor.constraint(
                equalTo: cell.contentView.trailingAnchor,
                constant: -1
            ),
            disclosureImageView.centerYAnchor.constraint(
                equalTo: cell.contentView.centerYAnchor
            )
        ])
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

