//
//  RNDragNDropTargetManager.swift
//  RNDragNDrop
//
//  Created by Javier Alvarez on 19/07/17.
//

import UIKit

@objc(RNDragNDropTargetManager)
class RNDragNDropTargetManager : RCTViewManager {
    override func view() -> UIView! {
        return RNDragNDropTargetView();
    }
}
