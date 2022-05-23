//
//  CometChatUserEvents.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 13/05/22.
//

import UIKit
import CometChatPro
import Foundation


@objc public protocol CometChatUserEvents {
    
    func onItemClick(user: User, index: IndexPath?)
    func onItemLongClick(user: User, index: IndexPath?)
    func onUserBlock(user: User)
    func onUserUnblock(user: User)
    func onError(user: User?, error: CometChatException)
    
}

extension CometChatUsers {
    
    static private var observer = [String: CometChatUserEvents]()
    
    @objc public static func addListener(_ id: String,_ observer: CometChatUserEvents) {
        CometChatUsers.observer[id] = observer
    }
    
    @objc public static func removeListner(_ id: String) {
        CometChatUsers.observer.removeValue(forKey: id)
    }
    
    
    internal static  func emitOnItemClick(user: User, index: IndexPath?) {
        CometChatUsers.observer.forEach({
            (key,observer) in
            observer.onItemClick(user: user, index: index)
        })
    }
    
    internal static  func emitOnItemLongClick(user: User, index: IndexPath?) {
        CometChatUsers.observer.forEach({
            (key,observer) in
            observer.onItemLongClick(user: user, index: index)
        })
    }
    
    internal static  func emitOnUserBlock(user: User) {
        CometChatUsers.observer.forEach({
            (key,observer) in
            observer.onUserBlock(user: user)
        })
    }
    
    internal static  func emitOnUserUnblock(user: User) {
        CometChatUsers.observer.forEach({
            (key,observer) in
            observer.onUserBlock(user: user)
        })
    }
    
    
    internal static  func emitOnError(user: User?, error: CometChatException) {
        CometChatUsers.observer.forEach({
            (key,observer) in
            observer.onError(user: user, error: error)
        })
    }
    
  
}
