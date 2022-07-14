//
//  CometChatHelper.swift
//  CometChatUIKit
//
//  Created by Abdullah Ansari on 27/06/22.
//

import Foundation
import CometChatPro

final public class CometChatUIHelper {
    
    static func onMessageSend(message: BaseMessage, status: MessageStatus) {
        CometChatMessageEvents.emitOnMessageSent(message: message, status: status)
    }
    
    static func onMessageError(message: BaseMessage, error: CometChatException) {
        CometChatMessageEvents.emitOnError(message: message, error: error)
    }

    static func onMessageEdit(message: BaseMessage, status: MessageStatus) {
        CometChatMessageEvents.emitOnMessageEdit(message: message, status: status)
    }

    static func onMessageDelete(message: BaseMessage, status: MessageStatus) {
        CometChatMessageEvents.emitOnMessageDelete(message: message, status: status)
    }

    static func onMessageReply(message: BaseMessage, status: MessageStatus) {
        CometChatMessageEvents.emitOnMessageReply(message: message, status: status)
    }

    static func onMessageReact(message: BaseMessage, reaction: CometChatMessageReaction) {
        CometChatMessageEvents.emitOnMessageReact(message: message, reaction: reaction)
    }
}
