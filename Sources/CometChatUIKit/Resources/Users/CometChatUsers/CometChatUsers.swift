//
//  CometChatUsers.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro


class CometChatUsers: CometChatListBase {

    @IBOutlet weak var userList: CometChatUserList!
    var configurations: [CometChatConfiguration]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addObervers()
        configureUserList()
       
    }
    
    deinit {
        
    }
    
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  CometChatUsers {
        self.configurations = configurations
        return self
    }

    private func setupAppearance() {
        self.set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemFill.cgColor])
        self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
            .set(searchPlaceholder: "SEARCH".localize())
            .set(searchTextColor: .label)
            .set(title: "Users".localize(), mode: .automatic)
            .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.black)
            .hide(search: false)
    }
    
   
    private func configureUserList() {
        userList.set(controller: self)
            .set(configurations: configurations)
            .set(background: [ UIColor.systemBackground.cgColor])
            .set(sectionHeaderBackground: CometChatTheme.palatte?.secondary ?? UIColor.systemFill)
            .set(sectionHeaderTextColor:  CometChatTheme.palatte?.accent500 ?? UIColor.black)
            .set(sectionHeaderTextFont: CometChatTheme.typography?.Caption1 ?? UIFont.systemFont(ofSize: 13, weight: .medium))
        
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
        CometChatUsers.addListener("users-listner", self as CometChatUserEvents)
    }
    
    private func removeObervers() {
        CometChatUsers.removeListner("users-listner")
    }
}

extension CometChatUsers: CometChatListBaseDelegate {
 
    public func onSearch(state: SearchState, text: String) {
        switch state {
        case .clear:
            userList.isSearching = false
            userList.filterUsers(forText: "")
        case .filter:
            userList.isSearching = true
            userList.filterUsers(forText: text)
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


extension CometChatUsers: CometChatUserEvents {
   
    func onItemClick(user: User, index: IndexPath?) {
        print(#function)
        CometChatSnackBoard.display(message: #function, mode: .info, duration: .short)
    }
    
    func onItemLongClick(user: User, index: IndexPath?) {
        print(#function)
        CometChatSnackBoard.display(message: #function, mode: .info, duration: .short)
    }
    
    func onUserBlock(user: User) {
        print(#function)
        CometChatSnackBoard.display(message: #function, mode: .info, duration: .short)
    }
    
    func onUserUnblock(user: User) {
        print(#function)
        CometChatSnackBoard.display(message: #function, mode: .info, duration: .short)
    }
    
    func onError(user: User?, error: CometChatException) {
        print(#function)
        CometChatSnackBoard.display(message: #function, mode: .info, duration: .short)
    }
}





