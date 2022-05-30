//
//  InputData.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 22/03/22.
//

import Foundation
import CometChatPro


public class InputData {
    
    var id: Bool?
    var title: Bool?
    var subtitle: Bool?
    var thumbnail: Bool?
    var status: Bool?
    
    
    
    init() { }
    
    init(title: Bool?, subtitle: Bool, thumbnail: Bool?, status: Bool?) {
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
        self.status = status
    }
}


public class ConversationInputData : InputData {
    
    var unreadCount: Bool?
    var readReceipt: Bool?
    var timestamp: Bool?
    
    init(title: Bool?, subtitle: Bool, thumbnail: Bool?, status: Bool?, unreadCount: Bool?, readReceipt: Bool?, timestamp: Bool?) {
        super.init()
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
        self.status = status
        self.unreadCount = unreadCount
        self.readReceipt = readReceipt
        self.timestamp = timestamp
    }
    
}

public class MessageInputData : InputData {
    
    var timestamp: Bool?
    var readReceipt: Bool?
    
    init(title: Bool?, subtitle: Bool, thumbnail: Bool?, status: Bool?, readReceipt: Bool?,  timestamp: Bool?) {
        super.init()
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
        self.status = status
        self.readReceipt = readReceipt
        self.timestamp = timestamp
    }
}

