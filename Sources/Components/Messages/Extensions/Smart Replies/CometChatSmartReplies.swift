
//  CometChatSmartReplies.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2020 CometChat Inc. All rights reserved.

// MARK: - Importing Frameworks.

import UIKit
import Foundation
import CometChatPro

// MARK: - Importing Protocols.

protocol CometChatSmartRepliesDelegate: class {
    func didSendButtonPressed(title: String)
}

/*  ----------------------------------------------------------------------------------------- */

@IBDesignable class CometChatSmartReplies: UIView {
    
    // MARK: - Declaration of Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet{
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    // MARK: - Declaration of Variables
    var user: User?
    var group: Group?
    
    var view:UIView!
    var buttontitles: [String] = [String]()
    weak var smartRepliesDelegate: CometChatSmartRepliesDelegate?
    
    
    
    // MARK: - Public instance Methods
    
    /**
    This method set the array of titles for smart replies view.
     - Parameter sender: This specifies an user who is pressing this button
    - Author: CometChat Team
    - Copyright:  ©  2020 CometChat Inc.
    */
    @discardableResult
    @objc public func set(titles: [String]) -> CometChatSmartReplies {
        buttontitles = titles
        collectionView.reloadData()
        return self
    }
    
    @discardableResult
    @objc  public func set(user : User) -> CometChatSmartReplies {
        self.user = user
        return self
    }
    
    @discardableResult
    @objc  public func set(group: Group) -> CometChatSmartReplies {
        self.group = group
        return self
    }
    
    @discardableResult
    @objc  public func set(message: BaseMessage) -> CometChatSmartReplies {
        parseSmartReplies(forMessage: message)
        return self
    }
    
    private func parseSmartReplies(forMessage: BaseMessage)  {
        var messages : [String] = [String]()
        if forMessage.sender?.uid != CometChat.getLoggedInUser()?.uid {
            if  let metaData = forMessage.metaData , let injected = metaData["@injected"] as? [String : Any], let cometChatExtension =  injected["extensions"] as? [String : Any], let smartReply = cometChatExtension["smart-reply"] as? [String : Any] {
                
                if let positive = smartReply["reply_positive"] {
                    messages.append(positive as! String)
                }
                if let neutral = smartReply["reply_neutral"] {
                    messages.append(neutral as! String)
                }
                if let negative = smartReply["reply_negative"] {
                    messages.append(negative as! String)
                }
                DispatchQueue.main.async { [weak self] in
                    if messages.isEmpty {
                        self?.isHidden = true
                    }else{
                        self?.isHidden = false
                        self?.set(titles: messages)
                    }
                }
            }else{
                DispatchQueue.main.async { [weak self] in
                    self?.isHidden = true
                }
            }
        }else{
            DispatchQueue.main.async { [weak self] in
                self?.isHidden = true
            }
        }
        
    }
    
     // MARK: - Initialization of required Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func draw(_ rect: CGRect) {
        collectionView.showsHorizontalScrollIndicator = false
        setupCollectionView()
    }
    
   // MARK: - Private instance Methods
    
    /// This method will setup the collection view for smart replies
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let CometChatSmartRepliesItem = UINib(nibName: "CometChatSmartRepliesItem", bundle: CometChatUIKit.bundle)
        collectionView.register(CometChatSmartRepliesItem, forCellWithReuseIdentifier: "CometChatSmartRepliesItem")
    }
    
    private func sendTextMessage(for message: String, _ forEntity: AppEntity) {
        if !message.isEmpty {
            var textMessage: TextMessage?
            if let uid = (forEntity as? User)?.uid {
                textMessage =  TextMessage(receiverUid: uid, text: message, receiverType: .user)
            }else if  let guid = (forEntity as? Group)?.guid {
                textMessage =  TextMessage(receiverUid: guid, text: message, receiverType: .group)
            }
            textMessage?.muid = "\(Int(Date().timeIntervalSince1970 * 1000))"
            textMessage?.senderUid = CometChatMessages.loggedInUser?.uid ?? ""
            textMessage?.sender = CometChatMessages.loggedInUser
            
            if let textMessage = textMessage {
                CometChatSoundManager().play(sound: .outgoingMessage)
                CometChatMessageEvents.emitOnMessageSent(message: textMessage, status: .inProgress)
                
                CometChat.sendTextMessage(message: textMessage) { updatedTextMessage in
                    CometChatMessageEvents.emitOnMessageSent(message: updatedTextMessage, status: .success)
                    
                } onError: { error in
                    if let error = error {
                        textMessage.metaData = ["error": true]
                        CometChatMessageEvents.emitOnError(message: textMessage, error: error)
                    }
                }
            }
        }
    }
}

/*  ----------------------------------------------------------------------------------------- */

// MARK: - CollectionView Delegate Methods

extension CometChatSmartReplies: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    /// Asks your data source object for the number of items in the specified section.
    /// - Parameters:
    ///   - collectionView: An object that manages an ordered collection of data items and presents them using customizable layouts.
    ///   - section: A signed integer value type.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttontitles.count
    }
    
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// - Parameters:
    ///   - collectionView: An object that manages an ordered collection of data items and presents them using customizable layouts.
    ///   - indexPath: A list of indexes that together represent the path to a specific location in a tree of nested arrays.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CometChatSmartRepliesItem", for: indexPath) as! CometChatSmartRepliesItem
        cell.smartRepliesItemDelegate = self
        let title = buttontitles[safe: indexPath.row]
        cell.smartReplyButton.setTitle(title, for: .normal)
        return cell
    }
}


/*  ----------------------------------------------------------------------------------------- */

// MARK: - SmartReplyCell Delegate Method

extension CometChatSmartReplies: CometChatSmartRepliesItemDelegate {
    
    /// This method will trigger when user tap on button in smart replies view.
    /// - Parameters:
    ///   - title: Specifies a string value
    ///   - sender: Specifies a sender of the button.
    func didSendButtonPressed(title: String, sender: UIButton) {
        if let user = user {
            sendTextMessage(for: title, user)
        }
        if let group = group {
            sendTextMessage(for: title, group)
        }
        self.isHidden = true
    }
}

/*  ----------------------------------------------------------------------------------------- */