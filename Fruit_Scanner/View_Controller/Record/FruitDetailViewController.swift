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

    var FruitName: String!
    var Fruit_description: String!
    var FruitImage: String!
    
    @IBOutlet weak var FruitName_lbl: UILabel!
    @IBOutlet weak var Fruit_DSClbl: UILabel!
    @IBOutlet weak var FruitImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        GetData()
    }
    
    func GetData(){
        //Firebase Storage set up
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(FruitImage)
        
        FruitName_lbl.text = FruitName
        Fruit_DSClbl.text = Fruit_description
        fileRef.getData(maxSize: 1*255*255) { Data, Error in
            if Error == nil && Data != nil {
                self.FruitImageView.image = UIImage(data: Data!)
            }
        }

        
    }

}
