//
//  File.swift
//  
//
//  Created by Pushpsen Airekar on 17/07/22.
//

import Foundation
import CometChatPro

extension CometChatConversationList : CometChatMessageDelegate {
    
    public func onTextMessageReceived(textMessage: TextMessage) {
        if let conversation = CometChat.getConversationFromMessage(textMessage) {
            self.update(conversation: conversation)
        }
    }
    
    public func onMediaMessageReceived(mediaMessage: MediaMessage) {
        if let conversation = CometChat.getConversationFromMessage(mediaMessage) {
            self.update(conversation: conversation)
        }
        
    }
    
    public func onCustomMessageReceived(customMessage: CustomMessage) {
        if let conversation = CometChat.getConversationFromMessage(customMessage) {
            self.update(conversation: conversation)
        }
    }
    
    public func onTypingStarted(_ typingDetails: TypingIndicator) {
        if let row = self.conversations.firstIndex(where: {($0.conversationWith as? User)?.uid == typingDetails.sender?.uid && $0.conversationType.rawValue == typingDetails.receiverType.rawValue }), let indexPath = IndexPath(row: row, section: 0) as? IndexPath , let conversationListItem = self.tableView.cellForRow(at: indexPath) as? CometChatConversationListItem  {
            
            if  (conversationListItem.conversation?.conversationWith as? User)?.uid == typingDetails.sender?.uid {
                DispatchQueue.main.async {
                    
                    conversationListItem.show(typingIndicator: true)
                        .set(typingIndicatorColor: CometChatTheme.palatte?.success)
                        .set(typingIndicatorText: "IS_TYPING".localize())
                       
                    conversationListItem.reloadInputViews()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    
                    conversationListItem.show(typingIndicator: false)
                    
                                        .set(typingIndicatorText: "")
                                        
                    conversationListItem.reloadInputViews()
                }
            }else if (conversationListItem.conversation?.conversationWith as? Group)?.guid == typingDetails.receiverID {
                
                let user = typingDetails.sender?.name ?? ""
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    conversationListItem.show(typingIndicator: true)
                        .set(typingIndicatorColor: CometChatTheme.palatte?.success)
                        .set(typingIndicatorText: user + " " + "IS_TYPING".localize())
                    tableView.endUpdates()()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    tableView.beginUpdates()
                    conversationListItem.show(typingIndicator: false)
                    .set(typingIndicatorText: "")
                    tableView.endUpdates()()
                }
            }
        }
    }
    
    /**
     This method triggers when real time event for  stop typing received from  CometChat Pro SDK
     - Parameter typingDetails: This specifies TypingIndicator Object.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     - See Also:
     [CometChatConversationList Documentation](https://prodocs.cometchat.com/docs/ios-ui-screens#section-3-comet-chat-conversation-list)
     */
    public func onTypingEnded(_ typingDetails: TypingIndicator) {
        if let row = self.conversations.firstIndex(where: {($0.conversationWith as? User)?.uid == typingDetails.sender?.uid && $0.conversationType.rawValue == typingDetails.receiverType.rawValue }), let indexPath = IndexPath(row: row, section: 0) as? IndexPath , let conversationListItem = self.tableView.cellForRow(at: indexPath) as? CometChatConversationListItem  {
            
            if  (conversationListItem.conversation?.conversationWith as? User)?.uid == typingDetails.sender?.uid {
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    conversationListItem.show(typingIndicator: false)
                        .set(typingIndicatorText: "")
                       
                    tableView.endUpdates()()
                }
            }else if (conversationListItem.conversation?.conversationWith as? Group)?.guid == typingDetails.receiverID {
                
                let user = typingDetails.sender?.name ?? ""
                DispatchQueue.main.async {
                    tableView.beginUpdates()
                    conversationListItem.show(typingIndicator: false)
                                        .set(typingIndicatorText: "")
                                        
                    tableView.endUpdates()()
                }
            }
        }
    }
}




