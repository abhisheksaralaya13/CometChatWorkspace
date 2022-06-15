//
//  CometChatSettings.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 28/12/21.
//

import Foundation
import UIKit

public class  MessageHeaderConfiguration: CometChatConfiguration {
  
    lazy var hideBackButton: Bool = false
    lazy var hideVideoCallButton: Bool = true
    lazy var hideVoiceCallButton: Bool = true
    lazy var hideInfoButton: Bool = false
    lazy var hideTitle: Bool = false
    lazy var hideSubtitle:  Bool = false
    lazy var hideAvatar: Bool = false
    lazy var hideStatusIndicator: Bool = false
    var avatarConfiguration: AvatarConfiguration?
    var statusIndicatorConfiguration: StatusIndicatorConfiguration?
    
    public func hide(backButton: Bool) -> Self {
        self.hideBackButton = backButton
        return self
    }
    
    public func hide(videoCall: Bool) -> Self {
        self.hideVideoCallButton = videoCall
        return self
    }
    
    public func hide(audioCall: Bool) -> Self {
        self.hideVoiceCallButton = audioCall
        return self
    }
    
    public func hide(info: Bool) -> Self {
        self.hideInfoButton = info
        return self
    }
    
    public func hide(title: Bool) -> Self {
        self.hideTitle = title
        return self
    }
    
    public func hide(subtitle: Bool) -> Self {
        self.hideSubtitle = subtitle
        return self
    }
    
    public func hide(avatar: Bool) -> Self {
        self.hideAvatar = avatar
        self.hideStatusIndicator = avatar
        return self
    }
    
    public func hide(statusIndicator: Bool) -> Self {
        self.hideStatusIndicator = statusIndicator
        return self
    }
    
    public func set(avatarConfiguration: AvatarConfiguration) -> Self {
        self.avatarConfiguration = avatarConfiguration
        return self
    }
    
    public func set(statusIndicatorConfiguration: StatusIndicatorConfiguration) -> Self {
        self.statusIndicatorConfiguration = statusIndicatorConfiguration
        return self
    }
    
}

