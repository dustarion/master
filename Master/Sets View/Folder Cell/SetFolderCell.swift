//
//  SetFolderCell.swift
//  Master
//
//  Created by Dalton Ng on 2/1/19.
//  Copyright © 2019 Dalton Prescott. All rights reserved.
//

import UIKit

class FolderRow : UITableViewCell {
    
    
}

extension FolderRow: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
        
        let index = indexPath.row
        
        // Setup Gradient
        cell.TitleLabel.text = "Psychology"
        //let gradientView = UIView()
        //(gradientView.layer as! CAGradientLayer).colors = getGradient(index)
        //cell.backgroundView = gradientView
        
        return cell
    }
}
/*
 = self.layer as? CAGradientLayer else { return }
 gradientLayer.colors = getGradientDarkText(index)
 */

//extension FolderRow: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//
//}
