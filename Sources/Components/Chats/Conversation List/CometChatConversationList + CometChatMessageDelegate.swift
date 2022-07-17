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
    
    public func onTypingEnded(_ typingDetails: TypingIndicator) {
        
    }
    
    public func onTypingStarted(_ typingDetails: TypingIndicator) {
        
    }
}




