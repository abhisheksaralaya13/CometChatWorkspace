//
//  CometChatSettings.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 28/12/21.
//

import Foundation
import UIKit

public class  MessageListConfiguration: CometChatConfiguration {
  
    lazy var limit: Int = 30
    lazy var onlyUnreadMessages: Bool = false
    lazy var hideMessagesFromBlockedUsers: Bool = true
    lazy var hideDeletedMessages: Bool = false
    lazy var hideThreadReplies: Bool = true
    lazy var hideError: Bool = false
    var tags: [String]?
    var messageTypes: [CometChatMessageTemplate]?
    var excludeMessageTypes: [String]?
    var emptyText: String?
    var errorText: String?
    var scrollToBottomOnNewMessage: Bool = true
    var showEmojiInLargerSize: Bool = true
    var messageBubbleConfiguration: MessageBubbleConfiguration?
    var excludedMessageOptions: [CometChatMessageOption]?
    var messageAlignment: MessageAlignment = .standard
    var enableSoundForMessages: Bool = true
    
    public func set(limit: Int) -> Self {
        self.limit = limit
        return self
    }
    
    public func show(onlyUnreadMessages: Bool) -> Self {
        self.onlyUnreadMessages = onlyUnreadMessages
        return self
    }
    
    public func hide(messagesFromBlockedUsers: Bool) -> Self {
        self.hideMessagesFromBlockedUsers = messagesFromBlockedUsers
        return self
    }
    
    public func hide(deletedMessages: Bool) -> Self {
        self.hideDeletedMessages = deletedMessages
        return self
    }
    
    public func hide(threadedReplies: Bool) -> Self {
        self.hideThreadReplies = threadedReplies
        return self
    }
    
    public func hide(error: Bool) -> Self {
        self.hideError = error
        return self
    }
    
    public func set(tags: [String]) -> Self {
        self.tags = tags
        return self
    }
    
    public func set(messageTypes: [CometChatMessageTemplate]) -> Self {
        self.messageTypes = messageTypes
        return self
    }
    
    public func set(excludeMessageTypes: [String]) -> Self {
        self.excludeMessageTypes = excludeMessageTypes
        return self
    }
    
    public func set(emptyText: String) -> Self {
        self.emptyText = emptyText
        return self
    }
    
    public func set(errorText: String) -> Self {
        self.errorText = errorText
        return self
    }
    
    
    public func scrollToBottomOnNewMessage(bool: Bool) -> Self {
        self.scrollToBottomOnNewMessage = bool
        return self
    }
    
    public func showEmojiInLargerSize(bool: Bool) -> Self {
        self.showEmojiInLargerSize = bool
        return self
    }
    
    
    public func set(messageBubbleConfiguration: MessageBubbleConfiguration) -> Self {
        self.messageBubbleConfiguration = messageBubbleConfiguration
        return self
    }
    
    public func set(excludedMessageOptions: [CometChatMessageOption]) -> Self {
        self.excludedMessageOptions = excludedMessageOptions
        return self
    }
    
    public func set(messageAlignment: MessageAlignment) -> Self {
        self.messageAlignment = messageAlignment
        return self
    }
    
    @discardableResult
    @objc func enableSoundForMessages(bool: Bool) -> Self {
        self.enableSoundForMessages = bool
        return self
    }
    
}
