//
//  CometChatMessages.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 25/11/21.
//

import UIKit
import CometChatPro

class CometChatMessages: UIViewController {
    
    
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
    var messageCofiguration: CometChatMessagesConfiguration?
    
    override func viewDidLoad() {
        setupKeyboard()
        addObservers()
        if let templates = CometChatMessagesConfiguration.getMessageFilterList()  {
            set(templates: templates)
        }
        
    }
    
    
    public func set(configuration: CometChatMessagesConfiguration) {
        self.messageCofiguration = configuration
    }
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  CometChatMessages {
        let currentConfigurations = configurations.filter{ $0 is CometChatMessagesConfiguration }
        if let currentConfiguration = currentConfigurations.last as? CometChatMessagesConfiguration {
            self.messageList.set(configuration: currentConfiguration)
        }
        return self
    }
    
    public func set(templates: [CometChatMessageTemplate]) {
        self.messageTemplates = templates
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        CometChatMessageHeader.messageHeaderDelegate = self
        setupMessageHeader()
        setupMessageList()
        setupMessageComposer()
        
    }
    
    private func addObservers() {
        CometChatMessageHover.messageHoverDelegate = self
        CometChatGroups.addListener("messages-group-listner", self as CometChatGroupEvents)
    }
    
    private func removeObervers() {
        CometChatGroups.removeListner("messages-group-listner")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
    }
    
    private func setupMessageList() {
        if let user = currentUser {
            messageList.set(user: user)
        }else if let group = currentGroup {
            messageList.set(group: group)
        }
        messageList.set(controller: self)
        if let messageTemplates = messageTemplates {
            print("templates : \(messageTemplates)")
            messageList.set(templates: messageTemplates)
        }
    
    }
    
