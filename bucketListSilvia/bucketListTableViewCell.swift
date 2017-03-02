//
//  bucketListTableViewCell.swift
//  bucketListSilvia
//
//  Created by Jeroen de Bie on 26/02/2017.
//  Copyright © 2017 Jeroen de Bie. All rights reserved.
//

import UIKit

class bucketListTableViewCell: UITableViewCell {

    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bucketImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataForTableCell(bucketList: BucketWishes) {
        self.Title?.text = bucketList.wish
        self.textView?.text = ("\(bucketList.place!), \(bucketList.when!)")
        self.bucketImage?.image = #imageLiteral(resourceName: "images-5")
    }
    
}
