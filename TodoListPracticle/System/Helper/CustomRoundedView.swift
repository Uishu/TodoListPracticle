//
//  CustomRoundedView.swift
//  TodoListPracticle
//
//  Created by Disha on 09/02/24.
//

import UIKit


// this class is use for UIView for customise the view and set cornerradius, borderwidth, and border color on View 
@IBDesignable
class CustomRoundedView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // Other properties and methods as needed
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // This method is called at design time and can be used for additional setup
    }
}
