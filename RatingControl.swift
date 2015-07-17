//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Yohannes Wijaya on 6/19/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: - Properties
    
    var ratingIndex = 0 {
        // adding property observer 'didSet' to this var so that whenever this value changes, it will call 'setNeedsLayout' to update layout to reflect the changes in rating visually
        didSet { setNeedsLayout() }
    }
    var ratingButtons = [UIButton]()
    let spacing = 4
    let stars = 5
    
    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<stars {
            let ratingButton = UIButton()
            ratingButton.setImage(emptyStarImage, forState: .Normal)
            ratingButton.setImage(filledStarImage, forState: .Selected)
            ratingButton.setImage(filledStarImage, forState: [.Selected, .Highlighted])
            
            // Make sure the image doesn't show additional highlight during state change
            ratingButton.adjustsImageWhenHighlighted = false
            
            // Instead of implementing target-action pattern by linking
            // elements in your storyboard to action methods in your code,
            // via drag-&-drop, we can also do it manually in code
            ratingButton.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            ratingButtons += [ratingButton]
            addSubview(ratingButton)
        }
    }
    
    override func layoutSubviews() {
        // Set the button's width & heigth to a square the size of the frame's height so we don't have to hard-code (or potentially change) 44px everywhere
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button + some margin
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
        // Update the button selection states when the view loads, not just when the rating changes
        updateRatingButtonSelectionStates()
    }
    
    // MARK: - Button Action
    
    func ratingButtonTapped(button: UIButton) {
        // You need to add 1 because index starts @ 0 but real-life rating doesn't. 
        // We also use force unwrap operator because ratingButtons are array we created ourselves and definitely will return a valid index
        ratingIndex = ratingButtons.indexOf(button)! + 1
        
        updateRatingButtonSelectionStates()
    }
    
    func updateRatingButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected
            button.selected = index < ratingIndex
        }
    }
}
