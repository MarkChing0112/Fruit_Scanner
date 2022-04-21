//
//  RecordViewController.swift
//  Fruit_Scanner
//
//  Created by kin ming ching on 14/4/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class RecordViewController: UIViewController {
    
    var FruitName : String!
    var Record_URL : String!
    var FruitFreshLevel : String!
    var FruitFreshLebal : String!
    var uploadDate : String!
    
    @IBOutlet weak var recordFruitNameLBL: UILabel!
    @IBOutlet weak var rocordDateLBL: UILabel!
    @IBOutlet weak var recordImageView: UIImageView!

    
    @IBOutlet weak var RecordMainImageView: UIImageView!
    @IBOutlet weak var FruitFreshLevelLBL: UILabel!
    @IBOutlet weak var FruitFreshlabelLBL: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    }
    
    func getData(){
        
        //Firebase Storage set up
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(Record_URL)
        let date = uploadDate!
        let dateFormatter = DateFormatter()
        //get label
        recordFruitNameLBL.text = FruitName
        rocordDateLBL.text = uploadDate
        FruitFreshlabelLBL.text = FruitFreshLebal
        FruitFreshLevelLBL.text = FruitFreshLevel
        //get image
        fileRef.getData(maxSize: 10*3024*4032) { Data, Error in
            if Error == nil && Data != nil {
                self.recordImageView.image = UIImage(data: Data!)
                self.RecordMainImageView.image = UIImage(data: Data!)
            }
        }
        
    }
    func tohomepage(){
        let firstPageNavigationViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationViewController) as? FirstPageNavigationViewController
        
        self.view.window?.rootViewController = firstPageNavigationViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func HomePageBtn(_ sender: Any) {
        tohomepage()
    }
}
