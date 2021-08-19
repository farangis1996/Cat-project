//
//  LikedPicturesVC.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
//

import UIKit

class LikedPicturesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //main collection
    @IBOutlet weak var likedCollection: UICollectionView!
    
    //initializing our localy saved images
    var arr = UserDefaults.standard.imageArray(forKey: "images")
    
    weak var delegate: LikedPicturesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        likedCollection.delegate = self
        likedCollection.dataSource = self
    }
    
    //our images count is arr
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr?.count ?? 0
    }
    
    // seting the layout of cell and putting the images into the collection
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = likedCollection.dequeueReusableCell(withReuseIdentifier: "likedCell", for: indexPath) as! LikedCollectionViewCell
        cell.collectionView.image = arr![indexPath.row]
        cell.widthAnchor.constraint(equalToConstant: (collectionView.frame.width / 2) - 10).isActive = true
        cell.heightAnchor.constraint(equalToConstant: (collectionView.frame.width / 2) - 10).isActive = true
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(deleteButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteButton(sender: UIButton){
        let buttonTag = sender.tag
        arr?.remove(at: buttonTag)
        
        //Using the delegate method
        delegate?.deleteFavourite(self, images: arr!)
        likedCollection.reloadData()
    }
    
    //Cell settings
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }
   
    
    
    
}

