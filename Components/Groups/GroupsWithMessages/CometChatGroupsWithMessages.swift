//
//  CometChatGroupsWithMessages.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro

class CometChatGroupsWithMessages: CometChatGroups {

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    deinit {
       
    }
   
    override func onCreateGroupClick() {
        
    }
    

  
    override func onGroupMemberAdd(group: Group, members: [GroupMember]) {
        
    }
    
    override func onItemClick(group: Group, index: IndexPath?) {
        if group.hasJoined == true {
            let messages = CometChatMessages()
            messages.set(group: group)
            if navigationController != nil {
                self.navigationController?.pushViewController(messages, animated: true)
            }else{
                self.present(messages, animated: true)
            }
        }
    }
    
    override func onGroupCreate(group: Group) {
        groupList.add(group: group)
        if group.hasJoined == true {
            let messages = CometChatMessages()
            messages.set(group: group)
            if navigationController != nil {
                self.navigationController?.pushViewController(messages, animated: true)
            }else{
                self.present(messages, animated: true)
            }
        }
    }
    
    override func onGroupMemberJoin(joinedUser: User, joinedGroup: Group) {
        groupList.update(group: joinedGroup)
        if joinedGroup.hasJoined == true {
            let messages = CometChatMessages()
            messages.set(group: joinedGroup)
            if navigationController != nil {
                self.navigationController?.pushViewController(messages, animated: true)
            }else{
                self.present(messages, animated: true)
            }
        }
    }
    
    
    override func onItemLongClick(group: Group, index: IndexPath?) {
        
    }
    
    override func onGroupDelete(group: Group) {
        groupList.remove(group: group)
    }
    
    override func onGroupMemberLeave(leftUser: User, leftGroup: Group) {
        if joinedOnly == true {
            groupList.remove(group: leftGroup)
        }else{
            leftGroup.hasJoined = false
            groupList.update(group: leftGroup)
        }
    }
    

    override func onGroupMemberBan(bannedUser: User, bannedGroup: Group) {
        
    }
    
    override func onGroupMemberUnban(unbannedUserUser: User, unbannedUserGroup: Group) {
        
    }
    
    override func onGroupMemberKick(kickedUser: User, kickedGroup: Group) {
        
    }
    
    override func onGroupMemberChangeScope(updatedBy: User, updatedUser: User, scopeChangedTo: CometChat.MemberScope, scopeChangedFrom: CometChat.MemberScope, group: Group) {
        
    }
    
    override func onError(group: Group?, error: CometChatException) {
        
    }
    
    
   
}


