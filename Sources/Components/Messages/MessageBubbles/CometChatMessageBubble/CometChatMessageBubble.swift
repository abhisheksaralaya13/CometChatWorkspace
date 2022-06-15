//
//  CometChatMessageBubble.swift
//  CometChatUIKit
//
//  Created by Abdullah Ansari on 12/05/22.
//

import UIKit
import CometChatPro

enum  MessageBubbleAllignment {
    case left
    case right
}


public enum  MessageBubbleTimeAlignment {
    case top
    case bottom
}


class CometChatMessageBubble: UITableViewCell {
    
    @IBOutlet weak var backgroundWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alightmentStack: UIStackView!
    @IBOutlet weak var avatar: CometChatAvatar!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var background: CometChatGradientView!
    @IBOutlet weak var sentimentAnalysisView: UIView!
    @IBOutlet weak var message: HyperlinkLabel!
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var sentimentAnalysisButton: UIButton!
    @IBOutlet weak var sentimentAnalysisButtonLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var avatarWidth: NSLayoutConstraint!
    @IBOutlet weak var topTime: CometChatDate!
    @IBOutlet weak var time: CometChatDate!
    @IBOutlet weak var leadingReplyButton: UIButton!
    @IBOutlet weak var trailingReplyButton: UIButton!
    @IBOutlet weak var receipt: CometChatMessageReceipt!
    @IBOutlet weak var receiptStack: UIStackView!
    @IBOutlet weak var reactions: CometChatMessageReactions!
  //  @IBOutlet weak var reactions: UIView!
    
    private var allMessageOptions = [String: [CometChatMessageOption]]()
    var messageOptions: [CometChatMessageOption] = []
    var controller: UIViewController?
    var messageListAlignment: MessageAlignment = .standard
    var configuration: CometChatConfiguration?
    var configurations: [CometChatConfiguration]?
    var sentMessageInputData: SentMessageInputData?
    var receivedMessageInputData: ReceivedMessageInputData?
    
    var indexPath: IndexPath?
    unowned var selectionColor: UIColor {
        set {
            let view = UIView()
            view.backgroundColor = newValue
            self.selectedBackgroundView = view
        }
        get {
            return self.selectedBackgroundView?.backgroundColor ?? UIColor.white
        }
    }
    
