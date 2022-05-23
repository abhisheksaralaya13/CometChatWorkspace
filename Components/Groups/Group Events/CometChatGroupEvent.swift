//
//  CometChatGroupEvents.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 13/05/22.
//

import UIKit
import CometChatPro
import Foundation


@objc public protocol CometChatGroupEvents {
    
    func onItemClick(group: Group, index: IndexPath?)
    func onGroupMemberAdd(group: Group, members: [GroupMember])
    func onItemLongClick(group: Group, index: IndexPath?)
    func onCreateGroupClick()
    func onGroupCreate(group: Group)
    func onGroupDelete(group: Group)
    func onGroupMemberLeave(leftUser: User, leftGroup:  Group)
    func onGroupMemberJoin(joinedUser: User, joinedGroup:  Group)
    func onGroupMemberBan(bannedUser: User, bannedGroup:  Group)
    func onGroupMemberUnban(unbannedUserUser: User, unbannedUserGroup:  Group)
    func onGroupMemberKick(kickedUser: User, kickedGroup:  Group)
    func onGroupMemberChangeScope(updatedBy: User , updatedUser: User , scopeChangedTo: CometChat.MemberScope , scopeChangedFrom: CometChat.MemberScope, group: Group)
    func onError(group: Group?, error: CometChatException)
    
}

extension CometChatGroups {
    
    static private var observer = [String: CometChatGroupEvents]()
    
    @objc public static func addListener(_ id: String,_ observer: CometChatGroupEvents) {
        CometChatGroups.observer[id] = observer
    }
    
    @objc public static func removeListner(_ id: String) {
        CometChatGroups.observer.removeValue(forKey: id)
    }
    
    
    internal static  func emitOnItemClick(group: Group, index: IndexPath?) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onItemClick(group: group, index: index)
        })
    }
    
    internal static  func emitOnItemLongClick(group: Group, index: IndexPath?) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onItemLongClick(group: group, index: index)
        })
    }
    
    internal static  func emitOnCreateGroupClick() {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onCreateGroupClick()
        })
    }
    
    internal static  func emitOnGroupCreate(group: Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupCreate(group: group)
        })
    }
    internal static  func emitOnGroupDelete(group: Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupDelete(group: group)
        })
    }
    internal static  func emitOnGroupMemberLeave(leftUser: User, leftGroup:  Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberLeave(leftUser: leftUser, leftGroup: leftGroup)
        })
    }
    internal static  func emitOnGroupMemberJoin(joinedUser: User, joinedGroup:  Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberJoin(joinedUser: joinedUser, joinedGroup: joinedGroup)
        })
    }
    internal static  func emitOnGroupMemberBan(bannedUser: User, bannedGroup:  Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberBan(bannedUser: bannedUser, bannedGroup: bannedGroup)
        })
    }
    internal static  func emitOnGroupMemberUnban(unbannedUserUser: User, unbannedUserGroup:  Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberUnban(unbannedUserUser: unbannedUserUser, unbannedUserGroup: unbannedUserGroup)
        })
    }
    internal static  func emitOnGroupMemberKick(kickedUser: User, kickedGroup:  Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberKick(kickedUser: kickedUser, kickedGroup: kickedGroup)
        })
    }
    
    internal static  func emitOnGroupMemberAdd(group: Group, members: [GroupMember]) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberAdd(group: group, members: members)
        })
    }
    
    
    internal static  func emitOnGroupMemberChangeScope(updatedBy: User , updatedUser: User , scopeChangedTo: CometChat.MemberScope , scopeChangedFrom: CometChat.MemberScope, group: Group) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onGroupMemberChangeScope(updatedBy: updatedBy, updatedUser: updatedUser, scopeChangedTo: scopeChangedTo, scopeChangedFrom: scopeChangedFrom, group: group)
        })
    }
    internal static  func emitOnError(group: Group?, error: CometChatException) {
        CometChatGroups.observer.forEach({
            (key,observer) in
            observer.onError(group: group, error: error)
        })
    }
    
  
}
