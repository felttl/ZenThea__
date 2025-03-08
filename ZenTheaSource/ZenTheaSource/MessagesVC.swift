//
//  MessagesMAVC.swift
//  ZenTheaSource
//
//  Created by felix on 02/12/2024.
//
import UIKit
import Speech // .plist+: Privacy - Speech Recognition Usage Description

class MessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, SFSpeechRecognizerDelegate {

    
    
    // pour avoir plus de flexibilité on modifie tout
    // avec la prog pour avoir toutes les options
    // que l'assistant/inspecteur ne propose pas
    private var tableView = UITableView()
    private var messageInputView = UIView()
    private var textField = UITextField()
    private var sendButton = UIButton()
    // microphone
    private var microphoneButton = UIButton()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine: AVAudioEngine?
    
    // on récupère la liste des messages dans une conversation
    // envoyé par le controleur précédent
    public var cid : Int!
    
    public var convIdx : Int!
    private var isRecording:Bool=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration du microphoneButton
        microphoneButton = UIButton(type: .system)
        // /// partie microphone (text-to-speech et inverse)
//        microphoneButton.addTarget(
//            self, action: #selector(startListening), for: .touchUpInside
//        )
//        view.addSubview(microphoneButton)
//        // Initialisation du SFSpeechRecognizer
//        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr_FR"))
//        speechRecognizer?.delegate = self
//        // Vérification de la disponibilité du reconnaisseur vocal
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            OperationQueue.main.addOperation {
//                switch authStatus {
//                case .authorized:
//                    self.microphoneButton.isEnabled = true
//                case .denied, .restricted, .notDetermined:
//                    self.microphoneButton.isEnabled = false
//                    self.showAudioError("La reconnaissance vocale est désactivée.")
//                default:
//                    break
//                }
//            }
//        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "conv2Messages" {
            if let destinationVC = segue.destination as? ConversationsVC{
                destinationVC.tableView.reloadData()
            }
        } else {
            print("id de segue inconnu (\(segue.identifier!))")
        }
    }
    
    /// démarrer l'enregistrement et la reconnaissance vocale
    @objc func startListening() {
        self.isRecording = !self.isRecording
        if !self.isRecording {
            self.stopRecording()
            return // guard clause
        }

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        // Vérification si le microphone est prêt
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Erreur de configuration de l'audio: \(error.localizedDescription)")
            return
        }

        // Création de la requête de reconnaissance vocale
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        // Initialisation de l'AVAudioEngine
        audioEngine = AVAudioEngine()

        // Connexion du microphone à l'audio engine
        let inputNode = audioEngine!.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine!.prepare()
        do {
            try audioEngine!.start()
        } catch {
            print("Erreur lors du démarrage de l'enregistrement: \(error.localizedDescription)")
            return
        }

        // Commencer la reconnaissance vocale
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            if let error = error {
                self.showAudioError("Erreur de reconnaissance: \(error.localizedDescription)")
                return
            }

            if let result = result {
                let bestTranscription = result.bestTranscription.formattedString
                print("Texte reconnu : \(bestTranscription)")
            }
        }
        
    }
    
    func startRecording() {
        microphoneButton.setImage(
            UIImage(systemName: "record.circle"),
            for: .normal
        )
        if recognitionTask != nil {
           recognitionTask?.cancel()
           recognitionTask = nil
        }
        // Vérification si le microphone est prêt
        let audioSession = AVAudioSession.sharedInstance()
        do {
           try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
           try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
           print("Erreur de configuration de l'audio: \(error.localizedDescription)")
           return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        audioEngine = AVAudioEngine()
        let inputNode = audioEngine!.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
           self.recognitionRequest?.append(buffer)
        }
        audioEngine!.prepare()
        do {
           try audioEngine!.start()
        } catch {
           print("Erreur lors du démarrage de l'enregistrement: \(error.localizedDescription)")
           return
        }
    }
    
    /// arrêter l'enregistrement
    func stopRecording() {
        audioEngine?.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        microphoneButton.setImage(
            UIImage(systemName: "mic.fill"),
            for: .normal
        )
    }

    private func showAudioError(_ message: String) {
        let alertController = UIAlertController(
            title: "Erreur",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        present(alertController, animated: true)
    }
    
    private func loadMessages(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let conv = appDelegate.mediator.getConversation(self.convIdx){
            conv.setMsgs(Message.sortByDate(conv.getMsgs()))
            appDelegate.mediator.setConversation(
                self.convIdx, conv
            )
        }
    }
    
    //MARK: préparation de la vue
    

    
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let conv : Conversation
            conv = appDelegate.mediator.getConversation(self.convIdx)!
            conv.removeMsg(at: indexPath.row) // del dans la db
            tableView.deleteRows(at: [indexPath], with: .automatic) // del dans la view
            appDelegate.mediator.setConversation(indexPath.row,conv)
        }
    }
    


    /// fonction pour envoyer le message dans la view de manière interactive en objc
    @objc func sendMessage() {
        if let text : String = textField.text, !text.isEmpty {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let conv = appDelegate.mediator.getConversation(self.convIdx)!
            conv.addMessage(
                Message(
                    conv.getCid(),
                    conv.getMid(),
                    text,Date(),false
                )
            )
            appDelegate.mediator.setConversation(
                self.convIdx, conv
            )
            // Ajout de la nouvelle ligne au tableau
            let newIndexPath = IndexPath(
                row: conv.getMsgs().count - 1, section: 0
            )
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            textField.text = ""
            scrollToBottom()
        }
    }
    
    /// tasse les messages vers le bas de la view
    func scrollToBottom() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let conv = appDelegate.mediator.getConversation(self.convIdx){
            if conv.getMsgs().count == 0 {
                return
            }
            let indexPath = IndexPath(
                row: conv.getMsgs().count - 1,
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conv = appDelegate.mediator.getConversation(self.convIdx)!
        return conv.getMsgs().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MessageTVCellID",
            for: indexPath
        ) as! GMessageTVCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let conv = appDelegate.mediator.getConversation(self.convIdx)!
        let msg : Message = conv.getMsg(at: indexPath.row)
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
}
