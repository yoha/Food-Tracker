//
//  Meal.swift
//  FoodTracker
//
//  Created by Yohannes Wijaya on 6/20/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    
    // MARK: - Properties
    
    
    var name: String
    var photo: UIImage?
    var rating: Int

    // MARK: - Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    
    // MARK: - Archiving Paths
    
    /*
    You mark these constants with the static keyword, which means they apply to the class instead of an instance of the class. Outside of the Meal class, you’ll access the path using the syntax Meal.ArchivePath.
    */
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    // MARK: - Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative
        if rating < 0 || name.isEmpty {
            return nil
        }
    }
    
    // MARK: - NSCoding
    
    // Prepares the class’s information to be archived
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    /*
    The required keyword means this initializer must be implemented on every subclass of the class that defines this initializer.
    
    The convenience keyword denotes this initializer as a convenience initializer. Convenience initializers are secondary, supporting initializers that need to call one of their class’s designated initializers. Designated initializers are the primary initializers for a class. They fully initialize all properties introduced by that class and call a superclass initializer to continue the initialization process up the superclass chain.
    
    The question mark (?) means that this is a failable initializer that might return nil.
    */
    required convenience init?(coder aCoder: NSCoder) {
        
        /*
        The decodeObjectForKey(_:) method unarchives the stored information stored about an object.
        
        The return value of decodeObjectForKey(_:) is AnyObject, which you downcast in the code above as a String to assign it to a name constant. You downcast the return value using the forced type cast operator (as!) because if the object can’t be cast as a String, or if it’s nil, something has gone wrong and the error should cause a crash at runtime.
        */
        let name = aCoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        /*
        You downcast this return value of decodeObjectForKey(_:) as a UIImage to be assigned to a photo constant. In this case, you downcast using the optional type cast operator (as?), because the photo property is an optional, so the value might be a UIImage, or it might be nil. You need to account for both cases.
        */
        let photo = aCoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let rating = aCoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // Must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
}
