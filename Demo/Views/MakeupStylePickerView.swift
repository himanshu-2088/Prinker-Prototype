//
//  Copyright © 2019 ModiFace Inc. All rights reserved.
//

import UIKit

protocol MakeupStylePickerViewDelegate: class {
    func makeupStylePicker(view: MakeupStylePickerView, didSelectItemAtIndex index: Int?)
}

class MakeupStylePickerView: UIView {

    weak var delegate: MakeupStylePickerViewDelegate?
    
    var numberOfStyles: UInt = 0 {
        didSet {
            dotViews.forEach { view in
                view.removeFromSuperview()
            }
            
            dotViews.removeAll()
            
            for index in 0 ..< numberOfStyles {
                let dotView = MakeupStyleDotView()
                
                if let selectedIndex = selectedIndex, index == selectedIndex {
                    dotView.isSelected = true
                }
                
                dotView.buttonView.tag = Int(index)
                dotView.buttonView.addTarget(self, action: #selector(MakeupStylePickerView.buttonTapped(_:)), for: .touchUpInside)
                
                dotViews.append(dotView)
                addSubview(dotView)
            }
            
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    var selectedIndex: Int? {
        set {
            setSelectedIndex(newValue, withHaptics: false)
        }
        
        get {
            return _selectedIndex
        }
    }
    
    private var _selectedIndex: Int? = 0
    
    private static let kPickerBoxSizeCompact: CGFloat = 22
    private static let kPickerBoxSizeRegular: CGFloat = 33
    
    private static let kPickerVerticalPaddingCompact: CGFloat = 2
    private static let kPickerVerticalPaddingRegular: CGFloat = 3
    
    private static let kPickerCircleDeselectedRadiusCompact: CGFloat = 2
    private static let kPickerCircleDeselectedRadiusRegular: CGFloat = 3
    
    private static let kPickerCircleSelectedRadiusCompact: CGFloat = 3
    private static let kPickerCircleSelectedRadiusRegular: CGFloat = 4.5
    
    private static let kPickerShadowOpacity: Float = 0.3
    private static let kPickerShadowRadius: CGFloat = 5
    
    private class MakeupStyleDotView: UIView {
        let circleView = UIView()
        let buttonView = UIButton(type: .custom)
        var isSelected = false {
            didSet {
                setNeedsLayout()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            circleView.backgroundColor = UIColor.white
            circleView.layer.shadowColor = UIColor.black.cgColor
            circleView.layer.shadowOffset = CGSize.zero
            circleView.layer.shadowRadius = kPickerShadowRadius
            circleView.layer.shadowOpacity = kPickerShadowOpacity
            addSubview(circleView)
            
            addSubview(buttonView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let kPickerCircleSelectedRadius = isRegularSizeClass() ? kPickerCircleSelectedRadiusRegular : kPickerCircleSelectedRadiusCompact
            let kPickerCircleDeselectedRadius = isRegularSizeClass() ? kPickerCircleDeselectedRadiusRegular : kPickerCircleDeselectedRadiusCompact
            
            let radius = isSelected ? kPickerCircleSelectedRadius : kPickerCircleDeselectedRadius
            
            buttonView.frame = bounds
            circleView.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            circleView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            circleView.layer.cornerRadius = radius
            circleView.alpha = isSelected ? 1.0 : 0.5
        }
        
        private func isRegularSizeClass() -> Bool {
            let horizontalClass = traitCollection.horizontalSizeClass
            let verticalClass = traitCollection.verticalSizeClass
            
            return (horizontalClass == .regular) && (verticalClass == .regular)
        }
    }
    
    private var dotViews = [MakeupStyleDotView]()
    private var selectionFeedbackGenerator: Any?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let kPickerBoxSize = isRegularSizeClass() ? MakeupStylePickerView.kPickerBoxSizeRegular : MakeupStylePickerView.kPickerBoxSizeCompact
        let kPickerVerticalPadding = isRegularSizeClass() ? MakeupStylePickerView.kPickerVerticalPaddingRegular : MakeupStylePickerView.kPickerVerticalPaddingCompact
        
        for (index, dotView) in dotViews.enumerated() {
            dotView.frame = CGRect(x: 0, y: CGFloat(index) * (kPickerBoxSize + kPickerVerticalPadding), width: kPickerBoxSize, height: kPickerBoxSize)
            dotView.setNeedsLayout()
        }
    }
    
    private func setup() {
        if #available(iOS 10.0, *) {
            selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        }
        
        numberOfStyles = 4
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        setSelectedIndex(button.tag, withHaptics: true)

        delegate?.makeupStylePicker(view: self, didSelectItemAtIndex: selectedIndex)
    }
    
    func setSelectedIndex(_ index: Int?, withHaptics: Bool = false) {
        let oldIndex = _selectedIndex
        let newIndex = index
        
        _selectedIndex = newIndex
        
        dotViews.forEach { dotView in
            dotView.isSelected = false
        }
        
        if let index = index, index >= 0, index < dotViews.count {
            dotViews[index].isSelected = true
        }
        
        if (withHaptics && oldIndex != newIndex) {
            if #available(iOS 10.0, *) {
                if let generator = selectionFeedbackGenerator as? UISelectionFeedbackGenerator {
                    generator.selectionChanged()
                }
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let kPickerBoxSize = isRegularSizeClass() ? MakeupStylePickerView.kPickerBoxSizeRegular : MakeupStylePickerView.kPickerBoxSizeCompact
            let kPickerVerticalPadding = isRegularSizeClass() ? MakeupStylePickerView.kPickerVerticalPaddingRegular : MakeupStylePickerView.kPickerVerticalPaddingCompact
            
            return CGSize(width: kPickerBoxSize, height: CGFloat(numberOfStyles) * kPickerBoxSize + CGFloat(numberOfStyles - 1) * kPickerVerticalPadding)
        }
    }
    
    private func isRegularSizeClass() -> Bool {
        let horizontalClass = traitCollection.horizontalSizeClass
        let verticalClass = traitCollection.verticalSizeClass
        
        return (horizontalClass == .regular) && (verticalClass == .regular)
    }
}
