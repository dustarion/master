//
//  SetsViewController.swift
//  Cram
//
//  Created by Dalton Ng on 11/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import Hero
import SwipeCellKit

// Table View Related Code
class SetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    

    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak private var progressView: UIProgressView!
    
    // Variables
    var sets : [Set] = [Set]()
    
    // Identifiers
    let cardId = "StudyCell"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        registerTableView()
        createSetsArray()
        self.hero.isEnabled = true
        progressView.setProgress(0, animated: true)
    }
    
//    @IBAction func AddButton(_ sender: Any) {
//        tableView.scrollToRow(at: [0,0], at: .top, animated: false)
//
//        let EditSetVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditSetVC") as! NewSetViewController
//        EditSetVC.hero.modalAnimationType = .zoom
//        self.hero.replaceViewController(with: EditSetVC)
//    }
    
    func createSetsArray() {
        sets.append(Set(title: "THE BASIC PSYCHOLOGY OF HUMAN BEINGS", code: "SP-BA0316"))
        sets.append(Set(title: "NETWORKING FUNDAMENTALS", code: "SP-GF8900"))
        sets.append(Set(title: "COMPUTER ARCHITECTURE", code: "SP-BA0316"))
        sets.append(Set(title: "GERMAN", code: "SP-BA0316"))
        sets.append(Set(title: "PHSYICS DEFINITIONS", code: "SP-BA0316"))
        
        // Dummy
        sets.append(Set(title: "BASIC PSYCHOLOGY", code: "SP-BA0316"))
        sets.append(Set(title: "NETWORKING FUNDAMENTALS", code: "SP-GF8900"))
        sets.append(Set(title: "COMPUTER ARCHITECTURE", code: "SP-BA0316"))
        sets.append(Set(title: "GERMAN", code: "SP-BA0316"))
        sets.append(Set(title: "PHSYICS DEFINITIONS", code: "SP-BA0316"))
        sets.append(Set(title: "BASIC PSYCHOLOGY", code: "SP-BA0316"))
        sets.append(Set(title: "NETWORKING FUNDAMENTALS", code: "SP-GF8900"))
        sets.append(Set(title: "COMPUTER ARCHITECTURE", code: "SP-BA0316"))
        sets.append(Set(title: "GERMAN", code: "SP-BA0316"))
        sets.append(Set(title: "PHSYICS DEFINITIONS", code: "SP-BA0316"))
        sets.append(Set(title: "NETWORKING FUNDAMENTALS", code: "SP-GF8900"))
        sets.append(Set(title: "COMPUTER ARCHITECTURE", code: "SP-BA0316"))
        sets.append(Set(title: "GERMAN", code: "SP-BA0316"))
        sets.append(Set(title: "PHSYICS DEFINITIONS", code: "SP-BA0316"))
    }
    
    func registerTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
            cell.index
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cardId, for: indexPath) as! StudySetCell
        let index = indexPath.row
        
        cell.TitleLabel.text = sets[index].title
        cell.SubtitleLabel.text = sets[index].code
        cell.index = index
        cell.setGradient()
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Folders
        } else {
            return sets.count // Recent Sets
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Folders" // Folders
        } else {
            return "Recent Sets" // Recent Sets
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20.0)!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! StudySetCell
//        cell.TitleLabel.hero.id = "MainCellLabel"
//        cell.CardView.hero.id = "QuizCardView"
//
//        let QuizVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizVC") as! ViewController
//        QuizVC.hero.modalAnimationType = .zoomOut
//        self.hero.replaceViewController(with: QuizVC)
        
    } //MainCellLabel
    
    // Update Scroll View
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let height = (tableView.contentSize.height - tableView.frame.size.height)
        let scrollAmount = tableView.contentOffset.y
        if scrollAmount <= height {
            progressView.setProgress((Float(scrollAmount/height)), animated: true)
        }
            
        else if scrollAmount >= (tableView.contentSize.height - tableView.frame.size.height) {
            progressView.setProgress(1, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            self.sets.remove(at: indexPath.row)
            action.fulfill(with: .delete)
        }
        deleteAction.image = UIImage(named: "Wrong") // Replace with trashcan icon
        deleteAction.backgroundColor = .black
        deleteAction.transitionDelegate = ScaleTransition.default
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        
        return options
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        print(indexPath)
//
////        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
////            // delete item at indexPath
////            self.sets.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
////            print(self.sets)
////        }
//
////
////        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
////            // share item at indexPath
////            print("I want to share: \(self.tableArray[indexPath.row])")
////        }
////
////        share.backgroundColor = UIColor.lightGray
//
//        //return [delete, share]
//        //return [delete]
//
//    }
    
    
    
}
