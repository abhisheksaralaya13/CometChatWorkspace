//
//  CometChatMessageOptions.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 27/01/22.
//

import UIKit
import CometChatPro

public enum OptionFor {
    
    case sent
    case received
    case both
}

protocol CometChatMessageOptionDelegate: AnyObject {
  func onItemClick(messageOption: CometChatMessageOption, forMessage: BaseMessage?, indexPath: IndexPath?)
}

public class  CometChatMessageOption {

    public enum DefaultOption {
        
        case reaction
        
        case edit
        
        case reply
        
        case start_thread
        
        case copy
        
        case translate
        
        case forward
        
        case share
        
        case messageInfo
        
        case delete

        
        /// Whether the cache type represents the image is already cached or not.
        var option: CometChatMessageOption {

            switch self {
            case .reaction:
                
                return CometChatMessageOption(id: "react-to-message", title: "ADD_REACTION".localize(), image: UIImage(named: "messages-add-reaction.png") ?? UIImage(), optionFor: .both)
                
            case .edit:
                
                return CometChatMessageOption(id: "edit-message", title: "EDIT_MESSAGE".localize(), image: UIImage(named: "messages-edit.png") ?? UIImage(), optionFor: .sent)
                
                
            case .delete:
                
                return CometChatMessageOption(id: "delete-message", title: "DELETE_MESSAGE".localize(), image: UIImage(named: "messages-delete.png") ?? UIImage(), optionFor: .sent)
                
            case .copy:
                
                return  CometChatMessageOption(id: "copy-message", title: "COPY_MESSAGE".localize(), image: UIImage(named: "copy-paste.png") ?? UIImage(), optionFor: .both)
           
            case .forward:
                
                return CometChatMessageOption(id: "forward-message", title: "FORWARD_MESSAGE".localize(), image: UIImage(named: "messages-forward-message.png") ?? UIImage(), optionFor: .both)
            
            case .share:
                
                return  CometChatMessageOption(id: "share-message", title: "SHARE_MESSAGE".localize(), image: UIImage(named: "messages-share.png") ?? UIImage(), optionFor: .both)
            case .translate:
                
                return CometChatMessageOption(id: "translate-message", title: "TRANSLATE_MESSAGE".localize(), image: UIImage(named: "message-translate.png") ?? UIImage(), optionFor: .both)
            
            case .messageInfo:
                
                return CometChatMessageOption(id: "message-info", title: "MESSAGE_INFORMATION".localize(), image: UIImage(named: "messages-info.png") ?? UIImage(), optionFor: .both)
            case .reply:
                
                return CometChatMessageOption(id: "reply-message", title: "REPLY".localize(), image: UIImage(named: "reply-message.png") ?? UIImage(), optionFor: .both)
           
            case .start_thread:
                
                return CometChatMessageOption(id: "start-thread", title: "START_THREAD".localize(), image: UIImage(named: "threaded-message.png") ?? UIImage(), optionFor: .both)
            
            }
        }
    }
    
    
    static var messageOptionDelegate: CometChatMessageOptionDelegate?
    
    let id: String
    let title: String
    let image: UIImage
    var optionFor: OptionFor = .both
    var onClick: (()->()?)? = nil
    
    
    public init(id: String, title: String, image: UIImage,  optionFor: OptionFor, onClick: (()->()?)? = nil) {
        self.id = id
        self.title = title
        self.image = image
        self.optionFor = optionFor
        self.onClick = onClick
    }
    
    public init(defaultOption: DefaultOption) {
        self.id = defaultOption.option.id
        self.title = defaultOption.option.title
        self.image = defaultOption.option.image
        self.optionFor = defaultOption.option.optionFor
        self.onClick = defaultOption.option.onClick
    }
    
}

