//
//  Review+CoreDataProperties.swift
//  MT-restaurants-test
//
//  Created by Argueta, Adan (CHICO-C) on 6/8/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var comment: String?
    @NSManaged public var rating: Int16
    @NSManaged public var restaurant: Restaurant?

}
