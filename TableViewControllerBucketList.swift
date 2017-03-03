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
    @IBAction func AddWish(_ sender: Any) {
        
//        bucketListSilvia.append(TextFieldOutlet.text!)
        
        // TODO: add default initializer to BucketWishes class
//        var wishToAdd = BucketWishes()
//        wishToAdd.wish = TextFieldOutlet.text
//        wishToAdd.place = TODO
//        wishToAdd.when = TODO
//        
//        DataProvider.sharedInstance.addWish(wishToAdd)
        self.tableView.reloadData()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "bucketListTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "bucketListTableViewCell")
        
        // Register to receive notification data // Hieronder stemt Notification af op het keywoord "BucketWishesnotify".
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TableViewControllerBucketList.notifyObservers),
                                               name:  NSNotification.Name(rawValue: "BucketWishesnotify" ),
                                               object: nil)
        
        ref = DataProvider.sharedInstance.getBucketListData()
        self.addRemoveChild()
    }
    
    func notifyObservers(notification: NSNotification) {
        var bucketlistDictionary: Dictionary<String,[BucketWishes]> = notification.userInfo as! Dictionary<String,[BucketWishes]>
        bucketArray = bucketlistDictionary["BucketWishes"]! //showFestivalsOnMap()
        
        tableView.reloadData()
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
            bucketArray.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func addRemoveChild(){
        
        // Listen for new comments in the Firebase database
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            if let wishObj = snapshot.value as? NSDictionary {
                if let wishAdded = BucketWishes(dictionary: wishObj) {
                    self.bucketArray.append(wishAdded)
                    
                    self.tableView.insertRows(at: [IndexPath(row: self.bucketArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
                }
            }
        })
        
        // TODO: Listen for deleted comments in the Firebase database
        /*ref.observe(.childRemoved, with: { (snapshot) -> Void in
         // TODO: add "indexOfWish" method to the view controller
            let index = self.indexOfWish(snapshot)
            self.comments.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        })*/
    }
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
