//
//  RoundedButton.swift
//  TodoListPracticle
//
//  Created by Disha on 09/02/24.
//

import UIKit

// this class is use for UIButton for customise the Button and set cornerradius, borderwidth, and border color on Button
@IBDesignable
class RoundedButton: UIButton {

    // MARK: - Inspectable Properties

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
