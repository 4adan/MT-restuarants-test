//
//  RestaurantsTableViewController.swift
//  MT-restaurants-test
//
//  Created by Argueta, Adan (CHICO-C) on 6/8/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import UIKit
import CoreData

class RestaurantsTableViewController: UITableViewController {
    var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
      
    @IBAction func addRestaurant(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Restaurant", message: nil, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in

          guard let textField = alert.textFields?.first,
            let name = textField.text else {
              return
          }

          self.save(name: name)
          self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
      }
    
    func ratingText(restaurant: Restaurant) -> String{
        return restaurant.reviews?.count ?? 0 > 0 ? String(format: "Rating: %.1f (%i)", restaurant.avgRating(), restaurant.reviews?.count ?? "0") : "No ratings"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = ratingText(restaurant: restaurant)
             
        return cell
     
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(restaurant: restaurants[indexPath.row])
            restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

   
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviews" {
            if let rtvc = segue.destination as? ReviewsTableViewController {
                if let row = tableView.indexPathForSelectedRow?.row {
                    rtvc.restaurant = restaurants[row]
                    for review in (rtvc.restaurant?.reviews!)! {
                        rtvc.reviews.append(review)
                    }
                }
            }
        }
    }
}

extension RestaurantsTableViewController {
    
    func fetchData() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
          do {
            restaurants = try managedContext.fetch(fetchRequest) as! [Restaurant]
          } catch let error as NSError {
            print("Fetch error. \(error), \(error.userInfo)")
          }
          
        }
    }
    
    func save(name: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)!
            let Restaurant = NSManagedObject(entity: entity, insertInto: managedContext)
            Restaurant.setValue(name, forKeyPath: "name")

            do {
              try managedContext.save()
              restaurants.append(Restaurant as! Restaurant)
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func delete(restaurant: Restaurant) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            for review in restaurant.reviews ?? Set() {
                managedContext.delete(review)
            }
            managedContext.delete(restaurant)
            tableView.reloadData()
        }
    }
}
