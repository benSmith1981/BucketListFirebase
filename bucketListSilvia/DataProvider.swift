//
//  DataProvider.swift
//  bucketListSilvia
//
//  Created by Jeroen de Bie on 01/03/2017.
//  Copyright © 2017 Jeroen de Bie. All rights reserved.
//

import Foundation
import FirebaseDatabase
class DataProvider {
    
    public static let sharedInstance = DataProvider()
    
    private init() {
    }
    
    var ref: FIRDatabaseReference!
    
    public func getBucketListData() {
        ref = FIRDatabase.database().reference() //Stores a link to firebase for your database.
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dataDictionarys = snapshot.value as? NSDictionary {
               let bucketArray = dataDictionarys["BucketWishes"]
               let bucketlistItemsArray = BucketWishes.modelsFromDictionaryArray(array: bucketArray as! NSArray)
                
                let bucketListData = ["BucketWishes": bucketlistItemsArray]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "BucketWishesnotify"),
                                                object: self ,
                                                userInfo: bucketListData)

            } else {
                print("Error while retrieving data from Firebase")
            }
        })
    }
}
