
//  CometChatMessageComposer.swift
//  CometChatUIKit
//  Created by CometChat Inc. on 20/09/19.
//  Copyright ©  2022 CometChat Inc. All rights reserved.

// MARK: - Importing Frameworks.

import UIKit
import Foundation
import CometChatPro


// MARK: - Declaration of Protocol

  protocol CometChatMessageReactionsDelegate: AnyObject {
    func didReactionPressed(reaction:CometChatMessageReaction)
    func didNewReactionPressed()
    func didlongPressOnCometChatMessageReactions(reactions: [CometChatMessageReaction])
}

/*  ----------------------------------------------------------------------------------------- */

@IBDesignable open class CometChatMessageReactions: UIView {
    
      // MARK: - Declaration of Variables
    var message: BaseMessage?
    weak var controller: UIViewController?
    
    var view:UIView!
    var reactions = [CometChatMessageReaction]()

    @IBOutlet weak var collectionView: UICollectionView!
     // MARK: - Declaration of IBOutlet
    
    // MARK: - Initialization of required Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
   
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(_ rect: CGRect) {
        collectionView.showsHorizontalScrollIndicator = false
        setupCollectionView()
    }
    
    @objc public func set(messageObject: BaseMessage) -> Self {
        self.message = messageObject
        return self
    }
    
    @discardableResult
    @objc public func set(controller: UIViewController) -> Self {
        self.controller = controller
        return self
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let reactionIndicatorCell = UINib(nibName: "ReactionCountCell", bundle: CometChatUIKit.bundle)
        collectionView.register(reactionIndicatorCell, forCellWithReuseIdentifier: "reactionCountCell")
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressed))
        self.collectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    func parseMessageReactionForMessage(message: BaseMessage, handler: @escaping (Bool) -> ()) {
    if let metaData = message.metaData , let injected = metaData["@injected"] as? [String : Any], let cometChatExtension =  injected["extensions"] as? [String : Any], let reactionsDictionary = cometChatExtension["reactions"] as? [String : Any] {
        var currentReactions = [CometChatMessageReaction]()
        reactionsDictionary.forEach { (reaction, reactors) in
            if reaction != nil {
                if let reactors = reactors as? [String: Any] {
                    var currentReactors = [CometChatMessageReactor]()
                    reactors.forEach { (uid,user) in
                        let name = (user as? [String:Any])?["name"] as? String ?? ""
                        let avatar = (user as? [String:Any])?["avatar"]  as? String ?? ""
                        let reactor = CometChatMessageReactor(uid: uid, name: name, avatar: avatar)
                        currentReactors.insert(reactor, at: 0)
                    }
                    let reaction = CometChatMessageReaction(title: reaction, name: reaction, messageId: message.id, reactors: currentReactors)
                    currentReactions.insert(reaction, at: 0)
                }
               handler(true)
            }
        }
        //TODO: - Should add default reaction
        self.reactions.append(contentsOf: currentReactions.map{$0})
        if !reactions.isEmpty {
            self.reactions.append(CometChatMessageReaction(title: "", name: "add", messageId: 111111, reactors: []))
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }else{
        handler(false)
    }
    
    }
    
    @objc func didLongPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            CometChatMessageReactions.cometChatMessageReactionsDelegate?.didlongPressOnCometChatMessageReactions(reactions: reactions)
        }
    }
   
}

// MARK: - CollectionView Delegate Methods

extension CometChatMessageReactions: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    /// Asks your data source object for the number of items in the specified section.
    /// - Parameters:
    ///   - collectionView: An object that manages an ordered collection of data items and presents them using customizable layouts.
    ///   - section: A signed integer value type.
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactions.count
    }
    
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// - Parameters:
    ///   - collectionView: An object that manages an ordered collection of data items and presents them using customizable layouts.
    ///   - indexPath: A list of indexes that together represent the path to a specific location in a tree of nested arrays.
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionCountCell", for: indexPath) as! ReactionCountCell
        let reaction = reactions[safe: indexPath.row]
        if reactions.count == indexPath.row + 1 && reactions.count > 1 {
            cell.addReactionsIcon.isHidden = false
            cell.reactionLabel.isHidden = true
            cell.addReactionsIcon.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(onAddReactionsClick))
            tap.numberOfTapsRequired = 1
            cell.addReactionsIcon.addGestureRecognizer(tap)
        } else if reactions.count > 0 {
            cell.addReactionsIcon.isHidden = true
            cell.reactionLabel.isHidden = false
        }
        cell.reaction = reaction
       return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ReactionCountCell, let reaction = cell.reaction {
            CometChatMessageReactions.cometChatMessageReactionsDelegate?.didReactionPressed(reaction: reaction)
        }
    }
    
    @objc func onAddReactionsClick() {
        let emojiKeyboard = CometChatEmojiKeyboard()
        guard let message = message else { return }
        emojiKeyboard.set(message: message)
        controller?.presentPanModal(emojiKeyboard)
    }
}

extension CometChatMessageReactions: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42, height: 30)
    }
}

extension CometChatMessageReactions {
    static var cometChatMessageReactionsDelegate: CometChatMessageReactionsDelegate?
}
