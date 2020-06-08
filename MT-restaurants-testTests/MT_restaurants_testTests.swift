//
//  MT_restaurants_testTests.swift
//  MT-restaurants-testTests
//
//  Created by Argueta, Adan (CHICO-C) on 6/8/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import XCTest
import CoreData
@testable import MT_restaurants_test

class MT_restaurants_testTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAvgRating() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        var entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext!)!
        let restaurant = NSManagedObject(entity: entity, insertInto: managedContext)
        restaurant.setValue("Mortons", forKeyPath: "name")
        entity = NSEntityDescription.entity(forEntityName: "Review", in: managedContext!)!
        
        let review1 = NSManagedObject(entity: entity, insertInto: managedContext)
        review1.setValue(5, forKeyPath: "rating")
        let review2 = NSManagedObject(entity: entity, insertInto: managedContext)
        review2.setValue(4, forKeyPath: "rating")
        var set = Set<NSManagedObject>()
        set.insert(review1)
        set.insert(review2)


        restaurant.setValue(set, forKeyPath: "reviews")
        let rest = restaurant as! Restaurant

        // 9/2 = 4.5
        XCTAssertEqual(rest.avgRating(), 4.5)
        
        
        let review3 = NSManagedObject(entity: entity, insertInto: managedContext)
        review3.setValue(3, forKeyPath: "rating")
        set.insert(review3)
        let review4 = NSManagedObject(entity: entity, insertInto: managedContext)
        review4.setValue(2, forKeyPath: "rating")
        set.insert(review4)


        restaurant.setValue(set, forKeyPath: "reviews")
        let rest2 = restaurant as! Restaurant

        // 12/4 = 3.5
        XCTAssertEqual(rest2.avgRating(), 3.5)
    }

    func testRatingsText() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        var entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext!)!
        let restaurant = NSManagedObject(entity: entity, insertInto: managedContext)
        restaurant.setValue("Mortons", forKeyPath: "name")
        entity = NSEntityDescription.entity(forEntityName: "Review", in: managedContext!)!
        
        let review1 = NSManagedObject(entity: entity, insertInto: managedContext)
        review1.setValue(5, forKeyPath: "rating")
        let review2 = NSManagedObject(entity: entity, insertInto: managedContext)
        review2.setValue(4, forKeyPath: "rating")
        var set = Set<NSManagedObject>()
        set.insert(review1)
        set.insert(review2)


        restaurant.setValue(set, forKeyPath: "reviews")
        let rest = restaurant as! Restaurant

        let rtvc = RestaurantsTableViewController()

        XCTAssertEqual(rtvc.ratingText(restaurant: rest), "Rating: 4.5 (2)")
    }
    
    func testNoRatings() {
        let rtvc = RestaurantsTableViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext!)!
        let restaurant = NSManagedObject(entity: entity, insertInto: managedContext)

        let rest = restaurant as! Restaurant
        
        XCTAssertEqual(rtvc.ratingText(restaurant: rest), "No ratings")
    }

}
