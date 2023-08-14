//  
//  Copyright © 2020 ModiFace Inc. All rights reserved.
//

import UIKit

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
