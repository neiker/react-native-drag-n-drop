//
//  RNDropTargetView.swift
//  RNDragNDrop
//
//  Created by Javier Alvarez on 19/07/2017.
//  Copyright © 2017 Javier Alvarez. All rights reserved.
//

import MobileCoreServices

let uttypeToExtensionMap = [
    kUTTypeJPEG as String: "jpg",
    kUTTypePNG as String: "png",
    kUTTypeGIF as String: "gif",
    kUTTypePDF as String: "pdf",
    kUTTypeQuickTimeMovie as String: "mov",
]

func getFileExtension(for itemProvider: NSItemProvider, default defaultValue: String?) -> String {
    if (defaultValue != nil && !defaultValue!.isEmpty) {
        return defaultValue!;
    }
    
    return uttypeToExtensionMap[itemProvider.registeredTypeIdentifiers[0]] ?? ""
}

@objc(RNDropTargetView)
class RNDropTargetView: UIView, UIDropInteractionDelegate {
    private var _imageTypes = [
        kUTTypeJPEG as String,
        kUTTypePNG as String,
        kUTTypeGIF as String,
        ];
    private var _textTypes = [
        kUTTypeUTF8PlainText as String,
        ];
    private var _urlTypes = [
        kUTTypeURL as String
    ];
    private var _fileTypes = [
        kUTTypePDF as String,
        kUTTypeQuickTimeMovie as String
    ]
    
    private var _onSessionDidEnter: RCTDirectEventBlock?;
    private var _onSessionDidUpdate: RCTDirectEventBlock?;
    private var _onSessionDidExit: RCTDirectEventBlock?;
    private var _onSessionDidEnd: RCTDirectEventBlock?;
    
