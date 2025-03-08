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
    
    // on récupère la liste des messages dans une conversation
    // envoyé par le controleur précédent
    public var cid : Int!
    public var convMsgs: Conversation!
    private var user : User!
    private var convIdx : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.user = appDelegate.mediator.getUser()
        self.convIdx = Conversation.getConversationIdx(
            appDelegate.mediator.getConversations(),
            self.cid
        )!
        // sort messages
        self.loadMessages()
        // on enregistre la cellule créer programmatiquement
        tableView.register(
            GMessageTVCell.self,
            forCellReuseIdentifier: "MessageTVCellID"
        )
        self.textField.becomeFirstResponder()
        self.setupInputView()
        self.setupTableView()
        self.setupKeyboardObservers()
    }
    
    private func loadMessages(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.convMsgs = appDelegate.mediator.getConversations()[self.convIdx!]
        let msgs : [Message] = Message.sortByDate(
            self.convMsgs.getMsgs()
        )
        self.convMsgs.setMsgs(msgs)

    }
    
    //MARK: préparation de la vue
    

    
    // créer l'input formattée
    func setupInputView() {
        // couleur de fond zone de texte
        messageInputView.backgroundColor = .systemGray6
        messageInputView.layer.cornerRadius = 25
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputView)
        // Bouton Microphone
        microphoneButton.setImage(
            UIImage(systemName: "mic.fill"),
            for: .normal
        )
        microphoneButton.tintColor = .gray
        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(microphoneButton)
        // TextField
        textField.borderStyle = .none
        textField.placeholder = "Message..."
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(textField)
        // Bouton Envoyer
        sendButton.setImage(
            UIImage(systemName: "paperplane.fill"),
            for: .normal
        )
        sendButton.tintColor = .blue
        sendButton.addTarget(self,
             action: #selector(sendMessage),
             for: .touchUpInside
        )
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            messageInputView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 10
            ),
            messageInputView.rightAnchor.constraint(
                equalTo: view.rightAnchor, constant: -10
            ),
            messageInputView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10
            ),
            messageInputView.heightAnchor.constraint(
                equalToConstant: 50
            ),
            microphoneButton.leftAnchor.constraint(
                equalTo: messageInputView.leftAnchor, constant: 10
            ),
            microphoneButton.centerYAnchor.constraint(
                equalTo: messageInputView.centerYAnchor),
            microphoneButton.widthAnchor.constraint(
                equalToConstant: 30
            ),
            microphoneButton.heightAnchor.constraint(
                equalToConstant: 30
            ),
            textField.leftAnchor.constraint(
                equalTo: microphoneButton.rightAnchor, constant: 10
            ),
            textField.centerYAnchor.constraint(
                equalTo: messageInputView.centerYAnchor
            ),
            textField.rightAnchor.constraint(
                equalTo: sendButton.leftAnchor, constant: -10
            ),
            textField.heightAnchor.constraint(
                equalToConstant: 35
            ),
            
            sendButton.rightAnchor.constraint(
                equalTo: messageInputView.rightAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(
                equalTo: messageInputView.centerYAnchor
            ),
            sendButton.widthAnchor.constraint(
                equalToConstant: 30
            ),
            sendButton.heightAnchor.constraint(
                equalToConstant: 30
            )
        ])
    }
    
    /// créer un table view
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        // supprimer la couleur de fond
        tableView.backgroundColor = UIColor(
            hue: 0.0, saturation: 0.0, brightness: 0.0, alpha: 0.0
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor)
        ])
    }
    
    /// déplace la selection lorsque l'utilisateur affiche un clavier pour écrire
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight + 50
            }
        }
    }
    /// déplace la selection lorsque l'utilisateur a fini d'écrire
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    /// suppression d'un message au swipe horizontal (droite ver gauche)
    /// cette méthode n'as pas changé depuis plus de 2 ans
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // manière simple de faire une suppression au swipe
        if editingStyle == .delete{
            // del dans la db
            self.convMsgs.removeMessageIdx(indexPath.row)
            // del dans la view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            var convs = appDelegate.mediator.getConversations()
            convs[self.convIdx!] = self.convMsgs
            appDelegate.mediator.setConversations(convs)
            appDelegate.mediator.save()
        }
    }
    


    /// fonction pour envoyer le message dans la view de manière interactive en objc
   @objc func sendMessage() {
        guard let text = textField.text, !text.isEmpty else { return }
        let userMessage = Message(self.convMsgs.getCid(), self.convMsgs.getMid(), text, Date(), false)
        self.convMsgs.addMessageDAO(userMessage)
    
        tableView.reloadData()
        scrollToBottom()
        textField.text = ""
    
        //recherche locale dans les documents avec le rag (embeddings + faiss)
        if let results = RAGService.shared.rechercherDocuments(question: text) {
            print("documents pertinents trouvés :", results)
    
            let pendingMessage = Message(self.convMsgs.getCid(), self.convMsgs.getMid(), "...", Date(), true)
            self.convMsgs.addMessageDAO(pendingMessage)
            self.tableView.reloadData()
            self.scrollToBottom()
    
            //envoie la requête à l'api mistral avec les documents trouvés et l'historique de la onversation
            APIService.shared.envoyerMessage(userId: "utilisateur_123", question: text, documents: results, conversation: self.convMsgs) { response in
                DispatchQueue.main.async {
                    if let response = response {
                        //supprime le message temporaire avant d'ajouter la vraie réponse
                        var messages = self.convMsgs.getMsgs()
                        if !messages.isEmpty {
                            messages.removeLast()
                            self.convMsgs.setMsgs(messages)
                        }
    
                        //ajoute la reponse de mistral dans la conversation
                        let aiMessage = Message(self.convMsgs.getCid(), self.convMsgs.getMid(), response.reponseMistral, Date(), true)
                        self.convMsgs.addMessageDAO(aiMessage)
                    } else {
                        print("aucune réponse de mistral")
    
                        //supprime le message temporaire et affiche un message d'erreur
                        var messages = self.convMsgs.getMsgs()
                        if !messages.isEmpty {
                            messages.removeLast()
                            self.convMsgs.setMsgs(messages)
                        }
    
                        let errorMessage = Message(self.convMsgs.getCid(), self.convMsgs.getMid(), "erreur : impossible d'obtenir une réponse.", Date(), true)
                        self.convMsgs.addMessageDAO(errorMessage)
                    }
    
                    //recharge l'affichage
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        } else {
            print("aucunes informations trouvées")
        }
    }
    
    /// tasse les messages vers le bas de la view
    func scrollToBottom() {
        if self.convMsgs.getMsgs().count > 0 {
            let indexPath = IndexPath(
                row: self.convMsgs.getMsgs().count - 1,
                section: 0
            )
            tableView.scrollToRow(
                at: indexPath, at: .bottom,
                animated: true
            )
        }
    }
    
    /// Gestion du clavier avec animations objc
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
           selector: #selector(keyboardWillShow(_:)),
           name: UIResponder.keyboardWillShowNotification,
           object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    
    // MARK: gestion de la table

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.convMsgs.getMsgs().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MessageTVCellID",
            for: indexPath
        ) as! GMessageTVCell
        let msg : Message = self.convMsgs.getMsgs()[indexPath.row]
        cell.configure(
            with: msg.getLabel(),
            date: getFormattedDate(msg.getDate())
        )
        let ratio : CGFloat = 255.0
        let safeRatio = ratio == 0 ? 1 : ratio // Évite la division par zéro
        var color : UIColor?
        if(msg.getIsReceived()){
            // blue
            color = UIColor(
                red: 66.0/safeRatio,
                green: 92.0/safeRatio,
                blue: 237.0/safeRatio,
                alpha: 1.0
            )
            NSLayoutConstraint.activate([
                cell.bubbleImageView.leadingAnchor.constraint(
                    equalTo: cell.contentView.leadingAnchor, constant: 15)
            ])
        } else { // gauche
            // orange
            color = UIColor(
                red: 186.0/safeRatio,
                green: 114.0/safeRatio,
                blue: 6.0/safeRatio,
                alpha: 1.0
            )
            // Positionner la bulle à droite
            NSLayoutConstraint.activate([
                cell.bubbleImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15)
            ])
            
        }
        // 70% largeur max
        NSLayoutConstraint.activate([
            cell.bubbleImageView.widthAnchor.constraint(
                equalTo: cell.contentView.widthAnchor, multiplier: 0.7
            )
        ])
        cell.backgroundColor = .clear
        cell.bubbleImageView.backgroundColor = color!
        //cell.tintColor = color!
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
}
