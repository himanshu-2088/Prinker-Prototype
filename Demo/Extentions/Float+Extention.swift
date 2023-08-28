//
//  Float+Extention.swift
//  Demo
//
//  Created by Roro Solutions LLP on 14/08/23.
//  Copyright © 2023 ModiFace Inc. All rights reserved.
//

import Foundation

extension Float {
    func metersToInches() -> String {
        return String(format: "%.2f", self * 39.3701)
    }
    
    func metersToCentimeters() -> String {
        return String(format: "%.2f", self / 10)
    }
}