    private var _onWillDrop: RCTDirectEventBlock?;
    private var _onDrop: RCTDirectEventBlock?;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 11, *) {
            self.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Setters for React Native
     */
    
    @objc(setOnSessionDidEnter:)
    func setOnSessionDidEnter(onSessionDidEnter: RCTDirectEventBlock?) {
        self._onSessionDidEnter = onSessionDidEnter
    }
    
    @objc(setOnSessionDidUpdate:)
    func setOnSessionDidUpdate(onSessionDidUpdate: RCTDirectEventBlock?) {
        self._onSessionDidUpdate = onSessionDidUpdate
    }
    
    @objc(setOnSessionDidExit:)
    func setOnSessionDidExit(onSessionDidExit: RCTDirectEventBlock?) {
        self._onSessionDidExit = onSessionDidExit
    }
    
    @objc(setOnWillDrop:)
    func setOnWillDrop(onWillDrop: RCTDirectEventBlock?) {
        self._onWillDrop = onWillDrop
    }
    
    @objc(setOnDrop:)
    func setOnDrop(onDrop: RCTDirectEventBlock?) {
        self._onDrop = onDrop
    }
    
    /**
     Interactions
     */
    
    /**
     canHandle
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if (session.localDragSession != nil) {
            return false;
        } else {
            return (
                session.hasItemsConforming(toTypeIdentifiers: self._imageTypes) ||
                    session.hasItemsConforming(toTypeIdentifiers: self._textTypes) ||
                    session.hasItemsConforming(toTypeIdentifiers: self._urlTypes) ||
                    session.hasItemsConforming(toTypeIdentifiers: self._fileTypes)
            )
        }
    }
    
    /**
     sessionDidEnter
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        let dropPoint = session.location(in: interaction.view!)
        
        self._onSessionDidEnter?(["point":[ "x": dropPoint.x, "y": dropPoint.y]])
    }
    
    /**
     sessionDidUpdate
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropPoint = session.location(in: interaction.view!)
        
        self._onSessionDidUpdate?(["point":[ "x": dropPoint.x, "y": dropPoint.y]])
        
        return UIDropProposal(operation: .copy)
    }
    
    /**
     sessionDidExit
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        self._onSessionDidExit?([:])
    }
    
    /**
     sessionDidEnd
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        self._onSessionDidEnd?([:])
    }
    
    /**
     performDrop
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let dropPoint = session.location(in: interaction.view!)
        
        self._onWillDrop?(["point":[ "x": dropPoint.x, "y": dropPoint.y]])
        
        if(session.hasItemsConforming(toTypeIdentifiers: self._imageTypes)) {
            // If we only use the last case, images from browser will be handle as URL
            self.loadAsFiles(session, dropPoint, kUTTypeItem)
        } else if(session.hasItemsConforming(toTypeIdentifiers: self._textTypes)) {
            self.loadAsString(session, dropPoint)
        }else if(session.hasItemsConforming(toTypeIdentifiers: self._urlTypes)) {
            self.loadAsURL(session, dropPoint)
        } else if(session.hasItemsConforming(toTypeIdentifiers: [kUTTypeItem as String])) {
            self.loadAsFiles(session, dropPoint, kUTTypeItem)
        }
    }
    
    /**
     previewForDropping
     */
    
    @available(iOS 11, *)
    func dropInteraction(_ interaction: UIDropInteraction, previewForDropping item: UIDragItem, withDefault defaultPreview: UITargetedDragPreview) -> UITargetedDragPreview? {
        // we return nil so the preview shrinks down and fades out at the current location.
        return nil
    }
    
    /**
     Methods
     */
    
    @available(iOS 11, *)
    func loadAsFiles(_ session: UIDropSession, _ dropPoint: CGPoint, _ uttype: CFString) {
        if (!session.hasItemsConforming(toTypeIdentifiers: [uttype as String])) {
            return;
        }
        
        // Create temporary directory
        let tmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(String(format:"%f", Date().timeIntervalSince1970))
        do {
            try FileManager.default.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
            
            var filesData: [[String: Any]] = []
            var filesProcessed = 0
            
            // Iterate over session items
            for item in session.items {
                // Load item as File
                item.itemProvider.loadFileRepresentation(forTypeIdentifier: uttype as String) { (url, error) in
                    if (error == nil && url != nil) {
                        let realFileName = url!.pathComponents.last;
                        let itemExtension = getFileExtension(for: item.itemProvider, default: url?.pathExtension)
                        
                        let newUrl = tmpDirURL
                            .appendingPathComponent(realFileName!)
                            .appendingPathExtension(itemExtension)
                        
                        // Move file so it's not removed after this function finish
                        do {
                            try FileManager.default.moveItem(at: url!, to: newUrl)
                            
                            var fileData: [String: Any] = [
                                "path": newUrl.path,
                                "uttypes": item.itemProvider.registeredTypeIdentifiers,
                                "isImage": false
                            ];
                            
                            // Try to load file as UIImage to get image size
                            if let image = UIImage(contentsOfFile: newUrl.path) {
                                fileData["size"] = [ "width": image.size.width, "height": image.size.height ]
                                fileData["isImage"] = true
                            }
                            
                            filesData.append(fileData);
                        } catch let error as NSError {
                            print("==## Unable to create file \(error.debugDescription)")
                        }
                    } else {
                        print("==## Unable to create tmp file \(error.debugDescription)")
                    }
                    
                    filesProcessed = filesProcessed + 1
                    
                    if (filesProcessed == session.items.count) {
                        self._onDrop?([
                            "files": filesData,
                            "dropPoint": [ "x": dropPoint.x, "y": dropPoint.y ],
                            ])
                    }
                }
            }
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
        }
        
    }
    
    
    @available(iOS 11, *)
    func loadAsString(_ session: UIDropSession, _ dropPoint: CGPoint) {
        session.loadObjects(ofClass: NSString.self) { (itemProviderReadings: [NSItemProviderReading]) in
            for itemProviderReading in itemProviderReadings {
                if let string: NSString = itemProviderReading as? NSString {
                    self._onDrop!([
                        "text": string as Any,
                        "dropPoint": [ "x" : dropPoint.x , "y" : dropPoint.y ]
                        ]);
                } else {
                    print("Unable to read itemProviderReading as String")
                }
            }
            
        }
    }
    
    @available(iOS 11, *)
    func loadAsURL(_ session: UIDropSession, _ dropPoint: CGPoint) {
        session.loadObjects(ofClass: NSURL.self) { (itemProviderReadings: [NSItemProviderReading]) in
            for itemProviderReading in itemProviderReadings {
                if let url: NSURL = itemProviderReading as? NSURL {
                    self._onDrop!([
                        "url": url.absoluteString as Any,
                        "dropPoint": [ "x" : dropPoint.x , "y" : dropPoint.y ]
                        ]);
                } else {
                    print("Unable to read itemProviderReading as NSURL")
                }
            }
            
        }
    }
}


