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
            
//            if let dataDictionarys = snapshot.childSnapshot(forPath: "wishes") as? FIRDataSnapshot {
            
//                print(dataDictionarys)
//                let enumerator = snapshot.children
//                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
//                    print(rest.value)
//                }
                // 3. I changed the key that we use here (the "path to child" string)
//                while let keysInHeader = dataDictionarys.children as? NSEnumerator {
//                    print(keysInHeader)
//                }
                
//                let bucketDict = dataDictionarys["BucketWishesDict"] as! NSDictionary
//                let bucketArray = bucketDict.allValues
//                let bucketlistItemsArray = BucketWishes.modelsFromDictionaryArray(array: bucketArray as NSArray)
                
//                let bucketListData = ["BucketWishes": bucketlistItemsArray]
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "BucketWishesnotify"),
//                                                object: self ,
//                                                userInfo: bucketListData)

                // 1. I called the "convertData" method only once to convert the data
                // from an array to a dictionary and put it back in Firebase
                // on a separate key ("BucketWishesDict" instead of "BucketWishes").
                // Compare the two data representations in the Firebase console
                // TODO: Jeroen go to Firebase console and delete the "BucketWishes" entry (NOT the "BucketWishesDict" one!!!)
                
                // self.convertData(bucketlistItemsArray)
//            } else {
//                print("Error while retrieving data from Firebase")
//            }
        })
        
        return ref.child("wishes")
    }
   
    public func removeWish(_ newWish: BucketWishes) {

        if newWish.id == "",
            let wish = newWish.wish {
            
            var wishObj = Dictionary<String, Any>()
            wishObj["what"] = newWish.wish! ?? "something"
            wishObj["when"] = newWish.place ?? "somewhere"
            wishObj["where"] = newWish.when ?? "sometime"
            
            ref.child("wishes").child(wish).removeValue()
        } else if let wish = newWish.id {
            var wishObj = Dictionary<String, Any>()
            wishObj["what"] = newWish.wish! ?? "something"
            wishObj["when"] = newWish.place ?? "somewhere"
            wishObj["where"] = newWish.when ?? "sometime"
            
            ref.child("wishes").child(wish).removeValue()
        }
        
    }
    
    public func addWish(_ newWish: BucketWishes) {
        guard let wishID = newWish.id else
        {
            print("ERROR: Trying to save empty wish!")
            return
        }
        
        var wishObj = Dictionary<String, Any>()
        wishObj["what"] = newWish.wish! ?? "something"
        wishObj["when"] = newWish.place ?? "somewhere"
        wishObj["where"] = newWish.when ?? "sometime"
        wishObj["id"] = newWish.id ?? ""

        ref.child("wishes").child(wishID).setValue(wishObj)
        

    }
    
//    func convertData(_ wishesArray: [BucketWishes]) {
//        var transformed = Dictionary<String, Any>()
//        
//        for wishItem in wishesArray {
//            if let wish = wishItem.wish {
//                
//                // 2. Transform the wishItem (of type BucketWishes) into a Dictionary
//                // so that Firebase can store it; provide default values for optionals
//                var wishObj = Dictionary<String, Any>()
//                wishObj["Wish"] = wishItem.wish ?? "Something"
//                wishObj["Place"] = wishItem.place ?? "Somewhere"
//                wishObj["When"] = wishItem.when ?? 2020
//                
//                transformed[wish] = wishObj
//            }
//        }
//        
//        // This is how we actually store the new dictionary of wishes
//        ref.child("BucketWishesDict").setValue(transformed)
//    }
}

