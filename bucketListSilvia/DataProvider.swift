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
    var arrayOfBucketWishes: [BucketWishes] = []
    
    public func getBucketListData() -> FIRDatabaseReference {
        ref = FIRDatabase.database().reference() //Stores a link to firebase for your database.
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let children = snapshot.children

            if let dataDictionarys = snapshot.childSnapshot(forPath: "wishes") as? FIRDataSnapshot {
                
                for rest in dataDictionarys.children.allObjects as! [FIRDataSnapshot] {
                    guard let restDict = rest.value as? [String: AnyObject] else {
                        continue
                    }
                    var bucketWishes = BucketWishes.init(wish: restDict["what"] as! String,
                                                         place: restDict["where"] as! String,
                                                         when: restDict["when"] as! String,
                                                         id: rest.key as! String)

                    self.arrayOfBucketWishes.append(bucketWishes)

                }
                let bucketListData = ["BucketWishes": self.arrayOfBucketWishes]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "BucketWishesnotify"),
                                                object: self ,
                                                userInfo: bucketListData)
            } else {
                print("Error while retrieving data from Firebase")
            }
            

        })
        
        return ref.child("wishes")
    }
   
    func addChild(){
        
        // Listen for new comments in the Firebase database
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let wishObj = snapshot.value as? NSDictionary {
                let bucketWish = BucketWishes.init(wish: wishObj["what"] as! String,
                                                   place: wishObj["where"] as! String,
                                                   when: wishObj["when"] as! String,
                                                   id: snapshot.key)
                let bucketWishDict = ["AddedBucketWish": bucketWish]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "AddChild"),
                                                object: self ,
                                                userInfo: bucketWishDict)
            }
        })
        
    }
    
    func removeChild() {
        
        // TODO: Listen for deleted comments in the Firebase database
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            if let wishObj = snapshot.value as? NSDictionary {
                let wishremoved = BucketWishes.init(wish: wishObj["what"] as! String,
                                                    place: wishObj["where"] as! String,
                                                    when: wishObj["when"] as! String,
                                                    id: snapshot.key)
                let bucketRemovedDict = ["WishRemoved": wishremoved]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "removeChild"),
                                                object: self ,
                                                userInfo: bucketRemovedDict)
                
            }
        })
    }
    public func removeWish(_ newWish: BucketWishes) {

        guard let wishID = newWish.id else
        {
            print("ERROR: Trying to save empty wish!")
            return
        }
        
        ref.child("wishes").child(wishID).removeValue()
        
    }
    
    public func addWish(_ newWish: BucketWishes) {
        guard let wishID = newWish.id else
        {
            print("ERROR: Trying to save empty wish!")
            return
        }
        
        var wishObj = Dictionary<String, Any>()
        wishObj["what"] = newWish.wish ?? "something"
        wishObj["when"] = newWish.place ?? "somewhere"
        wishObj["where"] = newWish.when ?? "sometime"
        wishObj["id"] = newWish.id ?? ""

        ref.child("wishes").child(wishID).setValue(wishObj)
        

    }
}

