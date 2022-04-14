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
    var Fruit_NV: String!
    var Fruit_PD: String!
    var FruitImage: String!
    
    @IBOutlet weak var FruitName_lbl: UILabel!
    @IBOutlet weak var Fruit_DSClbl: UILabel!
    @IBOutlet weak var NF_LBL: UILabel!
    @IBOutlet weak var Sessionlbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
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
        
    
        FruitName_lbl.text = "Nurtrvalue Of \(FruitName!)"
        Sessionlbl.text = ""
        titleLbl.text = "Nutrition Facts of"
        Fruit_DSClbl.numberOfLines = 0
        Fruit_DSClbl.text = "\(Fruit_NV!)"
        Sessionlbl.text = Fruit_PD
        //get image
        fileRef.getData(maxSize: 1*255*255) { Data, Error in
            if Error == nil && Data != nil {
                self.FruitImageView.image = UIImage(data: Data!)
            }
        }

        
    }

}
