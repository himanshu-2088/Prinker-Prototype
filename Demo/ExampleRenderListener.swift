//
//  Copyright © 2019 ModiFace Inc. All rights reserved.
//

import UIKit
import MFEMakeupKit
import OpenGLES

class ExampleRenderListener: NSObject, MFEMakeupRendererUpdateListener {
    public var leftEyebrowLengthLabel: UILabel?
    public var rightEyebrowLengthLabel: UILabel?
    
    // MARK: - MFEMakeupRendererUpdateListener
    
    func makeupRendererDidInitialize(with context: EAGLContext) {
      
    }
    
    func makeupRendererDidDrawOntoTarget(_ target: MFEMakeupRenderingTarget, with renderingData: MFEMakeupRenderingData) {
        // Ensure UI updates happen on main thread
        DispatchQueue.main.async {
            self.leftEyebrowLengthLabel?.text = "\((renderingData.leftBrowWidth / 10).rounded(toPlaces: 2)) cm"
            self.rightEyebrowLengthLabel?.text = "\((renderingData.rightBrowWidth / 10).rounded(toPlaces: 2)) cm"
            
            print("Left brow length = \(renderingData.leftBrowWidth)     Right brow length = \(renderingData.rightBrowWidth)")
        }
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

