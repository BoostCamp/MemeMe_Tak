//
//  SentMemesDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Peter Khotpanya on 10/28/16.
//  Copyright © 2016 Peter Khotpanya. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    @IBOutlet weak var sentMemesImageView: UIImageView?
    weak var memeImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        sentMemesImageView?.image = memeImage
    }

}