    private func setupMessageComposer(){
        if let user = currentUser {
            messageComposer.set(user: user)
        }else if let group = currentGroup {
            messageComposer.set(group: group)
        }
        messageComposer.set(controller: self)
        if let messageTemplates = messageTemplates {
        messageComposer.set(templates: messageTemplates)
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


extension CometChatMessages: CometChatMessageHoverDelegate {

    func onItemClick(messageHover: MessageHover, forMessage: BaseMessage?, indexPath: IndexPath?) {
        
        if let message = forMessage {
            switch messageHover {
            case .edit: messageComposer.edit(message: message)
            case .delete: messageList.delete(message: message)
            case .share: didMessageSharePressed(message: message)
            case .copy:  didCopyPressed(message: message)
            case .reply: messageComposer.reply(message: message)
            case .translate:
                if let indexPath = indexPath {
                    didMessageTranslatePressed(message: message, indexPath: indexPath)
                }
            case .forward: break
            case .reply_in_thread: break
            case .reaction: break
            case .messageInfo: break
            }
        }
    }
    
    private func didCopyPressed(message: BaseMessage?) {
        if let message = message as? TextMessage {
            UIPasteboard.general.string = message.text
            DispatchQueue.main.async {
                CometChatSnackBoard.display(message: "TEXT_COPIED".localize(), mode: .success, duration: .short)
            }
        }
    }
    
    private func didMessageSharePressed(message: BaseMessage?) {
        if let message = message {
            var textToShare = ""
            if message.messageType == .text {
                if message.receiverType == .user{
                    textToShare = (message as? TextMessage)?.text ?? ""
                }else{
                    if let name = (message as? TextMessage)?.sender?.name , let text = (message as? TextMessage)?.text {
                        textToShare = name + " : " + text
                    }
                }
            }else if message.messageType == .audio ||  message.messageType == .file ||  message.messageType == .image || message.messageType == .video {
                
                if message.receiverType == .user{
                    textToShare = (message as? MediaMessage)?.attachment?.fileUrl ?? ""
                }
            }

            let sendItems = [textToShare]
            let activityViewController = UIActivityViewController(activityItems: sendItems, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [.airDrop]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    private func didMessageTranslatePressed(message: BaseMessage, indexPath: IndexPath) {
        
        if let message = message as? TextMessage {
            let systemLanguage = Locale.preferredLanguages.first?.replacingOccurrences(of: "-US", with: "")
            CometChat.callExtension(slug: "message-translation", type: .post, endPoint: "v2/translate", body: ["msgId": message.id ,"languages": [systemLanguage], "text": message.text] as [String : Any], onSuccess: { (response) in
                DispatchQueue.main.async {
                    if let response = response, let originalLanguage = response["language_original"] as? String {
                        if originalLanguage == systemLanguage{
                            CometChatSnackBoard.display(message:  "NO_TRANSLATION_AVAILABLE".localize(), mode: .info, duration: .short)
                        }else{
                            if let translatedLanguages = response["translations"] as? [[String:Any]] {
                                for tranlates in translatedLanguages {
                                    if let languageTranslated = tranlates["language_translated"] as? String, let messageTranslated = tranlates["message_translated"] as? String {
                                        if languageTranslated == systemLanguage {
                                            self.messageList.tableView.beginUpdates()
                                            if let cell = self.messageList.tableView.cellForRow(at: indexPath) as? CometChatTextBubble {
                                                (cell.textMessage as? TextMessage)?.text = message.text + "\n(\(messageTranslated))"
                                            }
                                            self.messageList.tableView?.reloadRows(at: [indexPath], with: .automatic)
                                            self.messageList.tableView?.endUpdates()
                                        }else{
                                            CometChatSnackBoard.display(message:  "NO_TRANSLATION_AVAILABLE".localize(), mode: .info, duration: .short)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        CometChatSnackBoard.showErrorMessage(for: error)
                    }
                }
            }
        }
    }
}

extension CometChatMessages: CometChatMessageHeaderDelegate {
   
    func onInfoClick(user: User) {
        let userDetail = CometChatDetail()
        userDetail.set(user: user)
        let naviVC = UINavigationController(rootViewController: userDetail)
        self.present(naviVC, animated: true)
    }
    
    func onInfoClick(group: Group) {
        let groupDetail = CometChatDetail()
        groupDetail.set(group: group)
        let naviVC = UINavigationController(rootViewController: groupDetail)
        self.present(naviVC, animated: true)
    }
    
    
    func didBackButtonPressed() {
        removeObervers()
    }
    
    func didAudioCallButtonPressed() {
        
    }
    
    func didVideoCallButtonPressed() {
        
    }
}

extension CometChatMessages: CometChatGroupEvents {
    
    func onGroupMemberAdd(group: Group, members: [GroupMember]) {
        messageHeader.set(group: group)
        messageHeader.reloadInputViews()
    }

    
    func onItemClick(group: Group, index: IndexPath?) {
        
    }
    
    func onItemLongClick(group: Group, index: IndexPath?) {
        
    }
    
    func onCreateGroupClick() {
        
    }
    
    func onGroupCreate(group: Group) {
        
    }
    
    func onGroupDelete(group: Group) {
        switch self.isModal() {
        case true:
            self.dismiss(animated: true, completion: nil)
            removeObervers()
        case false:
            self.navigationController?.popViewController(animated: true)
            removeObervers()
        }
    }
    
    func onGroupMemberLeave(leftUser: User, leftGroup: Group) {
        switch self.isModal() {
        case true:
            self.dismiss(animated: true, completion: nil)
            removeObervers()
        case false:
            self.navigationController?.popViewController(animated: true)
            removeObervers()
        }
    }
    
    func onGroupMemberJoin(joinedUser: User, joinedGroup: Group) {
        
    }
    
    func onGroupMemberBan(bannedUser: User, bannedGroup: Group) {
        
    }
    
    func onGroupMemberUnban(unbannedUserUser: User, unbannedUserGroup: Group) {
        
    }
    
    func onGroupMemberKick(kickedUser: User, kickedGroup: Group) {
        
    }
    
    func onGroupMemberChangeScope(updatedBy: User, updatedUser: User, scopeChangedTo: CometChat.MemberScope, scopeChangedFrom: CometChat.MemberScope, group: Group) {
        
    }
    
    func onError(group: Group?, error: CometChatException) {
        
    }
    
    
    
    
}
