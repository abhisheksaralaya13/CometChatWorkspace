//
//  CometChatViewMembers.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro


class CometChatViewMembers: CometChatListBase {

    @IBOutlet weak var memberList: CometChatMemberList!
    var configurations: [CometChatConfiguration]?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addObervers()
        configureViewMembers()
        
    }
    
    deinit {
        
    }
    
    
    @discardableResult
    @objc public func set(group: Group?) -> CometChatViewMembers {
        self.group = group
        return self
    }
    
    
    @discardableResult
    @objc public func set(configurations: [CometChatConfiguration]?) -> CometChatViewMembers {
        self.configurations = configurations
        return self
    }

    private func setupAppearance() {
        if #available(iOS 13.0, *) {
            self.set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
            self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
                .set(searchPlaceholder: "SEARCH".localize())
                .set(searchTextColor: .label)
                .set(title: "MEMBERS".localize(), mode: .automatic)
                .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.black)
                .hide(search: false)
                .set(backButtonTitle: "CANCEL".localize())
                .show(backButton: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureViewMembers() {
        
        memberList.set(controller: self)
            .set(group: group)
            .set(configurations: configurations)
            .set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
        memberList.allow(promoteDemoteMembers: true)
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
    }
    
    private func removeObervers() {
       
    }
}

extension CometChatViewMembers: CometChatListBaseDelegate {
 
    public func onSearch(state: SearchState, text: String) {
        switch state {
        case .clear:
            memberList.isSearching = false
            memberList.filterGroupMembers(forText: "")
        case .filter:
            memberList.isSearching = true
            memberList.filterGroupMembers(forText: text)
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

extension CometChatViewMembers {
    //static var comethatMemberDelegate: ComethatMemberDelegate?
}
