//
//  NewSetViewController.swift
//  Master
//
//  Created by Dalton Ng on 28/12/18.
//  Copyright © 2018 Dalton Prescott. All rights reserved.
//

import UIKit
import Firebase
import Hero

class NewSetViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    // Card Vars
    var numberOfCards = 0
    var arrayOfCards = [UIView]()
    var parentView = UIView()
    
    var currentCard = UIView()
    var currentTextviewTag = Int()
    var cardActive = false
    var scrollPosition:CGFloat = 0.0
    
    var toolBar: UIToolbar?
    var centerPoint = CGPoint()
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    override func viewDidLoad() {
        setupAccessoryView()
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        parentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        parentView.backgroundColor = .black
        scrollView.addSubview(parentView)
        scrollView.contentSize = parentView.frame.size
        scrollView.layoutIfNeeded()
        createTitleCard()
        newEmptyQuestionCard(insertAt: numberOfCards) // Create one empty card
    }
    
    func exitNewSetViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
        print("Done Button")
        currentCard.endEditing(true)
        
        // Check the fields!
        
        // All's Good. Let's save the data.
        var questionsToSave : [NewQuestion] = []
        var cards = arrayOfCards
        
        let firstCard = cards.removeFirst()
        
        // All should be good here!
        let title = (firstCard.viewWithTag(1) as! UITextView).text
        let courseCode = (firstCard.viewWithTag(3) as! UITextView).text
        
        for card in cards {
            let question = (card.viewWithTag(1) as! UITextView).text
            let answer = (card.viewWithTag(3) as! UITextView).text
            questionsToSave.append(NewQuestion(question: question!, answer: answer!))
        }
        
        var newSet = NewSetData(title: title!, courseCode: courseCode!, questions: questionsToSave)
        
        // Check Here
        checkFields(newSet: &newSet)
        if !(checkFields(newSet: &newSet)) {
            // Skip Out
            return
        }
        
        showSaveMenu()
        
        // Save
        newSet.printAll()
        
        // Firebase Saving!
        
    }
    
    func checkFields(newSet: inout NewSetData) -> Bool {
        
        var questions = newSet.questions
        
        if (questions.count == 0) {
            // Error, no questions
            // Exit Immediately
            exitNewSetViewController()
            return false
        }
        
        // Delete Blanks
        for (index, question) in questions.enumerated().reversed() {
            if (question.question == "") && (question.answer == "") {
                deleteQuestionCard(index: index+1)
            }
        }
        
        if arrayOfCards.count <= 1 {
            exitNewSetViewController()
            return false
        }
        
        if newSet.title.isEmpty {
            notifyMissingTitle()
            return false
        }
        
        newSet.questions = questions
        
        
        for (index, question) in questions.enumerated() {
            if (question.question == "") || (question.answer == "") {
                notifyMissingEntry(index + 1)
                return false
            }
        }
        
        return true
    }
    
    func notifyMissingTitle() {
        scrollToCell(index: 0)
        let titleField = arrayOfCards[0].viewWithTag(1)! as! UITextView
        titleField.setBottomBorderColour(UIColor.red)
        titleField.backgroundColor = .black
        titleField.becomeFirstResponder()
    }
    
    func selectMissingEntry(_ index: Int) {
        var textView = arrayOfCards[index].viewWithTag(1) as! UITextView
        if !(textView.text!.isEmpty) {
            textView = arrayOfCards[index].viewWithTag(3) as! UITextView
        }
        textView.setBottomBorderColour(UIColor.red)
        textView.becomeFirstResponder()
    }
    
    func notifyMissingEntry(_ index: Int) {
        //ShowSwiftMessageMissingEntry { self.deleteQuestionCard(index: index) }
        scrollToCell(index: index)
        let card = arrayOfCards[index]
        card.layer.borderWidth = 2.0
        card.layer.borderColor = yellowTintColour.cgColor
        selectMissingEntry(index)
    }
    
    func showSaveMenu() {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.view.tintColor = universalDarkTintColour
        alert.view.backgroundColor = newSetCardBackgroundColour
        
        alert.addAction(UIAlertAction(title: "Publish", style: .default , handler:{ (UIAlertAction)in
            // Publish
        }))
        
        alert.addAction(UIAlertAction(title: "Save as draft", style: .default , handler:{ (UIAlertAction)in
            // Draft
        }))
        
        alert.addAction(UIAlertAction(title: "Delete this set", style: .destructive, handler:{ (UIAlertAction)in
            // Delete
            self.exitNewSetViewController()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            // Cancel
        }))
        
        self.present(alert, animated: true, completion: {
            // Done
        })
    }
    
    @IBAction func addButton(_ sender: Any) {
        if cardActive {
             let cardIndex = getCardIndex(currentCard)+1
             newEmptyQuestionCard(insertAt: cardIndex)
             arrayOfCards[cardIndex].viewWithTag(1)!.becomeFirstResponder()
        } else {
            newEmptyQuestionCard(insertAt: numberOfCards)
            arrayOfCards.last?.viewWithTag(1)!.becomeFirstResponder()
        }
    }
    
    @objc func dismissButton() {
        currentCard.endEditing(true)
    }

    @objc func nextCell() {
        let index = getCardIndex(currentCard)
        print(index)
        // 0 2
        if currentTextviewTag == 1 {
            currentCard.viewWithTag(1)!.resignFirstResponder()
            currentCard.viewWithTag(3)!.becomeFirstResponder()
            currentTextviewTag = 3
        }
            
        else if currentTextviewTag == 3 {
            if index >= numberOfCards-1 {
                return
            }
            else {
                let nextCard = arrayOfCards[index+1]
                currentCard.viewWithTag(3)!.resignFirstResponder()
                nextCard.viewWithTag(1)!.becomeFirstResponder()
                currentCard = nextCard
                currentTextviewTag = 1
            }
        }
    }
    
    func setupAccessoryView() {
        let actionToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        actionToolbar.barStyle = .black
        actionToolbar.isTranslucent = false
        actionToolbar.tintColor = universalDarkTintColour
        actionToolbar.items = [
            UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextCell)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissButton))]
        actionToolbar.sizeToFit()
        toolBar = actionToolbar
    }
    
    func createTitleCard() {
        // Configure the main card
        let titleCard = UIView(frame: CGRect(x: cardX(), y: firstCardY(), width: cardWidth(), height: initialCardHeight()))
        titleCard.backgroundColor = .black
        //titleCard.backgroundColor = newSetCardBackgroundColour
        titleCard.layer.cornerRadius = 10.0
        titleCard.accessibilityIdentifier = randomString(length: 20)
        
        // Textfield for Title
        let titleTextfield = UITextView(frame: CGRect(x: innerCardPadding(), y: innerCardPadding(), width: innerCardWidth(), height: initialTextfieldHeight()))
        titleTextfield.font = textFieldFont()
        titleTextfield.textColor = .white
        titleTextfield.isScrollEnabled = false
        titleTextfield.delegate = self
        titleTextfield.translatesAutoresizingMaskIntoConstraints = true
        titleTextfield.tag = 1
        // Add Bottom Border
        titleTextfield.setBottomWhiteBorder()
        titleTextfield.layer.backgroundColor = UIColor.black.cgColor
        titleTextfield.inputAccessoryView = toolBar
        titleTextfield.removeTextUntilSatisfying(maxNumberOfLines: 1)
        titleCard.addSubview(titleTextfield)
        
        // TextField Title Label (Title)
        let titleTextfieldLabel = UILabel(frame: CGRect(x: innerCardPadding(), y: titleTextfield.frame.maxY+innerCardPadding(), width: innerCardWidth(), height: titleHeight()))
        titleTextfieldLabel.textColor = .white
        titleTextfieldLabel.font = titleFont()
        titleTextfieldLabel.text = "Title"
        titleTextfieldLabel.tag = 2
        titleCard.addSubview(titleTextfieldLabel)
        
        // TextField for Code Label
        let codeTextfield = UITextView(frame: CGRect(x: innerCardPadding(), y: titleTextfieldLabel.frame.maxY+innerCardPadding(), width: innerCardWidth(), height: initialTextfieldHeight()))
        codeTextfield.font = textFieldFont()
        codeTextfield.textColor = .white
        codeTextfield.isScrollEnabled = false
        codeTextfield.delegate = self
        codeTextfield.translatesAutoresizingMaskIntoConstraints = true
        codeTextfield.tag = 3
        // Add Bottom Border
        codeTextfield.setBottomWhiteBorder()
        codeTextfield.layer.backgroundColor = UIColor.black.cgColor
        codeTextfield.inputAccessoryView = toolBar
        codeTextfield.removeTextUntilSatisfying(maxNumberOfLines: 1)
        titleCard.addSubview(codeTextfield)
        
        // TextField Code Label (Course Code) Optional
        let codeTextfieldLabel = UILabel(frame: CGRect(x: innerCardPadding(), y: codeTextfield.frame.maxY+innerPadding(), width: innerCardWidth(), height: titleHeight()))
        codeTextfieldLabel.textColor = .white
        codeTextfieldLabel.font = titleFont()
        codeTextfieldLabel.text = "Course Code (Optional)"
        codeTextfieldLabel.tag = 4
        titleCard.addSubview(codeTextfieldLabel)
        
        // Add to the parent scrollview
        parentView.addSubview(titleCard)
        
        currentCard = titleCard
        arrayOfCards.append(titleCard)
        numberOfCards += 1 // Increment numberOfCards
    }
    
    func newEmptyQuestionCard(insertAt: Int) {
        // Configure the main card
        let questionCard = UIView(frame: CGRect(x: cardX(), y: cardY(index: insertAt-1), width: cardWidth(), height: initialCardHeight()))
        questionCard.backgroundColor = newSetCardBackgroundColour
        questionCard.layer.cornerRadius = 10.0
        questionCard.accessibilityIdentifier = randomString(length: 20)
        
        // Textfield for Question
        let questionTextfield = UITextView(frame: CGRect(x: innerCardPadding(), y: innerCardPadding(), width: innerCardWidth(), height: initialTextfieldHeight()))
        questionTextfield.font = textFieldFont()
        questionTextfield.textColor = .white
        questionTextfield.isScrollEnabled = false
        questionTextfield.delegate = self
        questionTextfield.translatesAutoresizingMaskIntoConstraints = true
        questionTextfield.tag = 1
        // Add Bottom Border
        questionTextfield.setBottomWhiteBorder()
        questionTextfield.inputAccessoryView = toolBar
        questionTextfield.removeTextUntilSatisfying(maxNumberOfLines: 3)
        questionCard.addSubview(questionTextfield)
        
        // TextField Question Label (Question)
        let questionTextfieldLabel = UILabel(frame: CGRect(x: innerCardPadding(), y: questionTextfield.frame.maxY+innerCardPadding(), width: innerCardWidth(), height: titleHeight()))
        questionTextfieldLabel.textColor = .white
        questionTextfieldLabel.font = titleFont()
        questionTextfieldLabel.text = "Question"
        questionTextfieldLabel.tag = 2
        questionCard.addSubview(questionTextfieldLabel)
        
        // TextField for Answer Label
        let answerTextfield = UITextView(frame: CGRect(x: innerCardPadding(), y: questionTextfieldLabel.frame.maxY+innerCardPadding(), width: innerCardWidth(), height: initialTextfieldHeight()))
        answerTextfield.font = textFieldFont()
        answerTextfield.textColor = .white
        answerTextfield.isScrollEnabled = false
        answerTextfield.delegate = self
        answerTextfield.translatesAutoresizingMaskIntoConstraints = true
        answerTextfield.tag = 3
        // Add Bottom Border
        answerTextfield.setBottomWhiteBorder()
        answerTextfield.inputAccessoryView = toolBar
        answerTextfield.removeTextUntilSatisfying(maxNumberOfLines: 3)
        questionCard.addSubview(answerTextfield)
        
        // TextField Answer Label (Answer)
        let answerTextfieldLabel = UILabel(frame: CGRect(x: innerCardPadding(), y: answerTextfield.frame.maxY+innerPadding(), width: innerCardWidth(), height: titleHeight()))
        answerTextfieldLabel.textColor = .white
        answerTextfieldLabel.font = titleFont()
        answerTextfieldLabel.text = "Answer"
        answerTextfieldLabel.tag = 4
        questionCard.addSubview(answerTextfieldLabel)
        
        // Add Pan Gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        gestureRecognizer.name = "panGesture"
        questionCard.addGestureRecognizer(gestureRecognizer)
        
        // Add to the parent scrollview
        parentView.addSubview(questionCard)
        
        numberOfCards += 1 // Increment numberOfCards
        
        let heightUpdate = initialCardHeight() + firstCardY()
        updateParentView(height: heightUpdate)
        
        if insertAt >= numberOfCards {
            arrayOfCards.append(questionCard)
            
        }
        else {
            print("inserting at" + insertAt.description)
            arrayOfCards.insert(questionCard, at: insertAt)
            updateCellsBelow(index: insertAt, height: heightUpdate)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.name == "panGesture" {
            let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: scrollView)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
    
    // User Pan
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            
            scrollView.isScrollEnabled = false
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
            if shouldSnapToCenter(gestureRecognizer.view!) {
                if gestureRecognizer.view!.frame.maxX < (scrollView.frame.width/3)*2 {
                    deleteButton(visible: true, centerY: gestureRecognizer.view!.center.y, view: gestureRecognizer.view!)
                    holdCardsInPosition.append(gestureRecognizer.view!)
                }
            } else {
                if gestureRecognizer.view!.frame.maxX > (scrollView.frame.width/3)*2 {
                    deleteButton(visible: false, centerY: gestureRecognizer.view!.center.y, view: gestureRecognizer.view!)
                    removeViewFromHoldCards(gestureRecognizer.view!)
                }
            }
            
        }
        
        if gestureRecognizer.state == .ended {
            
            scrollView.isScrollEnabled = true
            
            if shouldSnapToCenter(gestureRecognizer.view!) {
                gestureRecognizer.view!.center = CGPoint(x: self.view.center.x, y: gestureRecognizer.view!.center.y)
            }
            else {
                gestureRecognizer.view!.center = CGPoint(x: self.scrollView.frame.minX, y: gestureRecognizer.view!.center.y)
            }
        }
        
    }
    
    var holdCardsInPosition = [UIView()]
    var deleteButtons = [UIButton()]
    
    func removeViewFromHoldCards(_ view: UIView) {
        for (index, card) in holdCardsInPosition.enumerated() {
            if view.accessibilityIdentifier == card.accessibilityIdentifier {
                holdCardsInPosition.remove(at: index)
                return
            }
        }
    }
    
    func shouldSnapToCenter(_ view: UIView) -> Bool {
        for card in holdCardsInPosition {
            if view.accessibilityIdentifier == card.accessibilityIdentifier {
                return false
            }
        }
        
        return true
    }
    
    func closeAllHoldCards() {
        holdCardsInPosition.removeAll()
        removeAllDeleteButtons()
        
        for card in arrayOfCards {
            if card.center.x != scrollView.center.x {
                card.center.x = scrollView.center.x
            }
        }
    }
    
    func deleteButton(visible: Bool, centerY: CGFloat, view: UIView) {
         // Use accesibility identifier to be sure!
        
        if visible {
            let deleteButton = UIButton(frame: CGRect(x: paddingFromRight(width: 80.0), y: 0, width: 80.0, height: 80.0))
            deleteButton.center.y = centerY
            deleteButton.setImage(UIImage(named: "Wrong"), for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
            //deleteButton.accessibilityIdentifier = "DeleteButton" + view.accessibilityIdentifier!
            deleteButtons.append(deleteButton)
            parentView.addSubview(deleteButton)
        } else {
            for (index, button) in deleteButtons.enumerated() {
                if (button.center.y) == (view.center.y) {
                    button.removeFromSuperview()
                    deleteButtons.remove(at: index)
                    return
                }
            }
        }
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        for (index, card) in arrayOfCards.enumerated() {
            if card.center.y == sender.center.y {
                print("Deleting Card at Index")
                let centerY = sender.center.y
                deleteButton(visible: false, centerY: sender.center.y, view: card)
                moveAllDeleteButtonsBelow(centerY: centerY, height: -(card.frame.height + firstCardY()))
                deleteQuestionCard(index: index)
                return
            }
        }
        
    }
    
    func moveAllDeleteButtonsBelow(centerY: CGFloat, height: CGFloat) {
        for button in deleteButtons {
            if button.center.y > centerY {
                UIView.animate(withDuration: 0.2) {
                    button.center.y += height
                }
            }
        }
    }
    
    func removeAllDeleteButtons() {
        for button in deleteButtons {
            button.removeFromSuperview()
        }
        deleteButtons.removeAll()
    }
    
    func deleteQuestionCard(index: Int) {
        if index >= arrayOfCards.endIndex { return }
        
        let heightUpdate = -(arrayOfCards[index].frame.height + firstCardY())
        updateParentView(height: heightUpdate)
        
        arrayOfCards[index].removeFromSuperview()
        arrayOfCards.remove(at: index)
        numberOfCards -= 1 // Increment numberOfCards
        
        updateCellsBelow(index: index-1, height: heightUpdate)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        cardActive = true
        currentCard = textView.superview!
        currentCard.layer.borderWidth = 0
        currentTextviewTag = textView.tag
        let cardIndex = getCardIndex(textView.superview!)
        scrollToCell(index: cardIndex)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        cardActive = false
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.resetBottomBorder()
        let outerCard = textView.superview!
        outerCard.layer.borderWidth = 0
        
        // Make the textfield grow
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        // Grow the parent card too
        //updateParentCard(height: newFrame.height - textView.frame.height)
        let heightChange = newFrame.height - textView.frame.height
        updateCard(height:heightChange, currentTextFieldTag: textView.tag)
        
        // Update textfield with new height
        textView.frame = newFrame
    }
    
    // Shift Other Cards
    
    // Card Growing Functions
    func updateCard(height:CGFloat, currentTextFieldTag: Int = 0) {
        updateParentCard(height: height) // Card Size
        updateParentView(height: height)
        updateCellsBelow(index: getCardIndex(currentCard), height: height)
        
        // Move Bottom Items
        
        if currentTextFieldTag == 1 { // First textfield
            // Move the first Title Down
            let frame1 = currentCard.viewWithTag(2)!.frame
            currentCard.viewWithTag(2)!.frame = CGRect(x: frame1.minX, y: frame1.minY + height, width: frame1.width, height: frame1.height)
            
            // Move the second Textview Down
            let frame2 = currentCard.viewWithTag(3)!.frame
            currentCard.viewWithTag(3)!.frame = CGRect(x: frame2.minX, y: frame2.minY + height, width: frame2.width, height: frame2.height)
            
            // Move the second Title Down
            let frame3 = currentCard.viewWithTag(4)!.frame
            currentCard.viewWithTag(4)!.frame = CGRect(x: frame3.minX, y: frame3.minY + height, width: frame3.width, height: frame3.height)
        }
        
        else if currentTextFieldTag == 3 {
            // Move the second Title Down
            let frame1 = currentCard.viewWithTag(4)!.frame
            currentCard.viewWithTag(4)!.frame = CGRect(x: frame1.minX, y: frame1.minY + height, width: frame1.width, height: frame1.height)
        }
    }

    func updateParentCard(height: CGFloat) {
        currentCard.frame = CGRect(x: currentCard.frame.minX, y: currentCard.frame.minY, width: currentCard.frame.width, height: currentCard.frame.height + height)
    }
    
    // Grow the Parent View
    func updateParentView(height: CGFloat) {
        parentView.frame = CGRect(x: parentView.frame.minX, y: parentView.frame.minY, width: parentView.frame.width, height: parentView.frame.height + height)
        scrollView.contentSize = parentView.frame.size
    }
    
    // Get Index of a card
    func getCardIndex(_ card: UIView) -> Int {
        for (index, cardTest) in arrayOfCards.enumerated() {
            if cardTest.accessibilityIdentifier == card.accessibilityIdentifier {
                return index
            }
        }
        
        print("CardIndexNotFound")
        return numberOfCards-1
    }
    
    // Shift Cells Down if needed
    func updateCellsBelow(index: Int, height: CGFloat) {
        if index >= numberOfCards-1 { return } // Don't update if last cell
        for i in index+1...(numberOfCards-1) {
            let card = arrayOfCards[i]
            if (i == index+1 || i == index+2) {
                UIView.animate(withDuration: 0.2) {
                    card.frame = CGRect(x: card.frame.minX, y: card.frame.minY + height, width: card.frame.width, height: card.frame.height)
                }
            } else {
                card.frame = CGRect(x: card.frame.minX, y: card.frame.minY + height, width: card.frame.width, height: card.frame.height)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset.y + firstCardY()
        closeAllHoldCards()
    }
    
    // Scroll scrollview as needed
    func scrollToCell(index: Int = 0, textfieldTag: Int = 1) {
        
        let scrollIntendedY = cardMinY(index: index) - firstCardY()
        
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollIntendedY), animated: true)
    }

}

