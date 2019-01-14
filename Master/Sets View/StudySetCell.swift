//
//  StudySetCell.swift
//  Cram
//
//  Created by Dalton Ng on 11/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import SwipeCellKit

class StudySetCell: SwipeTableViewCell {
    @IBOutlet weak var CardView: GradientView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!
    
    var index = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        setupRoundedCorners()
    }
    
    func setGradient() {
        CardView.index = index
        CardView.setGradient()
    }
    
    func setupRoundedCorners() {
        CardView.clipsToBounds = true
        CardView.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class GradientView: UIView {
    var index = Int()
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGradient() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = getGradientDarkText(index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
