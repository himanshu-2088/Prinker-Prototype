//
//  VectorHelper.swift
//  Demo
//
//  Created by Roro Solutions LLP on 14/08/23.
//  Copyright © 2023 ModiFace Inc. All rights reserved.
//

import SceneKit

struct VectorHelper {
    static func distance(betweenPoints point1: SCNVector3, point2: SCNVector3) -> Float {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let dz = point2.z - point1.z
        return Float(CGFloat(sqrt(dx*dx + dy*dy + dz*dz)))
    }
}
