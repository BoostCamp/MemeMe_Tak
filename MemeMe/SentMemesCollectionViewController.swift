//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by 진형탁 on 2017. 1. 27..
//  Copyright © 2017년 boostcamp. All rights reserved.
//


import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {

    // MARK: Property
    var memes: [MemeData]!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memeDatas
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Configure the cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.item]
        cell.sentMemesImageView.image = meme.memeImage
 
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "sentMemesDetailViewSegue" {
            if let destination = segue.destination as? MemeDetailViewController{
                if let indexPaths = collectionView?.indexPathsForSelectedItems {
                    if let indexPath = indexPaths.first{
                        let meme = memes[indexPath.item]
                        destination.memeImage = meme.memeImage
                    }
                }
            }
        }
    }

}
