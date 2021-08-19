//
//  LikedCollectionViewCell.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
//
//  Sources used: https://developer.apple.com/documentation/uikit/uicollectionviewcell
// https://stackoverflow.com/questions/39438803/how-to-create-uicollectionviewcell-programmatically

import UIKit

class LikedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var collectionView: UIImageView!
    
    let arr = UserDefaults.standard.imageArray(forKey: "images")
    
    @IBAction func removeImage(_ sender: Any) {
        
    }
}
