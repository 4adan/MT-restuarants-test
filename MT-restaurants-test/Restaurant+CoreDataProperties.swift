//
//  Restaurant+CoreDataProperties.swift
//  MT-restaurants-test
//
//  Created by Argueta, Adan (CHICO-C) on 6/8/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var name: String?
    @NSManaged public var reviews: Set<Review>?
    
    func avgRating() -> Double {
        var sum: Double  = 0
        for review in reviews ?? Set() {
            sum = sum + Double(review.rating)
        }
        let avg = sum/Double(reviews?.count ?? 0)

        return avg
    }

}

// MARK: Generated accessors for reviews
extension Restaurant {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
