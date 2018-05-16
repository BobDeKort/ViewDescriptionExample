//
//  Descriptions.swift
//  ViewDescription
//
//  Created by Bob De Kort on 5/15/18.
//  Copyright © 2018 Bob De Kort. All rights reserved.
//

import Foundation

/*
 Example on how to facilitate using description
 other examples might be:                           good/bad
    - json file                                         -
    - constants file with individual Strings            +
    - Enums e.g. LabelDescriptions, ButtonDescriptions  +/-
 */
struct Descriptions {
    struct Labels {
        static let UserName = "This will display the currently logged in username"
    }
    
    struct Buttons {
        static let defaultButton = "This button performs an action"
        static let informationButton = "Here you can find the terms of service, privacy policy and legal documentation"
    }
    
    struct Views {
        static let defaultView = "This will display stuff"
        static let blueView = "This view is just blue"
    }
}
