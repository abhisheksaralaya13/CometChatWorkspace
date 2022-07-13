//
//  CometChatPollBubbleCell.swift
//  DemoCometChat
//
//  Created by Abdullah Ansari on 16/05/22.
//

import UIKit

class CometChatPollBubbleCell: UITableViewCell {

    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var pollButton: UIButton!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var pollBackgroundView: UIProgressView!
    
    var callBack: () -> () = { print("") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        pollBackgroundView.layer.cornerRadius = 12
        pollBackgroundView.clipsToBounds = true
        selectionStyle = .none
        // TODO: This should be set through styling..
        answer.textColor = CometChatTheme.palatte?.accent900
        self.backgroundColor = .clear
    }
    
    func configure(isStandard: Bool, results: [String: Any], indexPath: IndexPath, isSender: Bool, voters: [String]) {
        
        let pollStyle = PollBubbleStyle(
            percentageTextColor: CometChatTheme.palatte?.accent600,
            percentageTextFont: CometChatTheme.typography?.Subtitle1,
            pollButtonColor: CometChatTheme.palatte?.accent400,
            answerTextColor: CometChatTheme.palatte?.accent900,
            answerTextFont: CometChatTheme.typography?.Subtitle1,
            pollBackgroundViewColor: .white,
            spacerViewColor: .clear)
          set(style: pollStyle)

        if  let options = results["options"] as? [String: Any], let total = results["total"] as? Int, let dict = options["\(indexPath.row + 1)"] as? [String: Any], let count = dict["count"] as? Int, let text = dict["text"] as? String {
            answer.text = text
            percentage.text = "\(round((Double(count) / Double(total <= 0 ? 1 : total)) * 100))%"
            
            /// if isSender then hide the poll button and show the percentage and show the anserwedPoll
            /// if !isSender then check voters
            /// if voters.iscontaining the id hide the poll button and show the percentage and show the answeredPoll.
            /// if voters.isnotcontaining id show the poll button and hide the percentage and hide the answeredPoll.
            if isSender {
                pollButton.isHidden = true
                percentage.isHidden = false
            } else if voters.contains(where: CometChatMessages.loggedInUser!.uid!.contains) {
                pollButton.isHidden = true
                percentage.isHidden = false
            } else {
                pollButton.isHidden = false
                percentage.isHidden = true
            }
        }
        pollButton.addTarget(self, action: #selector(onPollClick), for: .touchUpInside)
    }
    
    @objc func onPollClick(_ sender: UIButton) {
        print("poll button clicked: \(sender.tag)")
        callBack()
    }
    
     private func set(style: PollBubbleStyle) -> Self {
        self.set(thumbnailTintColor: style.pollButtonColor!)
        self.set(answetTextColor: style.answeredPollTextColor!)
        self.set(answetTextFont: style.answeredPollTextFont!)
        self.set(spacerViewColor: style.spacerViewColor!)
        self.set(percentageTextColor: style.percentageTextColor!)
        self.set(percentageTextFont: style.percentageTextFont!)
        return self
    }
    
    @discardableResult
    @objc public func set(answetTextColor: UIColor) -> Self {
            self.answer.textColor = answetTextColor
        return self
    }
    
    @discardableResult
    @objc public func set(answetTextFont: UIFont) -> Self {
        self.answer.font = answetTextFont
        return self
    }
    
    @discardableResult
    @objc public func set(percentageTextColor: UIColor) -> Self {
            self.percentage.textColor = percentageTextColor
        return self
    }
    
    @discardableResult
    @objc public func set(percentageTextFont: UIFont) -> Self {
            self.percentage.font = percentageTextFont
        return self
    }
    
    @discardableResult
    @objc public func set(spacerViewColor: UIColor) -> Self {
        self.spaceView.backgroundColor = spacerViewColor
        return self
    }
    
    @discardableResult
    @objc public func set(thumbnailTintColor: UIColor) -> Self {
        self.pollButton.setImage(UIImage(systemName: "circle"), for: .normal)
        self.pollButton.tintColor = thumbnailTintColor
        return self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
