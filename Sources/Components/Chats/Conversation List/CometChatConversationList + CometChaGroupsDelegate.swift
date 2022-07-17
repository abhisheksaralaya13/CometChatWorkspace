//
//  File.swift
//  
//
//  Created by Pushpsen Airekar on 17/07/22.
//

import Foundation
import CometChatPro

extension CometChatConversationList : CometChatGroupDelegate {
    
    public func onGroupMemberJoined(action: ActionMessage, joinedUser: User, joinedGroup: Group) {
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
    }
    
    public func onGroupMemberLeft(action: ActionMessage, leftUser: User, leftGroup: Group) {
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
    }
    
    public func onGroupMemberKicked(action: ActionMessage, kickedUser: User, kickedBy: User, kickedFrom: Group) {
        
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
        
    }
    
    public func onGroupMemberBanned(action: ActionMessage, bannedUser: User, bannedBy: User, bannedFrom: Group) {
        
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
        
    }
    
    public func onGroupMemberUnbanned(action: ActionMessage, unbannedUser: User, unbannedBy: User, unbannedFrom: Group) {
        
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
        
    }
    
    public func onGroupMemberScopeChanged(action: ActionMessage, scopeChangeduser: User, scopeChangedBy: User, scopeChangedTo: String, scopeChangedFrom: String, group: Group) {
        
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
        
    }
    
    public func onMemberAddedToGroup(action: ActionMessage, addedBy: User, addedUser: User, addedTo: Group) {
        
        if let conversation = CometChat.getConversationFromMessage(action) {
            self.insert(conversation: conversation, at: 0)
        }
        
    }
    


}
