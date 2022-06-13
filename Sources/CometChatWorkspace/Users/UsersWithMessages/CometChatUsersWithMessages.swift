//
//  CometChatUsersWithMessages.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 23/05/22.
//

import UIKit
import CometChatPro

class CometChatUsersWithMessages: CometChatUsers {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func onItemClick(user: User, index: IndexPath?) {
        
        let cometChatMessages: CometChatMessages = CometChatMessages()
        cometChatMessages.set(user: user)
        cometChatMessages.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cometChatMessages, animated: true)
    
    }


}
