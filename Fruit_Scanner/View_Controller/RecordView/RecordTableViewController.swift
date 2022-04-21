//
//  RecordTableViewController.swift
//  Fruit_Scanner
//
//  Created by kin ming ching on 14/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RecordTableViewController: UITableViewController {

    var record = [Record]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecord()
        self.tableView.reloadData()
    }
    
    func getRecord() {
        let db = Firestore.firestore()

        //check Auth
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                db.collection(user.uid).getDocuments() {(snapshot, err) in
            
            if err == nil {
                if let snapshot = snapshot {
                    self.record = snapshot.documents.map {
                        RecordData in
                        return Record( FruitName: RecordData["FruitName"] as? String ?? "",
                                       Record_URL: RecordData["Record_URL"] as? String ?? "",
                                       FruitFreshLevel: RecordData["fruitFreshLevel"] as? String ?? "",
                                       FruitFreshLebal: RecordData["FruitFreshLebal"] as? String ?? "",
                                       uploadDate: RecordData["lastUpdated"] as? String ?? "")
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
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
        return record.count
    }
    //cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! RecordTableViewCell
        

        //get firebase storage image
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(record[indexPath.row].Record_URL)
        
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                cell2.RecordImageView.image = UIImage(data: Data!)
            }
        }

        //display firebase store data
        cell2.RecordFruitNameLBL.text = record[indexPath.row].FruitName
        cell2.RecordDateLBL.text = record[indexPath.row].uploadDate
        
        return cell2
    }
    
    // pass data to record page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RecordViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destination.FruitName = record[indexPath.row].FruitName
                destination.FruitFreshLevel = record[indexPath.row].FruitFreshLevel
                destination.FruitFreshLebal = record[indexPath.row].FruitFreshLebal
                destination.uploadDate = record[indexPath.row].uploadDate
                destination.Record_URL = record[indexPath.row].Record_URL
            }
        }
    }
    // tableView Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
