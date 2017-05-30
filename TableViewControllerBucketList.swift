//
//  TableViewControllerBucketList.swift
//  bucketListSilvia
//
//  Created by Jeroen de Bie on 12/02/2017.
//  Copyright © 2017 Jeroen de Bie. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewControllerBucketList: UITableViewController {
    
    var bucketArray: [BucketWishes] = []
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var wishTitle: UITextField!
    @IBOutlet weak var wishYear: UITextField!
    @IBOutlet weak var wishWhere: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "bucketListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "bucketListTableViewCell")
        
        // Register to receive notification data // Hieronder stemt Notification af op het keywoord "BucketWishesnotify".
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TableViewControllerBucketList.notifyObservers),
                                               name:  NSNotification.Name(rawValue: "BucketWishesnotify" ),
                                               object: nil)
        
        // Register to receive notification data // Hieronder stemt Notification af op het keywoord "BucketWishesnotify".
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TableViewControllerBucketList.addChild),
                                               name:  NSNotification.Name(rawValue: "AddChild" ),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TableViewControllerBucketList.removeChild),
                                               name:  NSNotification.Name(rawValue: "removeChild" ),
                                               object: nil)
        
        
        ref = DataProvider.sharedInstance.getBucketListData()
        DataProvider.sharedInstance.setupAddRemoveChild()
    }
    
    @IBAction func AddWish(_ sender: Any) {
        
        // TODO: add default initializer to BucketWishes class
        let wishToAdd = BucketWishes.init(wish: wishTitle.text!, place: wishYear.text!, when: wishWhere.text!, id: random())
        //adds to firebase
        DataProvider.sharedInstance.addWish(wishToAdd)
        //reloading table causes firebase to reload
        self.tableView.reloadData()
    }
    
    func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bucketArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: bucketListTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "bucketListTableViewCell", for: indexPath) as! bucketListTableViewCell
        
        let currentBucketWish = bucketArray[indexPath.row]
        
        cell.setDataForTableCell(bucketList: currentBucketWish)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPatch: IndexPath) -> CGFloat {
        return 120
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataProvider.sharedInstance.removeWish(bucketArray[indexPath.row])

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
     // MARK: - Observer functions
    
    func notifyObservers(notification: NSNotification) {
        var bucketlistDictionary: Dictionary<String,[BucketWishes]> = notification.userInfo as! Dictionary<String,[BucketWishes]>
        bucketArray = bucketlistDictionary["BucketWishes"]!
        self.tableView.reloadData()
    }
    
    func addChild(notification: NSNotification) {
        var bucketlistDictionary: Dictionary<String,BucketWishes> = notification.userInfo as! Dictionary<String,BucketWishes>
        bucketWish = bucketlistDictionary["AddedBucketWish"]!

        self.bucketArray.append(bucketWish)
        self.tableView.insertRows(at: [IndexPath(row: self.bucketArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
    func removeChild(notification: NSNotification) {
        var bucketlistDictionary: Dictionary<String,BucketWishes> = notification.userInfo as! Dictionary<String,BucketWishes>
        bucketWishRemoved = bucketlistDictionary["WishRemoved"]!

        if let index = self.indexOfWish(wishRemoved: bucketWishRemoved) {
            self.bucketArray.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func indexOfWish(wishRemoved: BucketWishes) -> Int? {
        for (index, wish) in bucketArray.enumerated() {
            if  wish.id == wishRemoved.id {
                return index
            }
        }
        return nil
    }
}
