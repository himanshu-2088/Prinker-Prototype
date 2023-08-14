//
//  Copyright © 2019 ModiFace Inc. All rights reserved.
//

import UIKit
import MFEMakeupKit
import OpenGLES

class ExampleRenderListener: NSObject, MFEMakeupRendererUpdateListener {
    public var outputLabel: UILabel?
    
    // MARK: - MFEMakeupRendererUpdateListener
    
    func makeupRendererDidInitialize(with context: EAGLContext) {
      
    }
    
    func makeupRendererDidDrawOntoTarget(_ target: MFEMakeupRenderingTarget, with renderingData: MFEMakeupRenderingData) {
        // Ensure UI updates happen on main thread
        DispatchQueue.main.async {
            self.outputLabel?.text = "Left brow length = \(renderingData.leftBrowWidth)\nRight brow length = \(renderingData.rightBrowWidth)"
            print("Left brow length = \(renderingData.leftBrowWidth)     Right brow length = \(renderingData.rightBrowWidth)")
        }
    }
}
