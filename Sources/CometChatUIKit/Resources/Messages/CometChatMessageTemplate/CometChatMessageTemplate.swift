//
//  CometChatMessageTemplate.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 19/01/22.
//

import Foundation
import CometChatPro



public class CometChatMessageTemplate: NSObject {
    
    public enum DefaultTemplate {
      
       case text
     
       case imageFromCamera
    
       case imageFromGallery
        
        case audio
        
        case video
        
        case file

        case location
        
        case poll
        
        case collaborativeWhiteboard
        
        case collaborativeDocument
        
        case sticker
        
        case meet
        
        case groupActions
        
        case call
       
       /// Whether the cache type represents the image is already cached or not.
    var template: CometChatMessageTemplate {
        
            switch self {
           
            case .text: return CometChatMessageTemplate(id: "text", name: "", icon: nil, title: nil, description: nil, customView: nil, options: [])
              
            case .imageFromCamera: return CometChatMessageTemplate(id: "image", name: "TAKE_A_PHOTO".localize(), icon: UIImage(named: "messages-camera.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .imageFromGallery: return CometChatMessageTemplate(id: "image", name: "PHOTO_VIDEO_LIBRARY".localize(), icon: UIImage(named: "photo-library.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .audio:
                
                return CometChatMessageTemplate(id: "audio", name: "", icon: nil, title: nil, description: nil, customView: nil, options: [])
                
            case .video:
                
                return CometChatMessageTemplate(id: "video", name: "", icon: nil, title: nil, description: nil, customView: nil, options: [])
                
            case .file:
                
                return CometChatMessageTemplate(id: "file", name: "DOCUMENT".localize(), icon:  UIImage(named: "messages-file-upload.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .location:
                
                return CometChatMessageTemplate(id: "location", name: "SHARE_LOCATION".localize(), icon:  UIImage(named: "messages-location.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: "", description: nil, customView: nil, options: [])
                
            case .poll:
                return CometChatMessageTemplate(id: "extension_poll", name: "CREATE_A_POLL".localize(), icon:  UIImage(named: "messages-polls.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
            case .collaborativeWhiteboard:
                
                return CometChatMessageTemplate(id: "extension_whiteboard", name: "COLLABORATIVE_WHITEBOARD".localize(), icon:  UIImage(named: "messages-collaborative-whiteboard.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .collaborativeDocument:
                
                return CometChatMessageTemplate(id: "extension_document", name: "COLLABORATIVE_DOCUMENT".localize(), icon:  UIImage(named: "messages-collaborative-document.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .sticker:
                
                return CometChatMessageTemplate(id: "extension_sticker", name: "SEND_STICKER".localize(), icon:  UIImage(named: "messages-stickers.png", in: CometChatUIKit.bundle, compatibleWith: nil) ?? UIImage(), title: nil, description: nil, customView: nil, options: [])
                
            case .meet:
                
                return CometChatMessageTemplate(id: "meeting", name: "", icon:  nil, title: nil, description: nil, customView: nil, options: [])
                
            case .groupActions:
                
                return CometChatMessageTemplate(id: "groupActions", name: "", icon:  nil, title: nil, description: nil, customView: nil, options: [])
                
            case .call:
                
                return CometChatMessageTemplate(id: "call", name: "", icon:  nil, title: nil, description: nil, customView: nil, options: [])
            }
        }
    }
    
    var id: String
    var name: String?
    var icon: UIImage?
    var title: String?
    var localDescription: String?
    var customView: UIView?
    var options: [MessageOption]?
    
    
    public init(id: String, name: String, icon: UIImage? = UIImage(), title: String? = "", description: String? = "",  customView: UIView?, options: [MessageOption]?) {
        self.id = id
        self.name = name
        self.icon = icon
        self.title = title
        self.localDescription = description
        self.customView = customView
        self.options = options
        self.options = options
    }
    
    public init(type: DefaultTemplate) {
        self.id =  type.template.id
        self.name =  type.template.name
        self.icon =  type.template.icon
        self.title =  type.template.title
        self.localDescription =  type.template.description
        self.customView =  type.template.customView
        self.options =  type.template.options
    }
}

