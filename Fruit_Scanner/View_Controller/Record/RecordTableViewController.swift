//
//  RecordTableViewController.swift
//  Fruit_Scanner
//
//  Created by Mark Ching on 13/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
class RecordTableViewController: UITableViewController {
    //refer to Fruit object file
    var fruit = [Fruit]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFruitDetail()
        self.tableView.reloadData()
    }
    
    func getFruitDetail() {
        let db = Firestore.firestore()
        
        db.collection("Fruit_description").getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.fruit = snapshot.documents.map {
                        Fruitdata in
                        return Fruit(Fruit1: Fruitdata["Fruit_Name"] as? String ?? "",
                                     Fruit_Description: Fruitdata["Fruit_Description"] as? String ?? "",
                                     Fruit_URL: Fruitdata["Fruit_URL"] as? String ?? "" )
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fruit.count
    }
    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  RecordTableViewCell
        //get firebase storage image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(fruit[indexPath.row].Fruit_URL)
        
        fileRef.getData(maxSize: 1*80*80) { Data, Error in
            if Error == nil && Data != nil {
                    cell.FruitImage.image = UIImage(data: Data!)
            }
        }
                    
        //display firebase store data
        cell.FruitName.text = fruit[indexPath.row].Fruit1

        
        return cell
    }
    
    // pass data to record page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FruitDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.FruitName = fruit[indexPath.row].Fruit1
                destination.Fruit_description = fruit[indexPath.row].Fruit_Description
                destination.FruitImage = fruit[indexPath.row].Fruit_URL
                
            }
        }
    }
    // tableView Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
