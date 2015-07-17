//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Yohannes Wijaya on 6/18/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import XCTest

class FoodTrackerTests: XCTestCase {
    // MARK: FoodTracker Tests
    
    // Test to confirm that the Meal initializer returns when no name or a negative rating is provided. 
    func testMealInitialization() {
        // Success case
        let qualifiedMeal = Meal(name: "Newest meal", photo: nil, rating: 5)
        XCTAssertNotNil(qualifiedMeal)
        
        // Failure case 1
        let noNameMeal = Meal(name: "", photo: nil, rating: 5)
        XCTAssertNil(noNameMeal, "Empty name is invalid")
        
        // Failure case 2
        let negativeRatingMeal = Meal(name: "negative rating meal", photo: nil, rating: -5)
        XCTAssertNil(negativeRatingMeal, "Negative rating is invalid")
    }
    
}
