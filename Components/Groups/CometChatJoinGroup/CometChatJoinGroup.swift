//
//  CometChatJoinGroup.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 10/05/22.
//

import UIKit
import CometChatPro

class CometChatJoinGroup: CometChatListBase {
    
    private var continueButton: UIBarButtonItem?
    private var selectedGroupType: CometChat.groupType = .public
    private var groupNameAndPasswordLimit = 100
    private var group: Group?
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        addObervers()
        setupAppearance()
        
    }
    
    deinit {
        
    }
    
    @discardableResult
    public func set(group: Group) ->  CometChatJoinGroup {
        self.group = group
        return self
    }
    
    
    @discardableResult
    public func hide(continueButton: Bool) ->  CometChatJoinGroup {
        if !continueButton {
            self.continueButton = UIBarButtonItem(title: "CONTINUE".localize(), style: .done, target: self, action: #selector(self.didContinueButtonPressed))
            self.navigationItem.rightBarButtonItem = self.continueButton
        }
        return self
    }
    
    @discardableResult
    public func set(continueButtonTint: UIColor) ->  CometChatJoinGroup {
        continueButton?.tintColor = continueButtonTint
        return self
    }
    
    @discardableResult
    public func set(caption: String) ->  CometChatJoinGroup {
        self.caption.text = caption
        return self
    }
    
    @discardableResult
    public func set(captionFont: UIFont) ->  CometChatJoinGroup {
        self.caption.font = captionFont
        return self
    }
    
    @discardableResult
    public func set(captionColor: UIColor) ->  CometChatJoinGroup {
        self.caption.textColor = captionColor
        return self
    }
    
    
    
    @objc func didContinueButtonPressed(){
        
        if let group = group, let password = password.text {
            if password.count == 0 {
                CometChatSnackBoard.display(message: "GROUP_PASSWORD_CANNOT_EMPTY".localize(), mode: .error, duration: .short)
            }else{
                CometChat.joinGroup(GUID: group.guid, groupType: .password, password: password) { joinSuccess in
                    DispatchQueue.main.async { [weak self] in
                        
                        if let user = CometChat.getLoggedInUser() {
                            
                            CometChatGroups.emitOnGroupMemberJoin(joinedUser: user, joinedGroup: joinSuccess)
                        }
                        self?.dismiss(animated: true, completion: nil)
                        self?.removeObervers()
                    }
                } onError: { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            CometChatSnackBoard.showErrorMessage(for: error)
                        }
                    }
                }
            }
        }
    }

    private func addObervers() {
        self.cometChatListBaseDelegate = self
        password.delegate = self
    }
    
    private func removeObervers() {
       
    }
 
  
    private func setupAppearance() {
        
        self.set(title: "PROTECTED_GROUP".localize(), mode: .never)
            .hide(search: true)
            .set(backButtonTitle: "CANCEL".localize())
            .show(backButton: true)
        hide(continueButton: false)
        
        self.view.backgroundColor = CometChatTheme.palatte?.secondary
        
        if let group = group, let name = group.name {
            self.set(caption: "ENTER_PASSWORD_TO_ACCESS".localize() + name + "GROUP_WITH_DOT".localize())
                .set(captionFont: CometChatTheme.typography?.Subtitle2 ?? UIFont.systemFont(ofSize: 13))
                .set(captionColor: CometChatTheme.palatte?.accent600 ?? UIColor.lightGray)
        }
    }
    
}

extension CometChatJoinGroup: UITextFieldDelegate {
    
    /**
     This method will call everytime when user enter text or delete the text from the UITextFiled,
     and this method has string parameter that gives the latest input that you have entered or deleted.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// If either password or groupname text exceeds over 100, disable the button, otherwise enable.
        let count = string.isEmpty ? textField.text!.count - 1 : textField.text!.count + string.count
        continueButton?.isEnabled = count > groupNameAndPasswordLimit ? false : true
        return true
    }
}


extension CometChatJoinGroup: CometChatListBaseDelegate{
    
    func onSearch(state: SearchState, text: String) {
        
    }
    
    func onBack() {
        switch self.isModal() {
        case true:
            self.dismiss(animated: true, completion: nil)
            self.removeObervers()
        case false:
            self.navigationController?.popViewController(animated: true)
            self.removeObervers()
        }
    }
}
