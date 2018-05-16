//
//  ViewDescriptionManager.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import Foundation
import UIKit

// MARK: Supporting structures

// Contains everything we need to setup an display the description
struct ViewDescription {
    let text: String
    let gesture: ViewDescriptionGestures
    let isEnabled: Bool
    
    init(description: String, gesture: ViewDescriptionGestures, isEnabled: Bool = true) {
        self.text = description
        self.gesture = gesture
        self.isEnabled = isEnabled
    }
}

/*
 Possible gestures to activate description
 Think of clean way to just use UIGestureRecognizer
 */
enum ViewDescriptionGestures {
    case doubleTap
    case longPress
}

/*
 Possible ways of customizing the description view
 */
enum ViewDescriptionPreferences {
    case font
    case fontColor
    case backGroundColor
}

// MARK: ViewDescriptionManager
/*
 A manager that holds:
    - The presentation window,
    - Preferences for the description appearance
    - All active descriptions
 */
class ViewDescriptionManager {
    // Singleton
    static let instance = ViewDescriptionManager()
    
    // Displays the descriptions in a window above all views
    private let descriptionWindow: DescriptionWindow = DescriptionWindow(frame: UIScreen.main.bounds)
    
    // Keeps track of the active descriptions and holds their configuration
    private var activeDescriptions: [UIView: ViewDescription] = [:]
    
    // Preferences
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textColor: UIColor = .black
    var backgroundColor: UIColor? = nil
    
    // Gets the description text for the given view from activeDescriptions if available. And displays the description
    fileprivate func showDescription(sender: UIView) {
        guard let description = getDescription(view: sender) else {
            // TODO: Handle error
            print("View has no description")
            return
        }

        if description.isEnabled {
            descriptionWindow.show(sender, description: description.text)
        }
    }
    
    // Adds a new description to the activeDescriptions dictionary
    fileprivate func addActiveDescription(view: UIView, description: String, gesture: ViewDescriptionGestures, isEnabled: Bool = true) {
        activeDescriptions[view] = ViewDescription(description: description, gesture: gesture)
    }
    
    // Removes the description from the given view from the active descriptions
    fileprivate func removeDescription(view: UIView) {
        activeDescriptions.removeValue(forKey: view)
    }
    
    // Returns the configutation for a given view
    fileprivate func getDescription(view: UIView) -> ViewDescription? {
        return activeDescriptions[view]
    }
    
    // Getter function to get all active descriptions and configuration
    public func getDescriptions() -> [UIView: ViewDescription] {
        return self.activeDescriptions
    }
    
    // Takes in an dictionary of preferences and sets them in the singleton
    func setPreferences(preferences: [ViewDescriptionPreferences: Any]) {
        for preference in preferences {
            switch preference.key {
            case .font:
                ViewDescriptionManager.instance.font = preference.value as! UIFont
            case .backGroundColor:
                ViewDescriptionManager.instance.backgroundColor = preference.value as? UIColor
            case .fontColor:
                ViewDescriptionManager.instance.textColor = preference.value as! UIColor
            }
        }
    }
}


// MARK: Description Window
/*
 A subclass from UIWindow that houses a DescriptionViewController as the root view controller and manages presenting and dismissing the popovers
 */
class DescriptionWindow: UIWindow {
    
    // Make sure the DescriptionViewController is setup in any init
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
    
    // Asks descriptionViewController to present description popover
    func show(_ sender: UIView, description: String) {
        guard let descriptionVC = self.rootViewController as? DescriptionViewController else {
            print("Error: Description window rootVC is not of type DescriptionViewController")
            return
        }
        
        self.isHidden = false
        descriptionVC.presentPopOver(sender, description: description)
    }
}

// MARK: DescriptionViewController
/*
 Displays the actual popover viewcontroller with the description label
 */
class DescriptionViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {
    
    var popOverVC: UIViewController?
    var window: DescriptionWindow!
    var descriptionLabel: UILabel?
    
