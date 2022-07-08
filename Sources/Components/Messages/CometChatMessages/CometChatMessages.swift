//
//  CometChatMessages.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 25/11/21.
//

import UIKit
import CometChatPro

open class CometChatMessages: UIViewController {
    
    
    // MARK ->  Message Header Declarations
    @IBOutlet weak var messageHeader: CometChatMessageHeader!
    
    // MARK ->  Message List Declarations
    @IBOutlet weak var messageList: CometChatMessageList!
    
    
    // MARK ->  Message Composer Declarations
    @IBOutlet weak var messageComposer: CometChatMessageComposer!
    @IBOutlet weak var messageComposerBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var messageComposerHeight: NSLayoutConstraint!
    
    static var loggedInUser = CometChat.getLoggedInUser()
    var currentUser: User?
    var currentGroup: Group?
    var messageTemplates: [CometChatMessageTemplate]?
    var configuration: CometChatConfiguration?
    var configurations: [CometChatConfiguration]?
    var liveReactionImage: UIImage = UIImage(named: "message-composer-heart.png", in: CometChatUIKit.bundle, with: nil) ?? UIImage()
    
    open override func loadView() {
        let loadedNib = Bundle.module.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        if let contentView = loadedNib?.first as? UIView  {
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view  = contentView
        }
    }
    
    open override func viewDidLoad() {
        setupKeyboard()
        addObservers()
    }
      
    
    @discardableResult
    @objc public func set(configuration: CometChatConfiguration) -> Self {
        if let configuration = configuration as? MessagesConfiguration {
            self.configuration = configuration
        }
        return self
    }
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  Self {
        self.configurations = configurations
        return self
    }
    
    @discardableResult
    public func set(mesageTypes: [CometChatMessageTemplate])  ->  Self {
        self.messageTemplates = mesageTypes
        return self
    }
    
    
    open override func viewWillAppear(_ animated: Bool) {
        setupMessageHeader()
        setupMessageList()
        setupMessageComposer()
        
    }
    
    private func addObservers() {
        CometChatMessageOption.messageOptionDelegate = self
        CometChatMessageEvents.addListener("messages-message-listner", self as CometChatMessageEventListner)
        CometChatGroupEvents.addListener("messages-group-listner", self as CometChatGroupEventListner)
    }
    
    private func removeObervers() {
        CometChatGroupEvents.removeListner("messages-group-listner")
        CometChatMessageEvents.removeListner("messages-message-listner")
    }
    
    
    @discardableResult
    @objc public func set(user: User) -> CometChatMessages {
        self.currentUser = user
        return self
    }
    
    @discardableResult
    @objc public func set(group: Group) -> CometChatMessages {
        self.currentGroup = group
        return self
    }
    
    private func setupMessageHeader() {
        self.navigationController?.navigationBar.isHidden = true
        if let user = currentUser {
            messageHeader.set(user: user)
        }else if let group = currentGroup {
            messageHeader.set(group: group)
        }
        messageHeader.set(controller: self)
        if let configuration = configuration {
            messageHeader.set(configurations: [configuration])
        }
        if let configurations = configurations {
            messageHeader.set(configurations: configurations)
        }
       
    }
    
    private func setupMessageList() {
        if let messageTemplates = messageTemplates {
            messageList.set(templates: messageTemplates)
        }
        if let configuration = configuration {
            messageList.set(configurations: [configuration])
        }
        if let configurations = configurations {
            messageList.set(configurations: configurations)
        }
        if let user = currentUser {
            messageList.set(user: user)
        }else if let group = currentGroup {
            messageList.set(group: group)
        }
        messageList.set(controller: self)
       
    }
    
    private func setupMessageComposer(){
        if let messageTemplates = messageTemplates {
            messageComposer.set(templates: messageTemplates)
        }
        if let user = currentUser {
            messageComposer.set(user: user)
        }else if let group = currentGroup {
            messageComposer.set(group: group)
        }
        messageComposer.set(controller: self)
        if let configuration = configuration {
            messageList.set(configurations: [configuration])
        }
        if let configurations = configurations {
            messageComposer.set(configurations: configurations)
            
        }
    }
    
