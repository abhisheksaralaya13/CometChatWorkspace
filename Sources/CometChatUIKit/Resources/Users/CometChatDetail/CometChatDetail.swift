//
//  CometChatDetail.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 11/12/21.
//

import UIKit
import CometChatPro


public class CometChatDetail: CometChatListBase {

    
    @IBOutlet weak var sectionList: CometChatSectionList!
    
    var user: User?
    var group: Group?
    lazy var allowBanUnbanMembers = true
    lazy var allowKickMembers = true
    lazy var allowAddMembers = true
    lazy var allowPromoteDemoteMembers = true
    lazy var allowDeleteGroup = true
    lazy var allowLeaveGroup = true
    lazy var viewSharedMedia = true
    lazy var allowBlockUnblockUser = true
    lazy var viewProfile = true
    var configurations: [CometChatConfiguration]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        addObervers()
        configureDetailList()
        
    }
    

    
    @discardableResult
    @objc public func set(configurations: [CometChatConfiguration]?) -> CometChatDetail {
        self.configurations = configurations
        return self
    }
    
    @discardableResult
    @objc public func set(user: User?) -> CometChatDetail {
        if let user = user {
            self.user = user
        }
        return self
    }
    
    @discardableResult
    @objc public func update(user: User?) -> CometChatDetail {
        if let user = user {
            self.user = user
            configureSectionList(forUser: user)
        }
        return self
    }
    
    
    @discardableResult
    @objc public func set(group: Group?) -> CometChatDetail {
        if let group = group {
            self.group = group
        }
        return self
    }
    
    @discardableResult
    @objc public func update(group: Group?) -> CometChatDetail {
        if let group = group {
            self.group = group
            configureSectionList(forGroup: group)
        }
        return self
    }
    
    @discardableResult
     public func allow(banUnbanMembers: Bool?) -> CometChatDetail {
        if let banUnbanMembers = banUnbanMembers {
            self.allowBanUnbanMembers = banUnbanMembers
        }
        return self
    }
    
    @discardableResult
    public func allow(kickMembers: Bool?) -> CometChatDetail {
        if let kickMembers = kickMembers {
            self.allowKickMembers = kickMembers
        }
        return self
    }
    
    @discardableResult
    public func allow(promoteDemoteMembers: Bool?) -> CometChatDetail {
        if let promoteDemoteMembers = promoteDemoteMembers {
            self.allowPromoteDemoteMembers = promoteDemoteMembers
        }
        return self
    }
    
    @discardableResult
    public func allow(addMembers: Bool?) -> CometChatDetail {
        if let addMembers = addMembers {
            self.allowAddMembers = addMembers
        }
        return self
    }
    
    @discardableResult
    public func allow(deleteGroup: Bool?) -> CometChatDetail {
        if let deleteGroup = deleteGroup {
            self.allowDeleteGroup = deleteGroup
        }
        return self
    }
    
    @discardableResult
    public func allow(leaveGroup: Bool?) -> CometChatDetail {
        if let leaveGroup = leaveGroup {
            self.allowLeaveGroup = leaveGroup
        }
        return self
    }
    
    @discardableResult
    public func view(sharedMedia: Bool?) -> CometChatDetail {
        if let sharedMedia = sharedMedia {
            self.viewSharedMedia = sharedMedia
        }
        return self
    }
    
    @discardableResult
    public func allow(blockUnblockUser: Bool?) -> CometChatDetail {
        if let blockUnblockUser = blockUnblockUser {
            self.allowBlockUnblockUser = blockUnblockUser
        }
        return self
    }
    
    @discardableResult
    public func view(profile: Bool?) -> CometChatDetail {
        if let profile = profile {
            self.viewProfile = profile
        }
        return self
    }


    private func setupAppearance() {
        self.set(background: [CometChatTheme.palatte?.secondary?.cgColor ?? UIColor.systemBackground.cgColor])
        self.set(searchBackground: CometChatTheme.palatte?.accent100 ?? UIColor.systemFill)
            .set(searchPlaceholder: "SEARCH".localize())
            .set(searchTextColor: .label)
            .set(title: "DETAILS".localize(), mode: .never)
            .set(titleColor: CometChatTheme.palatte?.accent ?? UIColor.black)
            .hide(search: true)
            .set(backButtonTitle: "CANCEL".localize())
            .show(backButton: true)
    }
    
    private func configureDetailList() {
        
        if user != nil {
            if let link = user?.link {
                view(profile: viewProfile)
            }
            allow(blockUnblockUser: allowBlockUnblockUser)
        }
        
        if group != nil {
            allow(banUnbanMembers: allowBanUnbanMembers)
            allow(kickMembers: allowKickMembers)
            allow(promoteDemoteMembers: allowPromoteDemoteMembers)
            allow(addMembers: allowAddMembers)
            allow(leaveGroup: allowLeaveGroup)
            allow(deleteGroup: allowDeleteGroup)
        }
        
        set(configurations: configurations)
        configureSectionList(forUser: user)
        configureSectionList(forGroup: group)
    }
    
    
    private func configureSectionList(forUser: User?) {
        
        if let user = forUser {
 
            let userData = SectionData(title: "", user: user)
            var actionItems = [ActionItem]()
            
            if let link = user.link {
                
                if viewProfile {
                    
                    let viewProfileAction = ActionItem(id: "view-profile", text: "VIEW_PROFILE".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.primary, textFont: CometChatTheme.typography?.Name2)
                    
                    actionItems.append(viewProfileAction)
                }
            }
            
            if allowBlockUnblockUser {
                
                let blockUserAction = ActionItem(id: "block-user", text: "BLOCK_USER".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.error, textFont: CometChatTheme.typography?.Name2)
                
                actionItems.append(blockUserAction)
                
            }
            let dataItems = SectionData(title: "", actionItems: actionItems)
            
            
            sectionList.set(controller: self)
                       .set(sectionData: [userData,dataItems])
            sectionList.tableView.reloadData()
            
        }
        
    }
    
    private func configureSectionList(forGroup: Group?) {
        if let group = forGroup {
            
            // Group Info
            
            let groupData = SectionData(title: "", group: group)
           
            // Group Member Actions
            
            var groupMemberActions = [ActionItem]()
          
            let viewMemberAction = ActionItem(id: "view-member", text: "VIEW_MEMBERS".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.primary, textFont: CometChatTheme.typography?.Name2)
            
            groupMemberActions.append(viewMemberAction)
            
            if allowAddMembers && forGroup?.scope == .admin {
                
                let addMemberAction = ActionItem(id: "add-member", text: "ADD_MEMBERS".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.primary, textFont: CometChatTheme.typography?.Name2)
                
                groupMemberActions.append(addMemberAction)
                
            }
            
            if allowBanUnbanMembers && (forGroup?.scope == .admin || forGroup?.scope == .moderator)  {
                
                let bannedMemberAction = ActionItem(id: "banned-member", text: "BANNED_MEMBERS".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.primary, textFont: CometChatTheme.typography?.Name2)
                
                groupMemberActions.append(bannedMemberAction)
                
            }
            
            let groupMemberActionItems = SectionData(title: "", actionItems: groupMemberActions)
            
            // Group  Actions
            
            var groupActions = [ActionItem]()
            
            if allowLeaveGroup {
                
                let leaveGroupAction = ActionItem(id: "leave-group", text: "LEAVE_GROUP".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.error, textFont: CometChatTheme.typography?.Name2)
                
                groupActions.append(leaveGroupAction)
                
            }
            
            if allowDeleteGroup && group.owner == CometChat.getLoggedInUser()?.uid {
                
                let deleteGroupAction = ActionItem(id: "delete-group", text: "DELETE_GROUP".localize(), startIcon: nil, endIcon: nil, startIconTint: nil, endIconTint: nil, textColor: CometChatTheme.palatte?.error, textFont: CometChatTheme.typography?.Name2)
                
                groupActions.append(deleteGroupAction)
            }
            
            
            let groupActionItems = SectionData(title: "", actionItems: groupActions)
            
            sectionList.set(controller: self)
                    .set(sectionData: [groupData , groupMemberActionItems , groupActionItems])
            sectionList.tableView.reloadData()
            
        }
        
    }
    
    private func addObervers() {
        self.cometChatListBaseDelegate = self
        CometChatSectionList.sectionListDelegate = self
    }
    
    private func removeObervers() {
      
    }
    
  
}