    // Getters to facilitate accessing the preferences
    var font: UIFont {
        return ViewDescriptionManager.instance.font
    }
    var textColor: UIColor {
        return ViewDescriptionManager.instance.textColor
    }
    var backgroundColor: UIColor? {
        return ViewDescriptionManager.instance.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        // Setup dismiss gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    // Handles dismiss tap
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.popOverVC?.dismiss(animated: true, completion: {
            self.popOverVC = nil
            self.descriptionLabel = nil
            self.window.isHidden = true
        })
    }
    
    // Sets up the popOverVC and displays it
    func presentPopOver(_ sender: UIView, description: String) {
        // Check if there is another popover presenting
        if popOverVC == nil {
            // Setup popover view
            popOverVC = UIViewController()
            popOverVC?.modalPresentationStyle = .popover
            
            // Setup description label
            descriptionLabel = UILabel()
            descriptionLabel?.backgroundColor = .clear
            descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel?.numberOfLines = 0
            descriptionLabel?.font = self.font
            descriptionLabel?.textColor = self.textColor
            descriptionLabel?.text = description
            
            // Add and constrain description label
            popOverVC?.view.addSubview(descriptionLabel!)
            popOverVC?.view.addConstraints([
                descriptionLabel!.topAnchor.constraint(equalTo: popOverVC!.view.topAnchor, constant: 0),
                descriptionLabel!.leftAnchor.constraint(equalTo: popOverVC!.view.leftAnchor, constant: 10),
                descriptionLabel!.rightAnchor.constraint(equalTo: popOverVC!.view.rightAnchor, constant: -10),
                descriptionLabel!.bottomAnchor.constraint(equalTo: popOverVC!.view.bottomAnchor, constant: 0)])
            
            // Calculate size based on description text size
            popOverVC?.preferredContentSize =
                CGSize(width: descriptionLabel!.intrinsicContentSize.width >
                    self.window.frame.width * 0.75 ?
                        self.window.frame.width * 0.75 :
                    descriptionLabel!.intrinsicContentSize.width + 20,
                       height: description.height(withConstrainedWidth: self.window.frame.width * 0.75,
                                                  font: self.font) + 20)
            
            // Setup PopoverPresentationController
            let ppc = popOverVC?.popoverPresentationController
            ppc?.backgroundColor = self.backgroundColor
            ppc?.permittedArrowDirections = .any
            ppc?.delegate = self
            ppc?.sourceRect = sender.bounds
            ppc?.sourceView = sender
            
            // Present Popover
            present(popOverVC!, animated: true, completion: nil)
        }
    }
    
    // This function allows us to display the popover the same on the iPhone and the iPad
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// Used to calculate the height of the text constrained by a given width
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

// MARK: UIView+Extension
/*
 This extension is what the developer should interact with.
 */
extension UIView {
    func addDescription(description: String,
                        gesture: ViewDescriptionGestures = .longPress,
                        isEnabled: Bool = true,
                        preferences: [ViewDescriptionPreferences: Any]? = nil) {
        ViewDescriptionManager.instance.addActiveDescription(view: self, description: description, gesture: gesture, isEnabled: isEnabled)
        
        if let preferences = preferences {
            ViewDescriptionManager.instance.setPreferences(preferences: preferences)
        }
        
        self.isUserInteractionEnabled = true
        
        switch gesture {
        case .longPress:
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(showDescription))
            longGesture.name = "DescriptionGesture"
            self.addGestureRecognizer(longGesture)
        case .doubleTap:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDescription))
            tapGesture.name = "DescriptionGesture"
            tapGesture.numberOfTapsRequired = 2
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc fileprivate func showDescription() {
        ViewDescriptionManager.instance.showDescription(sender: self)
    }
    
    func removeDescription(isUserInteractive: Bool = true) {
        // Remove description from manager
        ViewDescriptionManager.instance.removeDescription(view: self)
        // Check all gestures on view and remove the DescriptionGesture
        if let gestures = self.gestureRecognizers {
            for (index, gesture) in gestures.enumerated() {
                if gesture.name == "DescriptionGesture" {
                    self.gestureRecognizers?.remove(at: index)
                    self.isUserInteractionEnabled = isUserInteractive
                }
            }
        }
    }
}
