//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Yohannes Wijaya on 6/20/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample meals
        if let savedMeals = loadMeals() {
            meals += savedMeals
        }
        else {
            // Load the sample meals
            loadSampleMeals()
        }
    }
    
    func loadSampleMeals() {
        let mealPhoto1 = UIImage(named: "meal1")
        let meal1 = Meal(name: "Caprese Salad", photo: mealPhoto1, rating: 2)
        
        let mealPhoto2 = UIImage(named: "meal2")
        let meal2 = Meal(name: "Chicken & Potatoes", photo: mealPhoto2, rating: 4)
        
        let mealPhoto3 = UIImage(named: "meal3")
        let meal3 = Meal(name: "Pasta with Meatballs", photo: mealPhoto3, rating: 3)
        
        meals += [meal1!, meal2!, meal3!]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Just one section needed for this app
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "MealTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.ratingIndex = meal.rating

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMeal" {
            /*
            This code tries to downcast the destination view controller of the segue to a MealViewController using the forced type cast operator (as!). Notice that this operation has an exclamation mark (!) instead of a question mark (?) at the end, like you’ve seen so far with type cast operators. This means that the operator performs a forced type cast. If the cast is successful, the local constant mealDetailViewController gets assigned the value of segue.destinationViewController cast as type MealViewController. If the cast is unsuccessful, the app should crash at runtime.
            
            Only use a forced cast if you’re absolutely certain that the cast will succeed—and that if it fails, something has gone wrong in the app and it should crash. Otherwise, downcast using as?.
            */
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "addMeal" {
            print("Adding a new meal")
        }
    }
    
    @IBAction func unwindToMealList(segue: UIStoryboardSegue) {
        /*
        This code uses the optional type cast operator (as?) to try to downcast the source view controller of the segue to type MealViewController. You need to downcast because segue.sourceViewController is of type UIViewController, but you need to work with MealViewController.
        
        The operator returns an optional value, which will be nil if the downcast wasn’t possible. If the downcast succeeds, the code assigns that view controller to the local constant sourceViewController, and checks to see if the meal property on sourceViewController is nil. If the meal property is non-nil, the code assigns the value of that property to the local constant meal and executes the if statement.
        
        If either the downcast fails or the meal property on sourceViewController is nil, the condition evaluates to false and the if statement doesn’t get executed.
        */
        if let sourceViewController = segue.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            
            // Check whether a row in the table view is selected. If it is, that means user taps on one of the table view cells to edit
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an exisitng meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal
                
                /*
                This code computes the location in the table view where the new table view cell representing the new meal will be inserted, and stores it in a local constant called newIndexPath.
                */
                let newIndexPath =  NSIndexPath(forRow: meals.count, inSection: 0)
                
                meals.append(meal)
                
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            saveMeals()
        }
    }
    
    // MARK: - NSCoding 
    // MARK: to save meal list
    
    func saveMeals() {
        /*
        This method attempts to archive the meals array to a specific location, and returns true if it’s successful. It uses the constant ArchivePath that you defined in the Meal class to identify where to save the information.
        */
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave { print("unsuccessful file save occured") }
    }
    
    // MARK: To load meal list
    
    // This method has a return type of an optional array of Meal objects, meaning that it might return an array of Meal objects or might return nothing (nil)
    func loadMeals() -> [Meal]? {
        
        /*
        This method attempts to unarchive the object stored at the path Meal.ArchivePath and downcast that object to an array of Meal objects. This code uses the as? operator so that it can return nil when appropriate.
        */
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
}
