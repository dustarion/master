//
//  Colour.swift
//  Cram
//
//  Created by Dalton Ng on 11/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit

// Card Colours
public let newSetCardBackgroundColour = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)

// Gradients for Dark Backgrounds
public let purpleGradient = [UIColor(red:0.60, green:0.38, blue:1.00, alpha:1.0).cgColor, UIColor(red:0.49, green:0.19, blue:1.00, alpha:1.0).cgColor]
public let greenGradient = [UIColor(red:0.16, green:0.96, blue:0.60, alpha:1.0).cgColor, UIColor(red:0.03, green:0.68, blue:0.92, alpha:1.0).cgColor]
public let orangeGradient = [UIColor(red:1.00, green:0.61, blue:0.04, alpha:1.0).cgColor, UIColor(red:0.99, green:0.31, blue:0.00, alpha:1.0).cgColor]
public let pinkGradient = [UIColor(red:1.00, green:0.42, blue:0.53, alpha:1.0).cgColor, UIColor(red:0.78, green:0.31, blue:0.75, alpha:1.0).cgColor]

// Gradients for Sets
public let purpleGradientS = [UIColor(red:0.44, green:0.31, blue:0.65, alpha:1.0).cgColor, UIColor(red:0.44, green:0.31, blue:0.65, alpha:1.0).cgColor]
public let greenGradientS = [UIColor(red:0.27, green:0.87, blue:0.59, alpha:1.0).cgColor, UIColor(red:0.03, green:0.68, blue:0.92, alpha:1.0).cgColor]
public let orangeGradientS = [UIColor(red:1.00, green:0.61, blue:0.04, alpha:1.0).cgColor, UIColor(red:0.99, green:0.31, blue:0.00, alpha:1.0).cgColor]
public let pinkGradientS = [UIColor(red:1.00, green:0.42, blue:0.53, alpha:1.0).cgColor, UIColor(red:0.78, green:0.31, blue:0.75, alpha:1.0).cgColor]

// Universal Tint
public let universalDarkTintColour = UIColor(red:0.74, green:0.06, blue:0.88, alpha:1.0)
public let yellowTintColour = UIColor(red:0.97, green:0.91, blue:0.11, alpha:1.0)

func getGradient(_ gradient: Int) -> [CGColor] {
    
    let gradientToUse = gradient%4
    
    switch gradientToUse {
    case 0:
        return purpleGradient
    case 1:
        return greenGradient
    case 2:
        return orangeGradient
    case 3:
        return pinkGradient
    default:
        return purpleGradient
    }
}

func getGradientDarkText(_ gradient: Int) -> [CGColor] {
    let gradientToUse = gradient%4
    
    switch gradientToUse {
    case 0:
        return purpleGradient
    case 1:
        return greenGradient
    case 2:
        return orangeGradient
    case 3:
        return pinkGradient
    default:
        return purpleGradient
    }
}
