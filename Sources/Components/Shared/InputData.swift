//
//  InputData.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 22/03/22.
//

import Foundation
import CometChatPro


public class InputData : NSObject {
    
    var id: Bool?
    var title: Bool?
    var subtitle: Bool?
    var thumbnail: Bool?
    var status: Bool?
    
    var subtitleText: ((_ object: AnyObject) -> String)?
    
    override init() { }
    
    init(title: Bool?, subtitle: Bool, thumbnail: Bool?, status: Bool?, subtitleText: ((_ object: AnyObject) -> String)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.thumbnail = thumbnail
        self.status = status
        self.subtitleText = subtitleText
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

public class SentMessageInputData : InputData {
    
    var timestamp: Bool?
    var readReceipt: Bool?
    
    init(title: Bool?, thumbnail: Bool?, readReceipt: Bool?,  timestamp: Bool?) {
        super.init()
        self.title = title
        self.thumbnail = thumbnail
        self.readReceipt = readReceipt
        self.timestamp = timestamp
    }
}


public class ReceivedMessageInputData : InputData {
    
    var timestamp: Bool?
    var readReceipt: Bool?
    
    init(title: Bool?, thumbnail: Bool?, readReceipt: Bool?,  timestamp: Bool?) {
        super.init()
        self.title = title
        self.thumbnail = thumbnail
        self.readReceipt = readReceipt
        self.timestamp = timestamp
    }
}

