//
//  RNDropTargetViewModule.m
//  RNDragNDrop
//
//  Created by Javier Alvarez on 19/07/2017.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import "RNDragNDrop-Swift.h"

@interface RCT_EXTERN_MODULE(RNDropTargetViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onSessionDidEnter, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionDidUpdate, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionDidExit, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSessionDidEnd, RCTDirectEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onWillDrop, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDrop, RCTDirectEventBlock)

@end 
