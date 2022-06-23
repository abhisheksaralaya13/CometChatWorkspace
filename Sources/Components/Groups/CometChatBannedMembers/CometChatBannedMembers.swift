//
//  CometChatBannedMembers.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro


class CometChatBannedMembers: CometChatListBase {

    @IBOutlet weak var bannedMemberList: CometChatBannedMemberList!
    var configurations: [CometChatConfiguration]?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addObervers()
        configureBannedMemberList()
    }
    
    deinit {
       
    }
    
    
    @discardableResult
    @objc public func set(group: Group?) -> CometChatBannedMembers {
        self.group = group
        return self
    }
    
    
    @discardableResult
    @objc public func set(configurations: [CometChatConfiguration]?) -> CometChatBannedMembers {
        self.configurations = configurations
        return self
    }

    private func setupAppearance() {
        self.set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
        self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
            .set(searchPlaceholder: "SEARCH".localize())
            .set(searchTextColor: .label)
            .set(title: "BANNED_MEMBERS".localize(), mode: .automatic)
            .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.black)
            .hide(search: false)
            .set(backButtonTitle: "CANCEL".localize())
            .show(backButton: true)
    }
    
    private func configureBannedMemberList() {
        
        bannedMemberList.set(controller: self)
            .set(group: group)
            .set(configurations: configurations)
            .set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
    }
    
    private func removeObervers() {
        
    }
    
}

extension CometChatBannedMembers: CometChatListBaseDelegate {
 
    public func onSearch(state: SearchState, text: String) {
        switch state {
        case .clear:
            bannedMemberList.isSearching = false
            bannedMemberList.filterBannedGroupMembers(forText: "")
        case .filter:
            bannedMemberList.isSearching = true
            bannedMemberList.filterBannedGroupMembers(forText: text)
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

extension CometChatBannedMembers {
    //static var comethatMemberDelegate: ComethatMemberDelegate?
}