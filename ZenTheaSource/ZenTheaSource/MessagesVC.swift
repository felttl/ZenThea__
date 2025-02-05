//
//  MessagesMAVC.swift
//  ZenTheaSource
//
//  Created by felix on 02/12/2024.
//
import UIKit

class MessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MessageTVCellDelegate {
    
    // pour avoir plus de flexibilité on modifie tout
    // avec la prog pour avoir toutes les options
    // que l'assistant/inspecteur ne propose pas
    private var tableView = UITableView()
    private var messageInputView = UIView()
    private var textField = UITextField()
    private var sendButton = UIButton()
    private var microphoneButton = UIButton()
    
    // on récupère la liste des messaged dans une conversation
    // envoyé par le controleur précédent
    public var cid : Int!
    public var convMsgs: Conversation!
    private var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for obj in appDelegate.mediator.getConversations(){
            print(obj.getCid())
        }
        print("cid : \(self.cid!)")
        self.user = appDelegate.mediator.getUser() ?? User(Sexe.homme)
        let idx : Int = Conversation.getConversationIdx(
            appDelegate.mediator.getConversations(),
            self.cid
        )!
        self.convMsgs = appDelegate.mediator.getConversations()[idx]
        /// on enregistre la cellule créer programmatiquement
        tableView.register(
            GMessageTVCell.self,
            forCellReuseIdentifier: "MessageTVCellID"
        )
        self.textField.becomeFirstResponder()
        self.setupTableView()
        self.setupInputView()
        self.setupKeyboardObservers()
    }
    
    //MARK: préparation de la vue
    
    /// créer un table view
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // créer l'input formattée
    func setupInputView() {
        messageInputView.backgroundColor = .systemGray6
        messageInputView.layer.cornerRadius = 25
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageInputView)
        
        // Bouton Microphone
        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
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
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .blue
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            messageInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            messageInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageInputView.heightAnchor.constraint(equalToConstant: 50),
            
            microphoneButton.leftAnchor.constraint(equalTo: messageInputView.leftAnchor, constant: 10),
            microphoneButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            microphoneButton.widthAnchor.constraint(equalToConstant: 30),
            microphoneButton.heightAnchor.constraint(equalToConstant: 30),
            
            textField.leftAnchor.constraint(equalTo: microphoneButton.rightAnchor, constant: 10),
            textField.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 35),
            
            sendButton.rightAnchor.constraint(equalTo: messageInputView.rightAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight + 50
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    /// suppression d'un message au clique long
    func onLongClickRemove(int cell: GMessageTVCell) {
        if let indexPath = tableView.indexPath(for: cell), indexPath.row >= 0 && indexPath.row < self.convMsgs.getMsgs().count{
            self.convMsgs.removeMessageIdx(indexPath.row)
        }
    }

    /// fonction pour envoyer le message dans la view de manière interactive en objc
    @objc func sendMessage() {
        if let text : String = textField.text, !text.isEmpty {
            self.convMsgs.addMessageDAO(
                Message(
                    self.convMsgs.getCid(),
                    self.convMsgs.getMid(),
                    text,Date(),false
                )
            )
        }
        textField.text = ""
        tableView.reloadData()
        scrollToBottom()
    }
    
    /// tasse les messages vers le bas de la view
    func scrollToBottom() {
        if self.convMsgs.getMsgs().count > 0 {
            let indexPath = IndexPath(row: self.convMsgs.getMsgs().count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    /// Gestion du clavier avec animations objc
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// lorsque la vue disparait (mise en pause/tache de fond ou suppression de l'app)
    /// on sauvegarde la base de données liée a notre fil de discussion
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.mediator.save()
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
        let aspect : CGFloat = 255.0
        if(msg.getIsReceived()){
            // blue
            cell.backgroundColor = UIColor(
                red: 227.0/aspect,
                green: 220.0/aspect,
                blue: 21.0/aspect,
                alpha: 1.0
            )
        } else {
            // yellow
            cell.backgroundColor = UIColor(
                red: 21.0/aspect,
                green: 129.0/aspect,
                blue: 227.0/aspect,
                alpha: 1.0
            )
        }
        cell.delegate = self
        return cell
    }
    
    
    
}
