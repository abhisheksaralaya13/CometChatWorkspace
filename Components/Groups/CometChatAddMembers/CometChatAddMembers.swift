//
//  CometChatAddMembers.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro


// MARK: - Declaring Protocol.
@objc public protocol CometChatAddMembersDelegate {

    /**
     - This method will get triggered when the user clicks on a particular conversation.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onItemClick(user: User)
    
    /**
     - This method will get triggered when the user long press on a particular conversation.
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @objc optional func onItemLongClick(user: User)
    
    
    @objc optional func onError(error: CometChatException)
}


class CometChatAddMembers: CometChatListBase {

    @IBOutlet weak var userList: CometChatUserList!

    var addMemberButton: UIBarButtonItem?
    var configurations: [CometChatConfiguration]?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        addObervers()
        configureAddMemberList()
    }
    
    deinit {
       
    }
    
    
    @discardableResult
    public func set(group: Group?) ->  CometChatAddMembers {
        if let group = group {
            self.group = group
        }
        return self
    }
    
    @discardableResult
    public func hide(addMember: Bool) ->  CometChatAddMembers {
        if !addMember {
            addMemberButton = UIBarButtonItem(title: "ADD".localize(), style: .done, target: self, action: #selector(self.didAddMembersPressed))
            self.navigationItem.rightBarButtonItem = addMemberButton
        }
        return self
    }
  
    /**
     This method will set the icon for the start conversation icon tint color  in `CometChatGroups`
     - Parameters:
     - createGroupIcon: This method will set the icon tint color for the start conversation  in CometChatGroups
     - Returns: This method will return `CometChatGroups`
     - Author: CometChat Team
     - Copyright:  ©  2022 CometChat Inc.
     */
    @discardableResult
    public func set(addMemberTint: UIColor) ->  CometChatAddMembers {
        addMemberButton?.tintColor = addMemberTint
        return self
    }
    
    @objc func didAddMembersPressed(){
        if !userList.selectedUsers.isEmpty {
            var members: [GroupMember] = [GroupMember]()
            var member: GroupMember?
            
            for user in userList.selectedUsers {
                member = GroupMember(UID: user.uid ?? "", groupMemberScope: .participant)
                if let member = member {
                    members.append(member)
                }
            }
            
         

            CometChat.addMembersToGroup(guid: group?.guid ?? "", groupMembers: members) { fetchedMembers in
                
                print("fetchedMembers: \(fetchedMembers)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                 
            
                    CometChat.getGroup(GUID: self.group?.guid ?? "") { group in
                        
                        CometChatGroups.emitOnGroupMemberAdd(group: group, members: members)
                        
                    } onError: { error in
                        
                    }
                  
                    self.dismiss(animated: true) {
                        
                        
                        CometChatSnackBoard.display(message: "Members added successfully", mode: .success, duration: .short)
                    }
                })
            } onError: { error in
                if let error = error {
                    CometChatSnackBoard.showErrorMessage(for: error)
                }
                
            }
            
        }
    }
    
    
    @discardableResult
    public func set(configurations: [CometChatConfiguration]) ->  CometChatAddMembers {
        self.configurations = configurations
        return self
    }

    private func setupAppearance() {
        if #available(iOS 13.0, *) {
            self.set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
            self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
                .set(searchPlaceholder: "SEARCH".localize())
                .set(searchTextColor: .label)
                .set(title: "ADD_MEMBERS".localize(), mode: .automatic)
                .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.black)
                .hide(search: false)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureAddMemberList() {
        hide(addMember: false)
            
        self.set(backButtonTitle: "CANCEL".localize())
            .show(backButton: true)
        userList.set(controller: self)
            .set(configurations: configurations)
            .set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
            .set(sectionHeaderBackground: CometChatTheme.palatte?.secondary ?? UIColor.clear)
            .set(sectionHeaderTextColor:  CometChatTheme.palatte?.accent500 ?? UIColor.black)
            .set(sectionHeaderTextFont: CometChatTheme.typography?.Caption1 ?? UIFont.systemFont(ofSize: 13, weight: .medium))
        
        userList.enable(selection: true)
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
    }
    
    private func removeObervers() {
        
    }
}

extension CometChatAddMembers: CometChatListBaseDelegate {
 
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

extension CometChatAddMembers {
    static var comethatUsersDelegate: CometChatAddMembersDelegate?
}