extension NewSetViewController {

    
    // Card Positioning Functions
    func cardWidth() -> CGFloat {
        return self.view.frame.width-24
    }
    
    func innerCardWidth() -> CGFloat {
        return cardWidth() - (innerCardPadding() * 2)
    }
    
    func initialCardHeight() -> CGFloat {
        return 180.0
    }
    
    func cardX() -> CGFloat {
        return 12.0
    }
    
    func firstCardY() -> CGFloat {
        return 24.0
    }
    
    func innerCardPadding() -> CGFloat {
        return 12.0
    }
    
    func innerPadding() -> CGFloat {
        return 20.0
    }
    
    func titleHeight() -> CGFloat {
        return 16.0
    }
    
    func initialTextfieldHeight() -> CGFloat {
        return 35.0
    }
    
    func paddingFromRight(width: CGFloat) -> CGFloat {
        return ((self.scrollView.frame.width/4)*3) - width/2
    }
    
    // Fonts
    func titleFont() -> UIFont {
        return UIFont(name: "AvenirNext-DemiBold", size: 14.0)!
    }
    
    func textFieldFont() -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: 14.0)!
    }
    
    func cardY(index: Int) -> CGFloat {
        if index >= numberOfCards {
            // Bottom
            return arrayOfCards.last!.frame.maxY + firstCardY()
        }
        else {
            return arrayOfCards[index].frame.maxY + firstCardY()
        }
    }
    
    func cardMinY(index: Int) -> CGFloat {
        if index >= numberOfCards {
            // Bottom
            return arrayOfCards.last!.frame.minY
        }
        else {
            return arrayOfCards[index].frame.minY
        }
    }
}
