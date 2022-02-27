//
//  Constants.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import SwiftUI

struct Constants {
    static var containerName = "NasaDaily"
    static var appName = "NasaDaily"
    static var appDescription = ""
}

extension CGFloat {
    static var deviceHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    static var deviceWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}
