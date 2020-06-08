//
//  ReviewsTableViewController.swift
//  MT-restaurants-test
//
//  Created by Argueta, Adan (CHICO-C) on 6/8/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import UIKit
import CoreData
import FCAlertView

class ReviewsTableViewController: UITableViewController {
    
    var restaurant: Restaurant?
    var reviews: [Review] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addReview(_ sender: UIBarButtonItem) {
        var reviewComment = ""
        let ratingAlert = FCAlertView.init()
        var save = false
        ratingAlert.makeAlertTypeRateStars { (ratingValue) in
            if save {
                self.saveReview(comment: reviewComment, rating: ratingValue)
                self.tableView.reloadData()
            }
        }
        ratingAlert.addTextField(withPlaceholder: "Review comment") { (comment) in
            reviewComment = comment ?? ""
        }
        
        ratingAlert.addButton("Cancel") {
            save = false
            ratingAlert.dismiss()
        }
        ratingAlert.addButton("Save") {
            save = true
            ratingAlert.dismiss()
        }
        
        ratingAlert.hideDoneButton = true
        ratingAlert.showAlert(withTitle: "Add Review", withSubtitle: nil, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant?.reviews?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath)
        
        cell.textLabel?.text = reviews[indexPath.row].comment
        cell.detailTextLabel?.text = String(format: "%i", reviews[indexPath.row].rating)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(review: reviews[indexPath.row])
            reviews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension ReviewsTableViewController {
    func saveReview(comment: String, rating: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Review", in: managedContext)!
            let review = NSManagedObject(entity: entity, insertInto: managedContext)
            review.setValue(comment, forKeyPath: "comment")
            review.setValue(restaurant, forKeyPath: "restaurant")
            review.setValue(rating, forKey: "rating")
            do {
              try managedContext.save()
                reviews.append(review as! Review)
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func delete(review: Review) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext

            managedContext.delete(review)
            tableView.reloadData()
        }
    }
}