extension CometChatDetail: CometChatListBaseDelegate{
 
    public func onSearch(state: SearchState, text: String) {
       
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

extension CometChatDetail: CometChatSectionListDelegate {
 
    public func onItemClick(actionItem: ActionItem) {
        if let id = actionItem.id {
            switch id {
            case "view-profile": break
            case "block-user":
                
                break
                
            case "view-member":
           
                let cometChatViewMembers = CometChatViewMembers()
                cometChatViewMembers.set(group: group)
                self.navigationController?.pushViewController(cometChatViewMembers, animated: true)
                
            case "add-member":
                
                let cometChatAddMembers = CometChatAddMembers()
                cometChatAddMembers.set(group: group)
                self.navigationController?.pushViewController(cometChatAddMembers, animated: true)
                
                
            case "banned-member":
                
                let cometChatBannedMembers = CometChatBannedMembers()
                cometChatBannedMembers.set(group: group)
                self.navigationController?.pushViewController(cometChatBannedMembers, animated: true)
                
            case "leave-group":
                
                if let group = group {

                    if group.owner == CometChat.getLoggedInUser()?.uid {
                        let alert = UIAlertController(title: "", message: "TRANSFER_OWNERSHIP_MESSAGE".localize(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "TRANSFER_OWNERSHIP".localize(), style: .default, handler: { (action: UIAlertAction!) in
                            DispatchQueue.main.async {
                                let transferOwnership = CometChatTransferOwnership()
                                transferOwnership.set(group: group)
                                let navigationController: UINavigationController = UINavigationController(rootViewController: transferOwnership)
                                self.present(navigationController, animated: true, completion: nil)
                            }
                    }))
                        alert.addAction(UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                    }))
                    alert.view.tintColor = CometChatTheme.palatte?.primary
                    present(alert, animated: true, completion: nil)
                        
                    }else{
                        
                        let alert = UIAlertController(title: "", message: "USER_LEAVE_GROUP_WARNING".localize(), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "LEAVE".localize(), style: .default, handler: { (action: UIAlertAction!) in
                            if let guid = self.group?.guid {
                                CometChat.leaveGroup(GUID: guid, onSuccess: { (success) in
                                    DispatchQueue.main.async {
                                        if let user = CometChat.getLoggedInUser(), let group = self.group {
                                            CometChatGroups.emitOnGroupMemberLeave(leftUser: user, leftGroup: group)
                                        }
                                        self.dismiss(animated: true) { }
                                    }
                                }) { (error) in
                                    DispatchQueue.main.async {
                                        if let error = error {
                                            CometChatGroups.emitOnError(group: group, error: error)
                                            CometChatSnackBoard.showErrorMessage(for: error)
                                        }
                                    }
                                }
                            }
                    }))
                        alert.addAction(UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                    }))
                        alert.view.tintColor = CometChatTheme.palatte?.primary
                    present(alert, animated: true, completion: nil)
                    }
                }
                
            case "delete-group":
                
                let alert = UIAlertController(title: "", message: "USER_DELETE_GROUP_WARNING".localize(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "DELETE".localize(), style: .default, handler: { (action: UIAlertAction!) in
                    if let group = self.group {
                        CometChat.deleteGroup(GUID: group.guid, onSuccess: { (success) in
                            DispatchQueue.main.async {
                                CometChatGroups.emitOnGroupDelete(group: group)
                                self.dismiss(animated: true) {}
                            }
                        }) { (error) in
                            DispatchQueue.main.async {
                                if let error = error {
                                    CometChatGroups.emitOnError(group: group, error: error)
                                    CometChatSnackBoard.showErrorMessage(for: error)
                                }
                            }
                        }
                    }
            }))
                alert.addAction(UIAlertAction(title: "CANCEL".localize(), style: .cancel, handler: { (action: UIAlertAction!) in
            }))
                alert.view.tintColor = CometChatTheme.palatte?.primary
                present(alert, animated: true, completion: nil)
                
                
            default:
                 break
            }
        }
    }
    
}

