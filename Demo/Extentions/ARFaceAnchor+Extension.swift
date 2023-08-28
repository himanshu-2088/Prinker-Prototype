//
//  ARFaceAnchor+Extension.swift
//  Demo
//
//  Created by Roro Solutions LLP on 14/08/23.
//  Copyright © 2023 ModiFace Inc. All rights reserved.
//

import ARKit
import SceneKit

extension ARFaceAnchor {
    
    struct VerticesAndProjection {
        var vertex: SCNVector3
        var projected: CGPoint
    }
    
    func convertVectorsToCGPoints(to view: ARSCNView) -> [VerticesAndProjection] {
        //        let verticesArray = [227, 210, 348, 850, 657, 649, 437, 732]
        //        let facePointsArray = [200, 230, 420, 850, 650, 767, 372, 793]
        let facePointsArray = [200, 210, 420, 850, 648, 767, 372, 803]
        
        var verticesArray = [VerticesAndProjection]()
        for x in facePointsArray {
            let vertex = geometry.vertices[x]
            let col = SIMD4<Float>(SCNVector4())
            let pos = SIMD4<Float>(SCNVector4(vertex.x, vertex.y, vertex.z, 1))
            let pworld = transform * simd_float4x4(col, col, col, pos)
            let vect = view.projectPoint(SCNVector3(pworld.position.x, pworld.position.y, pworld.position.z))
            let p = CGPoint(x: CGFloat(vect.x), y: CGFloat(vect.y))
            verticesArray.append(VerticesAndProjection(vertex: vect, projected: p))
        }
        return verticesArray
    }
}

