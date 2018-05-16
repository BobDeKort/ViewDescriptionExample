//
//  ViewController.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var blueView: UIView!
    
    @IBAction func popOverAction(_ sender: Any) {
        
//        ViewDescriptionManager.instance.addActiveDescription(view: label, description: "This label will show the currently logged in user")
//        ViewDescriptionManager.instance.addActiveDescription(view: blueView, description: "This is a big blue view")
//        ViewDescriptionManager.instance.addActiveDescription(view: button, description: "This is the button to rule the all")
//
//
//        ViewDescriptionManager.instance.showDescription(sender: button)
        
        
//        ViewDescriptionManager.instance.showDescription(sender: blueView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.addDescription(description: "This label will show all the amazing things you can do here")
        blueView.addDescription(description: "This is a big blue view")
        button.addDescription(description: "This is one button to rule them all")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

