//
//  Global.swift
//  Master
//
//  Created by Dalton Ng on 28/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit

// Global Variables

// Global Functions




public func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}

public func homeButtonPresent() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            print("iPhone 5 or 5S or 5C")
            return true
        case 1334:
            print("iPhone 6/6S/7/8")
            return true
        case 1920, 2208:
            print("iPhone 6+/6S+/7+/8+")
            return true
        case 2436:
            print("iPhone X, Xs")
            return false
        case 2688:
            print("iPhone Xs Max")
            return false
        case 1792:
            print("iPhone Xr")
            return false
        default:
            print("unknown")
            return false
        }
    } else {
        return false
    }
}





// Extensions

extension UIView {
    func setGradient(_ index: Int = 0) {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = getGradientDarkText(index)
    }
}


extension UITextView {
    func setBottomWhiteBorder() {
        self.layer.backgroundColor = newSetCardBackgroundColour.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func setBottomBorderColour(_ colour: UIColor) {
        self.layer.backgroundColor = newSetCardBackgroundColour.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = colour.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func resetBottomBorder() {
        if self.layer.shadowColor != UIColor.white.cgColor {
            self.layer.shadowColor = UIColor.white.cgColor
        }
    }
    
    func resetPlaceholder() {
        if self.textColor == .lightGray {
            self.text = nil
            self.textColor = .white
        }
    }
    
    var numberOfCurrentlyDisplayedLines: Int {
        let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return Int(((size.height - layoutMargins.top - layoutMargins.bottom) / font!.lineHeight))
    }
    
    /// Removes last characters until the given max. number of lines is reached
    func removeTextUntilSatisfying(maxNumberOfLines: Int) {
        while numberOfCurrentlyDisplayedLines > (maxNumberOfLines) {
            text = String(text.dropLast())
            layoutIfNeeded()
        }
    }
    
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension String {
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
}
