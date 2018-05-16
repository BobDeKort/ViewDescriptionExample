//
//  ViewDescriptionManager.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import Foundation
import UIKit

// Will be used for error handling later
enum DescriptionWindowError: Error {
    case invalidRootVC
}

// MARK: ViewDescriptionManager
/*
 Handles the descriptionwindow that presents all the descriptions,
 And will handle the storage of active descriptions and their content.
 */
class ViewDescriptionManager {
    static let instance = ViewDescriptionManager()
    
    let descriptionWindow: DescriptionWindow = DescriptionWindow(frame: UIScreen.main.bounds)
    
    var activeDescriptions: [UIView: String] = [:]
    
    // TODO: check if functions are fileprivate or public
    
    
    func showDescription(sender: UIView) {
        guard let description = getDescription(view: sender) else {
            // TODO: Handle error
            print("View has no description")
            return
        }
        descriptionWindow.show(sender, description: description)
    }
    
    func addActiveDescription(view: UIView, description: String) {
        activeDescriptions[view] = description
    }
    
    func removeDescription(view: UIView) {
        activeDescriptions.removeValue(forKey: view)
    }
    
    func getDescription(view: UIView) -> String? {
        return activeDescriptions[view]
    }
}


// MARK: Description Window
/*
 A subclass from UIWindow that houses a DescriptionViewController as the root view controller and manages presenting and dismissing the popovers
 */
class DescriptionWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDescriptionViewControllerAsRoot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDescriptionViewControllerAsRoot()
    }
    
    private func setDescriptionViewControllerAsRoot() {
        let descriptionVC = DescriptionViewController()
        descriptionVC.window = self
        self.rootViewController = descriptionVC
        self.windowLevel = UIWindowLevelAlert + 1
    }
    
    func show(_ sender: UIView, description: String) {
        guard let descriptionVC = self.rootViewController as? DescriptionViewController else {
            print("Error: Description window rootVC is not of type DescriptionViewController")
            return
        }
        
        self.isHidden = false
        descriptionVC.presentPopOver(sender, description: description)
    }
}

extension UIView {
    
    func addDescription(description: String) {
        ViewDescriptionManager.instance.addActiveDescription(view: self, description: description)
        
        self.isUserInteractionEnabled = true
        let longgesture = UILongPressGestureRecognizer(target: self, action: #selector(showDescription))
        longgesture.name = "DescriptionGesture"
        self.addGestureRecognizer(longgesture)
    }
    
    @objc fileprivate func showDescription() {
        ViewDescriptionManager.instance.showDescription(sender: self)
    }
    
    func removeDescription() {
        // Remove description from manager
        ViewDescriptionManager.instance.removeDescription(view: self)
        // Check all gestures on view and remove the DescriptionGesture
        if let gestures = self.gestureRecognizers {
            for (index, gesture) in gestures.enumerated() {
                if gesture.name == "DescriptionGesture" {
                    self.gestureRecognizers?.remove(at: index)
                }
            }
        }
    }
}
