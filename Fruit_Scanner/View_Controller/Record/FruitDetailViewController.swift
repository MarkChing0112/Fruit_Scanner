//
//  FruitDetailViewController.swift
//  Fruit_Scanner
//
//  Created by kin ming ching on 13/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FruitDetailViewController: UIViewController {

    var FruitName: String?
    var Fruit_description: String?
    var FruitImage: String?
    
    @IBOutlet weak var FruitName_lbl: UILabel!
    @IBOutlet weak var Fruit_DSClbl: UILabel!
    @IBOutlet weak var FruitImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let storage = Storage.storage()
        super.viewWillAppear(animated)
        
    }
    
    func GetData(){
        //Firebase Storage set up
        let storageRef = storage.reference()
        
        FruitName_lbl.text = FruitName
        Fruit_DSClbl.text = Fruit_description
        let url = FruitImage
        
    }

}
