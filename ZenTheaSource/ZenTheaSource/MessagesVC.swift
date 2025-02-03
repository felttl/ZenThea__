//
//  MessagesMAVC.swift
//  ZenTheaSource
//
//  Created by felix on 02/12/2024.
//
import UIKit

class MessagesVC: UIViewController {
    
    // données récupérées du controlleur précédent
    private var messageDAOs : [MessageDAO] = []
    
    private var msgid: String = "messageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
extension MessagesVC: UITableViewDataSource, UITableViewDelegate{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDAOs.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "conversationCell",
            for: indexPath
        ) as! ConversationTVCell
        let conversation = self.messageDAOs[indexPath.row]
        cell.textLabel!.text = conversation.getTitle()
        cell.detailTextLabel!.text = conversation.getSubTitle()
        cell.delegate = self
        return cell
    }
    
    
    
}
