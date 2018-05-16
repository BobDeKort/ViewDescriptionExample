//
//  DescriptionViewController.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import Foundation
import UIKit

class DescriptionViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {
    
    var popOverVC: UIViewController?
    var window: DescriptionWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.popOverVC?.dismiss(animated: true, completion: {
            // TODO: Notify manager
            self.popOverVC = nil
            self.window.isHidden = true
            print("Dismissed")
        })
    }
    
    func presentPopOver(_ sender: UIView, description: String) {
        if popOverVC == nil {
            popOverVC = UIViewController()
            popOverVC!.view.backgroundColor = UIColor.blue
            popOverVC!.modalPresentationStyle = .popover
            popOverVC!.preferredContentSize = CGSize(width: 200, height: 200)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            popOverVC!.view.addSubview(label)
            popOverVC!.view.addConstraints([
                label.topAnchor.constraint(equalTo: popOverVC!.view.topAnchor),
                label.leftAnchor.constraint(equalTo: popOverVC!.view.leftAnchor),
                label.rightAnchor.constraint(equalTo: popOverVC!.view.rightAnchor),
                label.bottomAnchor.constraint(equalTo: popOverVC!.view.bottomAnchor)])
            
            label.text = description
            let ppc = popOverVC!.popoverPresentationController
            ppc?.permittedArrowDirections = .any
            ppc?.delegate = self
            ppc?.sourceRect = sender.bounds
            ppc?.sourceView = sender
        
            present(popOverVC!, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


