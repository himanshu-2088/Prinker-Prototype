//
//  Copyright © 2019 ModiFace Inc. All rights reserved.
//

import UIKit
import MFEMakeupKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftEyebrowLenghtLabel: UILabel!
    @IBOutlet weak var rightEyebrowLengthLabel: UILabel!
    
    @IBOutlet private var makeupView: MFEMakeupView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupRenderer {
        }
    }
    
    private func setupRenderer(_ completion: @escaping () -> Void) {
        // Set server region, this only needs to be set once even with multiple renders.
        MFEMakeupRenderer.setServerRegion(.US)
        
        // Connect the renderer to the makeup view
        MFEMakeupRenderer.shared().makeupView = makeupView
        
        MFEMakeupRenderer.shared().shouldOutputBrowMasks = true
        
        let renderListener = ExampleRenderListener()
        renderListener.leftEyebrowLengthLabel = leftEyebrowLenghtLabel
        renderListener.rightEyebrowLengthLabel = rightEyebrowLengthLabel
        MFEMakeupRenderer.shared().add(renderListener)
        
        // Load the required renderer resources
        MFEMakeupRenderer.shared().loadResources(completionHandler: {
            
            DispatchQueue.global().async {
                MFEMakeupRenderer.shared().startRunningWithCamera(with: .front, andPreset: AVCaptureSession.Preset.high.rawValue)
            }
            
            MFEMakeupRenderer.shared().shouldDrawFacePoints = false

            completion()
         })
    }
}
