//
//  MessageComposerConfiguration.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 07/02/22.
//

import Foundation
import UIKit


public class MessageComposerConfiguration: CometChatConfiguration {

    private var maxLines: Int = 5
    private var placeholderText: String = "TYPE_A_MESSAGE".localize()
    private var hideAttachment = false
    private var hideMicrophone = true
    private var hideLiveReaction = false
    private var hideSticker = false
    private var hideEmoji = false
    private var hideSendButton = false
    private var enableTypingIndicator = true
    var hideMessageComposer: Bool = false
    var messageTypes: [CometChatMessageTemplate]?
    var excludeMessageTypes: [CometChatMessageTemplate]?
    
    
    
    public func set(messageTypes: [CometChatMessageTemplate]) -> Self {
        self.messageTypes = messageTypes
        return self
    }
    
    public func set(excludeMessageTypes: [CometChatMessageTemplate]) -> Self {
        self.excludeMessageTypes = excludeMessageTypes
        return self
    }
    
    
    public func set(maxLines: Int) -> Self {
        self.maxLines = maxLines
        return self
    }
    
    public func getMaxLines() -> Int {
        return maxLines
    }
    
    public func set(placeholderText: String) -> Self {
        self.placeholderText = placeholderText
        return self
    }
    
    public func getPlaceholderText() -> String {
        return placeholderText
    }
    
    
    public func hide(attachment: Bool) -> Self {
        self.hideAttachment = attachment
        return self
    }
    
    public func isAttachmentHidden() -> Bool {
        return hideAttachment
    }
    
    
    public func hide(sticker: Bool) -> Self {
        self.hideSticker = sticker
        return self
    }
    
    public func isStickerHidden() -> Bool {
        return hideSticker
    }
    
    public func isTypingIndicatorEnabled() -> Bool {
        return enableTypingIndicator
    }
    
    
    public func isEmojiHidden() -> Bool {
        return hideEmoji
    }
    
    
    public func hide(microphone: Bool) -> Self {
        self.hideMicrophone = microphone
        return self
    }

    
    public func hide(liveReaction: Bool) -> Self {
        self.hideLiveReaction = liveReaction
        return self
    }
    
    public func isLiveReactionHidden() -> Bool {
        return hideLiveReaction
    }

    public func hide(sendButton: Bool) -> Self {
        self.hideSendButton = sendButton
        return self
    }
    
    public func isSendButtonHidden() -> Bool {
        return hideSendButton
    }
    
    public func hide(emoji: Bool) -> Self {
        self.hideEmoji = hideEmoji
        return self
    }
    
    public func enable(typingIndicator: Bool) -> Self {
        self.enableTypingIndicator = typingIndicator
        return self
    }
    
    @discardableResult
    @objc func hide(messageComposer: Bool) -> Self {
        self.hideMessageComposer = messageComposer
        return self
    }

}
