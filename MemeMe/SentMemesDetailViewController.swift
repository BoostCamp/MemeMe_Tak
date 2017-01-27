//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by 진형탁 on 2017. 1. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SentMemesDetailViewController: UIViewController {
    
    // MARK: Property
    @IBOutlet weak var sentMemesImageView: UIImageView?
    weak var memeImage: UIImage?

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sentMemesImageView?.image = memeImage
    }

}
