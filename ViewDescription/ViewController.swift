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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var swi: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func popOverAction(_ sender: Any) {
        print("Button pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.addDescription(description: "hello there", gesture: .doubleTap, isEnabled: true, preferences: [.backGroundColor: UIColor.red, .fontColor: UIColor.yellow])
        blueView.addDescription(description: Descriptions.Views.blueView)
        button.addDescription(description: Descriptions.Buttons.informationButton)
        textField.addDescription(description: "This is a text field")
        imageView.addDescription(description: "This is an imageview")
        swi.addDescription(description: "this is a switch")
        segmentedControl.addDescription(description: "This is a segmented control that has a very long description so we can test other dimensions lets see how far we can go is am just typing at this point and have no idea what to say except for the fact that I dont know", gesture: .doubleTap)
        
        textView.addDescription(description: "This is a textView", gesture: .doubleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

