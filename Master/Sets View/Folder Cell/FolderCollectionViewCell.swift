//
//  FolderCollectionViewCell.swift
//  Master
//
//  Created by Dalton Ng on 2/1/19.
//  Copyright © 2019 Dalton Prescott. All rights reserved.
//
import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    
    // Declare Outlets
    @IBOutlet weak var TitleLabel: UILabel!
    
    override func didMoveToSuperview() {
        self.setupRoundedCorners()
    }
    
    func setupRoundedCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
}
