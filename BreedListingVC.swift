//
//  BreedListingVC.swift
//  Cat Project
//
//  Created by Farangis Akhmedova on 14/04/2021.
//

import UIKit

class BreedListingVC: UIViewController {
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    var arry = [cats.Cat]()
    
    // main tableview
    @IBOutlet weak var breedTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.breedTable.dataSource = self
        self.breedTable.delegate = self
        
        //getting the list of breeds from API
        
        catsManager.instance.getData { (result) in
            self.arry = result ?? []
            
            DispatchQueue.main.async {
                self.breedTable.reloadData()
                self.activity.isHidden = true
            }
           
        }
        
    }
    
    
    
}
extension BreedListingVC: UITableViewDataSource, UITableViewDelegate{
    
    
    
    //The count of our array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arry.count
    }
    
    //putting the API data into the cell labels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedCell", for: indexPath as IndexPath)
        cell.textLabel!.text = arry[indexPath.row].name
        return cell
    }
    
    //when a cell is selected perform an action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "sendSegue", sender: self)
    }
    
    //when a cell is selected go to the other screen with specific data refered to the cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendSegue"{
            let indexPaths = self.breedTable.indexPathForSelectedRow!
            _ = indexPaths[0]
            let vc = segue.destination as! DetailBreedVC
            vc.detail = arry[indexPaths.row].welcomeDescription!
            vc.imageUrl = (arry[indexPaths.row].image?.url)!
        }
    }
    
}

