//
//  File.swift
//  
//
//  Created by Pushpsen Airekar on 17/07/22.
//

import Foundation
import CometChatPro


extension CometChatConversationList : CometChatUserDelegate {

    /**
     This method triggers users comes online from user list.
     - Parameter user: This specifies `User` Object
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [CometChatConversationList Documentation](https://prodocs.cometchat.com/docs/ios-ui-screens#section-3-comet-chat-conversation-list)
     */
    public func onUserOnline(user: User) {
        if conversationType == .user || conversationType == .none {
            if let row = self.conversations.firstIndex(where: {($0.conversationWith as? User)?.uid == user.uid}) {
                let indexPath = IndexPath(row: row, section: 0)
                DispatchQueue.main.async {
                    if let conversationListItem = self.tableView.cellForRow(at: indexPath) as? CometChatConversationListItem {
                        conversationListItem.set(statusIndicator: .online)
                        conversationListItem.reloadInputViews()
                    }
                }
            }
        }
    }

    /**
     This method triggers users goes offline from user list.
     - Parameter user: This specifies `User` Object
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [CometChatConversationList Documentation](https://prodocs.cometchat.com/docs/ios-ui-screens#section-3-comet-chat-conversation-list)
     */
    public func onUserOffline(user: User) {
        if conversationType == .user || conversationType == .none {
            if let row = self.conversations.firstIndex(where: {($0.conversationWith as? User)?.uid == user.uid}) {
                let indexPath = IndexPath(row: row, section: 0)
                DispatchQueue.main.async {
                    if let conversationListItem = self.tableView.cellForRow(at: indexPath) as? CometChatConversationListItem {
                        conversationListItem.set(statusIndicator: .offline)
                        conversationListItem.reloadInputViews()
                    }
                }
            }
        }
    }

}
