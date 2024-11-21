//
//  ViewController.swift
//  ZenThea
//
//  Created by Felix Ton that-Lavarini on 21/11/2024.
//

import UIKit

/// chargement de la discussion dans la View
class ConversationVC: UIViewController {
    
    // MARK: prises
    
    @IBOutlet weak var title_: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

