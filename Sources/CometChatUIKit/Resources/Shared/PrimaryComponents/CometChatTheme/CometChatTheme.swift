//
//  CometChatThemeNew.swift
//  CometChatUIKit
//
//  Created by Pushpsen Airekar on 15/03/22.
//

import Foundation
import UIKit


final class CometChatTheme {
    
    static var typography: Typography?
    static var palatte: Palette?
    
    
    init() {}
    

    @discardableResult
    init(typography: Typography, palatte: Palette) {
        CometChatTheme.typography = typography
        CometChatTheme.palatte = palatte
    }

    static func defaultAppearance() {
        CometChatTheme.init(typography: Typography(), palatte: Palette())
    }
    
}
