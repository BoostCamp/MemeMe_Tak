//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by 진형탁 on 2017. 1. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: Property
    var memes: [MemeData]!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memeDatas
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell

        let meme = memes[indexPath.item]
        cell.sentMemesImageView.image = meme.memeImage
        cell.sentMemesLabel.text = meme.topText + " " + meme.bottomText
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "sentMemesDetailViewSegue" {
            if let destination = segue.destination as? MemeDetailViewController{
                if let indexPath = tableView.indexPathForSelectedRow {
                    let meme = memes[indexPath.item]
                    destination.memeImage = meme.memeImage
                }
            }
        }
    }

}
