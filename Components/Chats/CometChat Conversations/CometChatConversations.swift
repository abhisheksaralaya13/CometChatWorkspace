//
//  CometChatConversations.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 22/12/21.
//  Copyright ©  2022 CometChat Inc. All rights reserved.

// MARK: - Importing Frameworks.
import UIKit
import CometChatPro


// MARK: - Declaring Protocol.
@objc public protocol CometChatConversationsDelegate {
  
    /**
     - This method will get triggered when the user clicks on the start conversation button.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onStartConversation()
    
    /**
     - This method will get triggered when the user clicks on a particular conversation.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onItemClick(conversation: Conversation)
    
    /**
     - This method will get triggered when the user long press on a particular conversation.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onItemLongClick(conversation: Conversation)
    
    /**
     - This method will get triggered when the user long press on a particular conversation.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onDeleteConversation(conversation: Conversation)
    
    
    @objc optional func onError(error: CometChatException)
}

/**
 `CometChatConversations`  is a subclass of `UIViewController` which is inherited from `CometChatListBase`.   `CometChatConversations` uses an events from `CometChatListBaseDelegate` for search and back functionality.
 - Author: CometChat Team
 - Copyright:  ©  2022 CometChat Inc.
 */
public class CometChatConversations: CometChatListBase {

    // MARK: - Declaration of Outlets
    @IBOutlet weak var conversationList: CometChatConversationList!
    
    // MARK: - Declaration of Variables
    var startConversationIcon = UIImage(named: "chats-create.png", in: CometChatUIKit.bundle, compatibleWith: nil)
    var startConversationButton: UIBarButtonItem?
    var configurations: [CometChatConfiguration]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addObervers()
        configureConversationList()

    }
    
    deinit {
       
    }
    
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  CometChatConversations {
        self.configurations = configurations
        return self
    }
    
    /**
     `CometChatConversations` is having an option to show start conversation using which user can show the option to start a conversation from a list of users or groups.
     - Parameters:
     - startConversation: This method will show the start conversation option in the CometChatConversations when the value is true.
     - Returns: This method will return `CometChatConversations`
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @discardableResult
    public func hide(startConversation: Bool) ->  CometChatConversations {
        if !startConversation {
            startConversationButton = UIBarButtonItem(image: startConversationIcon, style: .plain, target: self, action: #selector(self.didStartConversationPressed))
            self.navigationItem.rightBarButtonItem = startConversationButton
        }
        return self
    }
    
    /**
     This method will set the icon for the start conversation icon image in `CometChatConversations`
     - Parameters:
     - startConversationIcon: This method will set the icon for the start conversation icon image in CometChatConversations
     - Returns: This method will return `CometChatConversations`
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @discardableResult
    public func set(startConversationIcon: UIImage) ->  CometChatConversations {
        self.startConversationIcon = startConversationIcon.withRenderingMode(.alwaysTemplate)
        return self
    }
    
    /**
     This method will set the icon for the start conversation icon tint color  in `CometChatConversations`
     - Parameters:
     - startConversationIcon: This method will set the icon tint color for the start conversation  in CometChatConversations
     - Returns: This method will return `CometChatConversations`
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @discardableResult
    public func set(startConversationIconTint: UIColor) ->  CometChatConversations {
        startConversationButton?.tintColor = startConversationIconTint
        return self
    }

    
    private func setupAppearance() {
        if #available(iOS 13.0, *) {
            self.set(background: [CometChatTheme.palatte?.background?.cgColor ?? UIColor.systemBackground.cgColor])
            self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
                .set(searchPlaceholder: "SEARCH".localize())
                .set(searchTextColor: .label)
                .set(title: "CHATS".localize(), mode: .automatic)
                .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.clear)
                .hide(search: false)
        } else {
            // Fallback on earlier versions
        }
        
            self.hide(startConversation: true)
            .set(startConversationIcon: startConversationIcon ?? UIImage())
            .set(startConversationIconTint: CometChatTheme.palatte?.primary ?? UIColor.clear)
        Bundle.module.loadNibNamed("CometChatConversations", owner: self, options: nil)
        conversationList.set(controller: self)
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
    }
    
    private func removeObervers() {
       
    }
    
    private func configureConversationList() {
        conversationList.set(conversationType: CometChatStore.conversations.conversationType)
            .set(configurations: configurations)
            .show(deleteConversation: true)
            .set(controller: self)
    }
    
    @objc func didStartConversationPressed(){
        CometChatConversations.comethatConversationsDelegate?.onStartConversation?()
    }
    
}


extension CometChatConversations: CometChatListBaseDelegate {
 
    public func onSearch(state: SearchState, text: String) {
        switch state {
        case .clear:
            conversationList.isSearching = false
            conversationList.filterConversations(forText: "")
        case .filter:
            conversationList.isSearching = true
            conversationList.filterConversations(forText: text)
        }
    }
    
    public func onBack() {
        switch self.isModal() {
        case true:
            self.dismiss(animated: true, completion: nil)
            removeObervers()
        case false:
            self.navigationController?.popViewController(animated: true)
            removeObervers()
        }
    }
}

extension CometChatConversations {
    static var comethatConversationsDelegate: CometChatConversationsDelegate?
}







