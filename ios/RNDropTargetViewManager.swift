//
//  RNDropTargetViewManager.swift
//  RNDragNDrop
//
//  Created by Javier Alvarez on 19/07/2017.
//

import UIKit

@objc public class RNDropTargetViewManager : RCTViewManager {
    override func view() -> UIView! {
        return RNDropTargetView();
    }
}
