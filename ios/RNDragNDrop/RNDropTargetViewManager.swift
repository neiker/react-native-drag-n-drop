//
//  RNDropTargetViewManager.swift
//  RNDragNDrop
//
//  Created by Javier Alvarez on 19/07/2017.
//  Copyright © 2017 Javier Alvarez. All rights reserved.
//

import UIKit

@objc(RNDropTargetViewManager)
class RNDropTargetViewManager : RCTViewManager {
    override func view() -> UIView! {
        return RNDropTargetView();
    }
}

