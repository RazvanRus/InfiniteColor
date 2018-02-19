//
//  IphoneTypeService.swift
//  InfiniteColor
//
//  Created by Rus Razvan on 29/01/2018.
//  Copyright © 2018 Rus Razvan. All rights reserved.
//

import UIKit

class IphoneTypeService {
    private init() {}
    static var shared = IphoneTypeService()
    
    func isIphoneX() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                return true
            }
        }
        return false
    }
    
    func isTablet() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad { return true }
        return false
    }
    
    var iPhoneXColorTemplateWidth = 0
    var iPhoneXColorTemplateDistanceBetween = 0
    var iPhoneXColorTemplateStartingXPosition = 0.0
}
