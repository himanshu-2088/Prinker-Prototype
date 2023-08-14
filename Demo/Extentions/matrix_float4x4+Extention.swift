//
//  matrix_float4x4+Extention.swift
//  Demo
//
//  Created by Roro Solutions LLP on 14/08/23.
//  Copyright © 2023 ModiFace Inc. All rights reserved.
//

import SceneKit

extension matrix_float4x4 {
    public var position: SCNVector3 {
        get{
            return SCNVector3(self[3][0], self[3][1], self[3][2])
        }
    }
}
