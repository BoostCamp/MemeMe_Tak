//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by 진형탁 on 2017. 1. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: - Property
    var datas: [MemeData]!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        datas = appDelegate.memeDatas
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = datas[indexPath.item]
        cell.memeImageView.image = meme.memeImage
        cell.memeLabel.text = meme.topText + " " + meme.bottomText
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "memeDetailViewSegue" {
            if let destination = segue.destination as? SentMemesDetailViewController{
                if let indexPath = tableView.indexPathForSelectedRow {
                    let meme = datas[indexPath.item]
                    destination.memeImage = meme.memeImage
                }
            }
        }
    }
}