    // TODO: - Should be replace since requirement has been changed. There is no requirement of this method as of now.
    @discardableResult
    @objc public func set(corner: CometChatCorner) -> Self {
        switch corner.corner {
        case .leftTop:
            self.background.roundViewCorners([.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: corner.radius)
        case .rightTop:
            self.background.roundViewCorners([.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: corner.radius)
        case .leftBottom:
            self.background.roundViewCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: corner.radius)
        case .rightBottom:
            self.background.roundViewCorners([.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner], radius: corner.radius)
        case .none:
            self.background.roundViewCorners([.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: corner.radius)
        }
        
        return self
    }
    
    @discardableResult
    @objc public func set(sentMessageInputData: SentMessageInputData) -> Self {
        self.sentMessageInputData = sentMessageInputData
        return self
    }
    
    @discardableResult
    @objc public func set(receivedMessageInputData: ReceivedMessageInputData) -> Self {
        self.receivedMessageInputData = receivedMessageInputData
        return self
    }
    
    @discardableResult
    @objc public func set(backgroundRadius: CGFloat) -> Self {
        background.layer.cornerRadius = backgroundRadius
        return self
    }
    
    @discardableResult
    public func set(allMessageOptions: [String: [CometChatMessageOption]]) -> Self {
        self.allMessageOptions = allMessageOptions
        return self
    }
    
    @discardableResult
    public func set(messageOptions: [CometChatMessageOption]) -> Self {
        self.messageOptions = messageOptions
        return self
    }
    
    @discardableResult
    public func set(backgroundColor: [Any]?) ->  Self {
        if let backgroundColors = backgroundColor as? [CGColor] {
            if backgroundColors.count == 1 {
                self.background.backgroundColor = UIColor(cgColor: backgroundColors.first ?? UIColor.blue.cgColor)
            }else{
                self.background.set(backgroundColorWithGradient: backgroundColor)
            }
        }
        return self
    }
    
    @discardableResult
    @objc public func set(avatar: CometChatAvatar) -> Self {
        self.avatar = avatar
        return self
    }
    
    @discardableResult
    @objc public func set(userName: String) -> Self {
        self.name.text = userName
        return self
    }
    
    @discardableResult
    @objc public func set(userNameFont: UIFont) -> Self {
        self.name.font = userNameFont
        return self
    }
    
    @discardableResult
    @objc public func set(userNameColor: UIColor) -> Self {
        self.name.textColor = userNameColor
        return self
    }
    
    @discardableResult
    @objc func set(borderColor : UIColor) -> Self {
        self.background.layer.borderColor = borderColor.cgColor
        return self
    }
    
    @discardableResult
    @objc func set(borderWidth : CGFloat) -> Self {
        self.background.layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    @objc public func set(receipt: CometChatMessageReceipt) -> Self {
        self.receipt = receipt
        return self
    }
    
    @discardableResult
    @objc public func set(reactions forMessage: BaseMessage, with alignment: MessageBubbleAlignment) -> Self {
        self.reactions.parseMessageReactionForMessage(message: forMessage) { (success) in
            if success == true {
                if alignment == .right {
                    self.reactions.collectionView.semanticContentAttribute = .forceRightToLeft
                }
                self.reactions.isHidden = false
            }else{
                self.reactions.isHidden = false
            }
        }
        return self
    }
    
    @discardableResult
     public func set(timeAlignment: MessageBubbleTimeAlignment) -> Self {
        switch timeAlignment {
        case .top:
            self.time.isHidden = true
            self.topTime.isHidden = false
        case .bottom:
            self.time.isHidden = false
            self.topTime.isHidden = true
        }
        return self
    }
    
    @discardableResult
    public func set(messageAlignment: MessageAlignment) -> Self {
        self.messageListAlignment = messageAlignment
        switch messageAlignment {
        case .standard:
            set(timeAlignment: .bottom)
        case .leftAligned:
            set(timeAlignment: .top)
        }
        return self
    }
    
    
    @discardableResult
    @objc public func set(messageObject: BaseMessage) -> Self {
        configureCell(baseMessage: messageObject)
        return self
    }
    
    @discardableResult
    @objc public func set(controller: UIViewController) -> Self {
        self.controller = controller
        return self
    }
    
    @discardableResult
    @objc public func set(configuration: CometChatConfiguration) -> Self {
        self.configuration = configuration
        return self
    }
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  Self {
        self.configurations = configurations
        return self
    }
    
    @discardableResult
    public func hide(avatar: Bool) ->  Self {
        self.avatar.isHidden = avatar
        self.avatarWidth.constant = 0
        return self
    }
    
    @discardableResult
    public func hide(time: Bool) ->  Self {
        self.time.isHidden = time
        self.topTime.isHidden = time
        return self
    }
    
    @discardableResult
    public func hide(title: Bool) ->  Self {
        self.name.isHidden = title
        return self
    }
    
    @discardableResult
    public func hide(receipt: Bool) ->  Self {
        self.receipt.isHidden = receipt
        return self
    }
    
    @discardableResult
    @objc public func set(messageAlignment: MessageBubbleAlignment) -> Self {
        let leftAligment = messageAlignment == .left
        name.isHidden = leftAligment ? false : true
        alightmentStack.alignment = leftAligment ? .leading : .trailing
        spacer.isHidden = leftAligment ? false : true
        avatar.isHidden = leftAligment ? false : true
        receipt.isHidden = true
        leadingReplyButton.isHidden = leftAligment ? true : true
        trailingReplyButton.isHidden = leftAligment ? true : true
        return self
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13.0, *) {
            selectionColor = .systemBackground
        } else {
            selectionColor = .white
        }
        print(receipt.isHidden)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func configureMessageBubble(forMessage: BaseMessage) {
       
        if let configurations = configurations {
            if let messageListConfiguration = configurations.filter({ $0 is MessageListConfiguration}).last as? MessageListConfiguration , let messageBubbleConfiguration =  messageListConfiguration.messageBubbleConfiguration {
            
                if let configuration = messageBubbleConfiguration.avatarConfiguration {
                    avatar.set(cornerRadius: configuration.cornerRadius)
                    avatar.set(borderWidth: configuration.borderWidth)
                    if configuration.outerViewWidth != 0 {
                        avatar.set(outerView: true)
                        avatar.set(borderWidth: configuration.outerViewWidth)
                    }
                    self.set(avatar: avatar)
                }
                
                if let configuration = messageBubbleConfiguration.messageReceiptConfiguration {
                    self.receipt.set(messageInProgressIcon: configuration.getProgressIcon())
                    self.receipt.set(messageSentIcon: configuration.getSentIcon())
                    self.receipt.set(messageDeliveredIcon: configuration.getDeliveredIcon())
                    self.receipt.set(messageReadIcon: configuration.getReadIcon())
                    self.receipt.set(messageErrorIcon: configuration.getFailureIcon())
                }
                
                if let sentMessageInputData = messageBubbleConfiguration.sentMessageInputData {
                    self.set(sentMessageInputData: sentMessageInputData)
                }
                
                if let receivedMessageInputData = messageBubbleConfiguration.receivedMessageInputData {
                    self.set(receivedMessageInputData: receivedMessageInputData)
                }
                
                self.set(timeAlignment: messageBubbleConfiguration.timeAlignment)
                
                if let sentMessageInputData = sentMessageInputData {
                    
                    if forMessage.sender?.uid == CometChat.getLoggedInUser()?.uid {
                        
                        if let thumbail = sentMessageInputData.thumbnail {
                            hide(avatar: !thumbail)
                        }
                        
                        if let time = sentMessageInputData.timestamp {
                            hide(time: !time)
                        }
                        
                        if let title = sentMessageInputData.title {
                            hide(title: !title)
                        }
                        
                        if let receipt = sentMessageInputData.readReceipt {
                            hide(receipt: !receipt)
                        }
                        
                    }
                }
                
                if let receivedMessageInputData = receivedMessageInputData {
                    
                    if forMessage.sender?.uid != CometChat.getLoggedInUser()?.uid {
                        
                        if let thumbail = receivedMessageInputData.thumbnail {
                            hide(avatar: !thumbail)
                        }
                        
                        if let time = receivedMessageInputData.timestamp {
                            hide(time: !time)
                        }
                        
                        if let title = receivedMessageInputData.title {
                            hide(title: !title)
                        }
                        
                        if let receipt = receivedMessageInputData.readReceipt {
                            hide(receipt: !receipt)
                        }
                    }
                }
                
            }
        }else{
            
        }
        
    }
    
    /// Bubble Configuration.
    private func configureCell(baseMessage message: BaseMessage) {
        messageOptions.removeAll()
        
        let isStandard = messageListAlignment == .standard && (message.sender?.uid == CometChatMessages.loggedInUser?.uid)
        // TODO: - Secondary color code is different from #141414
        set(messageAlignment: isStandard ? .right : .left)
        background.backgroundColor = isStandard ? CometChatTheme.palatte?.primary : CometChatTheme.palatte?.secondary
        set(avatar:self.avatar.setAvatar(avatarUrl: message.sender?.avatar ?? "", with: message.sender?.name ?? ""))
        set(userName: (message.sender?.name)!)
        set(backgroundRadius: 12.0)
        
        // To hide & show receipt
        if !isStandard {
            self.receipt.isHidden = true
        } else {
            set(receipt: receipt.set(receipt: message))
        }
        
        if message.deletedAt > 0.0 {
            backgroundHeightConstraint.constant = 36
            backgroundWidthConstraint.constant = 173
            let deleteBubble = CometChatDeleteBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
            background.backgroundColor = .clear
            background.addSubview(deleteBubble)
            configureMessageBubble(forMessage: message)
            return
        }
        
        switch (message.messageCategory, message.messageType) {
            
        case (.message, .text): /// category - message && type - text
            guard let message = message as? TextMessage else { print("Text messag not found."); return }
            debugPrint(" ---> message text")
          
            if let translatedMessage = message.metaData?["translated-message"] as? String {
                let widthFixed = 228.0
                let heightFixed = 22.0
               // let fullMessage = message.text + "\n\n" + translatedMessage + "\n\nTranslated message"
                let messageHeight = (message.text + "\n\n").lowercased().height(widthFixed, font: CometChatTheme.typography!.Body)
                let translatedMessageHeight = (translatedMessage + "\n\n").lowercased().height(widthFixed, font: CometChatTheme.typography!.Subtitle2)
                let translatedStringHeight = "TRANSLATED_MESSAGE".localize().height(widthFixed, font: CometChatTheme.typography!.Caption2)
                
                let height = messageHeight + translatedMessageHeight + translatedStringHeight
                print("Height for \(message.text) is \(height)")
                let widthE = message.text.width(heightFixed, font: CometChatTheme.typography!.Body)
                let widthO = translatedMessage.width(heightFixed, font: CometChatTheme.typography!.Body)
                let widthM = widthE > widthO ? widthE : widthO
                backgroundHeightConstraint.constant = height < heightFixed ? 36 : height - 5
                let translatedStringWidth = "TRANSLATED_MESSAGE".localize().width(heightFixed, font: CometChatTheme.typography!.Caption2)
                let width = widthM > translatedStringWidth ? widthM : translatedStringWidth
                backgroundWidthConstraint.constant = width > widthFixed ? widthFixed + 20: width + 20
                let textBubble = CometChatTextBubble(frame: CGRect(x: 10, y: -5, width: backgroundWidthConstraint.constant - 15 , height: height), message: message, isStandard: isStandard)
                background.addSubview(textBubble)
            } else {
                let widthFixed = 228.0
                let heightFixed = 22.0
                let height = message.text.lowercased().height(widthFixed, font: CometChatTheme.typography!.Body)
                print("Height for \(message.text) is \(height)")
                let width = message.text.width(heightFixed, font: CometChatTheme.typography!.Body)
                backgroundHeightConstraint.constant = height < heightFixed ? 36 : height + 20
                backgroundWidthConstraint.constant = width > widthFixed ? widthFixed + 20: width + 20
                let textBubble = CometChatTextBubble(frame: CGRect(x: 10, y: 8, width: backgroundWidthConstraint.constant - 15 , height: height ), message: message, isStandard: isStandard)
                background.addSubview(textBubble)
            }
            if allMessageOptions.isEmpty {
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .edit),
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .copy),
                    CometChatMessageOption(defaultOption: .share),
                    CometChatMessageOption(defaultOption: .translate)
                ]
                self.set(messageOptions: defaultOptions)
            }else{
                if let fetchedOptions = allMessageOptions["text"] {
                    self.set(messageOptions: fetchedOptions)
                }
            }
                set(reactions: message, with: isStandard ? .right : .left)
              
             //   reactions.addSubview(CometChatMessageReactions(frame: CGRect(x: 0, y: 0, width: background.frame.width, height: 60)))
     
            
        case (.message, .image): /// category - message && type - image
            guard let message = message as? MediaMessage else { print("Media message not found."); return }
            debugPrint(" ---> message image")
            backgroundHeightConstraint.constant = 168
            backgroundWidthConstraint.constant = 228
            let imageBubble = CometChatImageBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message)
            background.addSubview(imageBubble)
            if let controller = controller {
                imageBubble.set(controller: controller)
            }
            imageBubble.imageThumbnail.image = UIImage(named: "default-image")
            if allMessageOptions.isEmpty {
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .share)
                ]
                self.set(messageOptions: defaultOptions)
            }else{
                if let fetchedOptions = allMessageOptions["image"] {
                    self.set(messageOptions: fetchedOptions)
                }
            }
            
        case (.message, .audio): /// category  - message && type - audio
            guard let message = message as? MediaMessage else { print("Media message not found."); return }
            debugPrint(" ---> message audio")
            backgroundHeightConstraint.constant = 56
            backgroundWidthConstraint.constant = 228
            //TODO: - Replace with CometChatAudioBubble
            let audioBubble = CometChatFileBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
            background.addSubview(audioBubble)
            
            if allMessageOptions.isEmpty {
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .share)
                ]
                self.set(messageOptions: defaultOptions)
            }else{
                if let fetchedOptions = allMessageOptions["audio"] {
                    self.set(messageOptions: fetchedOptions)
                }
            }
            
        case (.message, .video): /// category - message && type - video
            guard let message = message as? MediaMessage else { print("Media message not found."); return }
            debugPrint(" ---> message video")
            backgroundHeightConstraint.constant = 168
            backgroundWidthConstraint.constant = 228
            let videoView = CometChatVideoBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
            background.addSubview(videoView)
            if let controller = controller {
                videoView.set(controller: controller)
            }
            if allMessageOptions.isEmpty {
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .share)
                ]
                self.set(messageOptions: defaultOptions)
            }else{
                if let fetchedOptions = allMessageOptions["video"] {
                    self.set(messageOptions: fetchedOptions)
                }
            }
            
        case (.message, .file): /// category - message && type - file
            guard let message = message as? MediaMessage else { print("Media message not found."); return }
            debugPrint(" ---> message file")
            backgroundWidthConstraint.constant = 228
            backgroundHeightConstraint.constant = 56
            let fileBubble = CometChatFileBubble(frame: CGRect(x: 0, y: 0, width: background.bounds.width, height: 56), message: message, isStandard: isStandard)
            background.addSubview(fileBubble)
            if let controller = controller {
                fileBubble.set(controller: controller)
            }
            if allMessageOptions.isEmpty {
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .share)
                ]
                self.set(messageOptions: defaultOptions)
            }else{
                if let fetchedOptions = allMessageOptions["file"] {
                    self.set(messageOptions: fetchedOptions)
                }
            }
            
        case (.message, .groupMember): /// category - message && type - groupMember
            debugPrint(" ---> message groupMember")
            break
            
        case (.message, .custom):  /// category - message && type - custom
            debugPrint(" ---> message custom")
            break
            
        case (.action, _):  /// category - action && type - all
            debugPrint(" ---> action all")
            break
            
        case (.call, _): /// category - call && type - all
            debugPrint(" ---> call all")
            break
            
        case (.custom, _): /// category - custom && type - all
            guard let message = message as? CustomMessage, let type = message.type else { debugPrint("Either custom message or type of message not found"); return }
            
            switch type {
            case "location": /// type - location
                backgroundHeightConstraint.constant = 230
                backgroundWidthConstraint.constant = 228
                let locationView = CometChatLocationBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
                debugPrint(" ---> custom location")
                background.addSubview(locationView)
                
                if let controller = controller {
                    locationView.set(controller: controller)
                }
                
                if allMessageOptions.isEmpty {
                    let defaultOptions = [
                        CometChatMessageOption(defaultOption: .delete),
                        CometChatMessageOption(defaultOption: .share)
                    ]
                    self.set(messageOptions: defaultOptions)
                }else{
                    if let fetchedOptions = allMessageOptions["location"] {
                        self.set(messageOptions: fetchedOptions)
                    }
                }
                
            case "extension_poll": /// type - extension_poll
                
                if let metaData = message.metaData , let injected = metaData["@injected"] as? [String : Any], let cometChatExtension =  injected["extensions"] as? [String : Any], let pollsDictionary = cometChatExtension["polls"] as? [String : Any], let results = pollsDictionary["results"] as? [String: Any], let options = results["options"] as? [String: Any], let currentQuestion = pollsDictionary["question"] as? String {
                    
                    backgroundWidthConstraint.constant = 228
                    let height = currentQuestion.height(backgroundWidthConstraint.constant, font: CometChatTheme.typography!.Name2)
                    print("height for \(currentQuestion) will be \(height)")
                    backgroundHeightConstraint.constant =  CGFloat( 140 + (options.count > 2 ? (options.count - 2) * 40 : 0)) + CGFloat(height > height - 18 ? height: 0)
                    
                    let pollView = CometChatPollsBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard, isSender: (message.sender?.uid == CometChatMessages.loggedInUser?.uid))
                    background.addSubview(pollView)
                    
                    if allMessageOptions.isEmpty {
                        let defaultOptions = [
                            CometChatMessageOption(defaultOption: .delete),
                            CometChatMessageOption(defaultOption: .share)
                        ]
                        self.set(messageOptions: defaultOptions)
                    }else{
                        if let fetchedOptions = allMessageOptions["extension_poll"] {
                            self.set(messageOptions: fetchedOptions)
                        }
                    }
                }
                
            case "extension_sticker": /// type - extension_sticker
                backgroundHeightConstraint.constant = 140
                backgroundWidthConstraint.constant = 130
                let stickyBubble = CometChatStickerBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message)
                debugPrint(" ---> custom extesnsion_sticker")
                background.addSubview(stickyBubble)
                
                if allMessageOptions.isEmpty {
                    let defaultOptions = [
                        CometChatMessageOption(defaultOption: .delete),
                        CometChatMessageOption(defaultOption: .share)
                    ]
                    self.set(messageOptions: defaultOptions)
                }else{
                    if let fetchedOptions = allMessageOptions["extension_sticker"] {
                        self.set(messageOptions: fetchedOptions)
                    }
                }
                
            case "extension_whiteboard": /// type - extension_whiteboard
                backgroundHeightConstraint.constant = 140
                backgroundWidthConstraint.constant = 228
                let whiteboardView = CometChatWhiteboardBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
                if let controller = controller {
                    whiteboardView.set(controller: controller)
                }
                debugPrint(" ---> custom extesnsion_whiteboard")
                background.addSubview(whiteboardView)
                
                if allMessageOptions.isEmpty {
                    let defaultOptions = [
                        CometChatMessageOption(defaultOption: .delete),
                        CometChatMessageOption(defaultOption: .share)
                    ]
                    self.set(messageOptions: defaultOptions)
                }else{
                    if let fetchedOptions = allMessageOptions["extension_whiteboard"] {
                        self.set(messageOptions: fetchedOptions)
                    }
                }
                
            case "extension_document": /// type - extension_document
                backgroundHeightConstraint.constant = 140
                backgroundWidthConstraint.constant = 228
                let documentView = CometChatDocumentBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message, isStandard: isStandard)
                if let controller = controller {
                    documentView.set(controller: controller)
                }
                debugPrint(" ---> custom extesnsion_document")
                background.addSubview(documentView)
                
                if allMessageOptions.isEmpty {
                    let defaultOptions = [
                        CometChatMessageOption(defaultOption: .delete),
                        CometChatMessageOption(defaultOption: .share)
                    ]
                    self.set(messageOptions: defaultOptions)
                }else{
                    if let fetchedOptions = allMessageOptions["extension_document"] {
                        self.set(messageOptions: fetchedOptions)
                    }
                }
                
            case "meeting": /// type - meeting.
                debugPrint("Meeting")
                
            default: /// Inner default.
                // Custom message placeholder cell.
                debugPrint("Custom message placeholder cell.")
                backgroundHeightConstraint.constant = 140
                backgroundWidthConstraint.constant = 228
                let customView = CometChatCustomBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message)
                background.addSubview(customView)
                
                let defaultOptions = [
                    CometChatMessageOption(defaultOption: .delete),
                    CometChatMessageOption(defaultOption: .share)
                ]
                self.set(messageOptions: defaultOptions)
                
            }
            
        default: /// Outer default.
            print("default message.")
            backgroundHeightConstraint.constant =  140
            backgroundWidthConstraint.constant = 228
            guard let message = message as? CustomMessage else { return }
            let customView = CometChatCustomBubble(frame: CGRect(x: 0, y: 0, width: backgroundWidthConstraint.constant, height: backgroundHeightConstraint.constant), message: message)
            background.addSubview(customView)
            
            let defaultOptions = [
                CometChatMessageOption(defaultOption: .delete),
                CometChatMessageOption(defaultOption: .share)
            ]
            self.set(messageOptions: defaultOptions)
        }
        
        if configurations != nil {
            configureMessageBubble(forMessage: message)
        }
        
    }
    

    override func prepareForReuse() {
        /// Remove subviews before resuing the cell.
        background.subviews.forEach({ $0.removeFromSuperview() })
    }
}

// TODO: - This extension should be in other file.
extension String {
    //  This method will calculates the UILabel's width based on text.
    func width(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    //  This method will calculates the UILabel's height based on text.
    func height(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
}