    private func setupKeyboard(){
        messageComposer.textView.layer.cornerRadius = 4.0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        messageList.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            if #available(iOS 11, *) {
                if keyboardHeight > 0 {
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                }
            }
            self.messageComposerBottomSpace.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.superview?.layoutIfNeeded()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension CometChatMessages: CometChatMessageOptionDelegate {
    
    func onItemClick(messageOption: CometChatMessageOption, forMessage: BaseMessage?, indexPath: IndexPath?) {
        if let message = forMessage {
            switch messageOption.id {
            case "edit-message" :
                messageComposer.preview(message: message, mode: .edit)
            case "delete-message" :
                messageList.delete(message: message)
            case "share-message" :
                didMessageSharePressed(message: message)
            case "copy-message" :
                didCopyPressed(message: message)
            case "reply-message" :
                messageComposer.preview(message: message, mode: .reply)
            case "translate-message" :
                if let indexPath = indexPath {
                   didMessageTranslatePressed(message: message, indexPath: indexPath)
                }
            case "forward-message" : break
            case "reply-in-thread-message" : break
            case "react-to-message" :
                didReactionPressed(message: message)
                break
            case "message-information" : break
            default: break
            }
        }
        updateViewConstraints()
    }
    
    
    private func didReactionPressed(message: BaseMessage?) {
        let emojiKeyboard = CometChatEmojiKeyboard()
        if let message = message {
            emojiKeyboard.set(message: message)
        }
        self.presentPanModal(emojiKeyboard)
    }
    
    private func didCopyPressed(message: BaseMessage?) {
        if let message = message as? TextMessage {
            UIPasteboard.general.string = message.text
        }
    }
    
    private func didMessageSharePressed(message: BaseMessage?) {
        if let message = message {
            var textToShare = ""
            if message.messageType == .text {
                
                textToShare = (message as? TextMessage)?.text ?? ""
                
            }else if message.messageType == .audio ||  message.messageType == .file ||  message.messageType == .image || message.messageType == .video {
                
                    textToShare = (message as? MediaMessage)?.attachment?.fileUrl ?? ""
            }
            let sendItems = [textToShare]
            
            if !sendItems.isEmpty {
                let activityViewController = UIActivityViewController(activityItems: sendItems, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [.airDrop]
                self.present(activityViewController, animated: true, completion: nil)
            }
           
        }
    }
    
    private func didMessageTranslatePressed(message: BaseMessage, indexPath: IndexPath) {
        messageList.translate(message: message)
    }
}

extension CometChatMessages: CometChatGroupEventListner {
    
    public func onOwnershipChange(group: Group?, member: GroupMember?) {
        
    }
    
    
    public func onGroupMemberAdd(group: Group, members: [GroupMember]) {
        messageHeader.set(group: group)
        messageHeader.reloadInputViews()
    }
    
    
    public func onItemClick(group: Group, index: IndexPath?) {
        
    }
    
    public func onItemLongClick(group: Group, index: IndexPath?) {
        
    }
    
    public func onCreateGroupClick() {
        
    }
    
    public func onGroupCreate(group: Group) {
        
    }
    
    public func onGroupDelete(group: Group) {
        switch self.isModal() {
        case true:
            self.navigationController?.navigationBar.isHidden = false
            self.dismiss(animated: true, completion: nil)
        
            removeObervers()
        case false:
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
            removeObervers()
        }
    }
    
    public func onGroupMemberLeave(leftUser: User, leftGroup: Group) {
        switch self.isModal() {
        case true:
            self.navigationController?.navigationBar.isHidden = false
            self.dismiss(animated: true, completion: nil)
          
            removeObervers()
        case false:
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
            removeObervers()
        }
    }
    
    public func onGroupMemberJoin(joinedUser: User, joinedGroup: Group) {
        
    }
    
    public func onGroupMemberBan(bannedUser: User, bannedGroup: Group) {
        
    }
    
    public func onGroupMemberUnban(unbannedUserUser: User, unbannedUserGroup: Group) {
        
    }
    
    public func onGroupMemberKick(kickedUser: User, kickedGroup: Group) {
        
    }
    
    public func onGroupMemberChangeScope(updatedBy: User, updatedUser: User, scopeChangedTo: CometChat.MemberScope, scopeChangedFrom: CometChat.MemberScope, group: Group) {
        
    }
    
    public func onError(group: Group?, error: CometChatException) {
        
    }
    
}


extension CometChatMessages: CometChatMessageEventListner {
    
    
    public func onMessageSent(message: BaseMessage, status: MessageStatus) {
        switch status {
        case .inProgress:
            self.messageList.add(message: message)
        case .success:
            self.messageList.update(message: message)
        }
    }
    
    public func onMessageEdit(message: BaseMessage, status: MessageStatus) {
        self.messageList.update(message: message)
    }
    
    public func onMessageDelete(message: BaseMessage, status: MessageStatus) {
        if messageList.hideDeletedMessages {
            self.messageList.remove(message: message)
        }else{
            self.messageList.update(message: message)
        }
    }
    
    public func onMessageReply(message: BaseMessage, status: MessageStatus) {
        
    }
    
    public func onMessageRead(message: BaseMessage) {
        
    }
    
    public func onLiveReaction(reaction message: TransientMessage) {
        messageList.startLiveReaction(image: liveReactionImage)
    }
    
    public func onMessageError(error: CometChatException) {
        
    }
    
    public func onVoiceCall(user: User) {
        
    }
    
    public func onVoiceCall(group: Group) {
        
    }
    
    public func onVideoCall(user: User) {
        
    }
    
    public func onVideoCall(group: Group) {
        
    }
    
    public func onViewInformation(user: User) {
        let userDetail = CometChatDetail()
        userDetail.set(user: user)
        let naviVC = UINavigationController(rootViewController: userDetail)
        self.present(naviVC, animated: true)
    }
    
    public func onViewInformation(group: Group) {
        let groupDetail = CometChatDetail()
        groupDetail.set(group: group)
        let naviVC = UINavigationController(rootViewController: groupDetail)
        self.present(naviVC, animated: true)
    }
    
    public func onError(message: BaseMessage?, error: CometChatException) {
        if let message = message {
            self.messageList.update(message: message)
        }
    }
    
    public func onMessageReact(message: BaseMessage, reaction: CometChatMessageReaction) {
        
    }
}
