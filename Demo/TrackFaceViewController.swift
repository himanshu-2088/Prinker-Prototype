//
//  TrackFaceViewController.swift
//  Demo
//
//  Created by Roro Solutions LLP on 14/08/23.
//  Copyright © 2023 ModiFace Inc. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class TrackFaceViewController: UIViewController {
    @IBOutlet weak var leftEyebrowLenghtLabel: UILabel!
    @IBOutlet weak var rightEyebrowLengthLabel: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    
    var faceGeometry: ARSCNFaceGeometry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension TrackFaceViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        self.faceGeometry = faceGeometry
        faceGeometry?.firstMaterial?.transparency = 0
        let node = SCNNode(geometry: faceGeometry)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry,
              let sceneView = renderer as? ARSCNView
        else {
            return
        }
        
        let points: [ARFaceAnchor.VerticesAndProjection] = faceAnchor.convertVectorsToCGPoints(to: sceneView)
        
        DispatchQueue.main.async {
            
            let leftEyebrowDistance1 = VectorHelper.distance(betweenPoints: SCNVector3(points.map{ $0.vertex }[0]), point2: SCNVector3(points.map{ $0.vertex }[1]))

            let leftEyebrowDistance2 = VectorHelper.distance(betweenPoints: SCNVector3(points.map{ $0.vertex }[1]), point2: SCNVector3(points.map{ $0.vertex }[2]))

            let leftEyebrowTotalDistance = (leftEyebrowDistance1 + leftEyebrowDistance2).metersToCentimeters()

            let rightEyebrowDistance1 = Float(VectorHelper.distance(betweenPoints: SCNVector3(points.map{ $0.vertex }[3]), point2: SCNVector3(points.map{ $0.vertex }[4])))
            
            let rightEyebrowDistance2 = Float(VectorHelper.distance(betweenPoints: SCNVector3(points.map{ $0.vertex }[4]), point2: SCNVector3(points.map{ $0.vertex }[5])))
            
            let rightEyebrowTotalDistance = (rightEyebrowDistance1 + rightEyebrowDistance2).metersToCentimeters()
            
            self.leftEyebrowLenghtLabel.text = leftEyebrowTotalDistance + "cm"
            self.rightEyebrowLengthLabel.text = rightEyebrowTotalDistance + "cm"
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
