//
//  DescriptionView.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import UIKit

class DescriptionView: UIView {

    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("DescriptionView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
