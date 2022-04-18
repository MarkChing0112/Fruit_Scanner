//
//  FruitAIViewController.swift
//  Fruit_Scanner
//
//  Created by MARK ching on 11/4/2022.
//

import UIKit
import CoreML
import Vision
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FruitAIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var SaveBtn: UIButton!
    @IBOutlet weak var RecordBtn: UIButton!
    //declear
    var FreshLevel : String!
    var fruit_Name : String!
    //set format
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy-HH:mm:a"
        return formatter
    }()
    let formatter2: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "MM/dd/yyyy-HH:mm"
        return formatter2
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    private var Clabel: UILabel = {
        let Clabel = UILabel()
        Clabel.textAlignment = .center
        Clabel.text = ""
        Clabel.numberOfLines = 0
        return Clabel
    }()
    
    //View didLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(imageView)
        view.addSubview(Clabel)
        // Do any additional setup after loading the view.
        //let tap = UITapGestureRecognizer(
        //    target: self,
        //    action: #selector(didTapImage)
        //)
        //tap.numberOfTapsRequired = 1
        //imageView.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(tap)
        RecordBtn.alpha = 0
    }
    
    @IBAction func TakePhotoBtnDipTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func SelectphotoBtnDidTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        label.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 100
        )
        Clabel.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+(view.frame.size.width-60)+10,
            width: view.frame.size.width-40,
            height: 100
        )
    }

    private func analyzeImage(immage: UIImage?) {
        guard let buffer = immage?.getCVPixelBuffer() else {
            return
        }
        do{
           let model = try! FruitRecognition_5(configuration: MLModelConfiguration())
           let input = FruitRecognition_5Input(image: buffer)
            
           let output = try model.prediction(input: input)
            
            //if let output = output {
            //    let results = output.classLabelProbs.sorted { $0.1 > $1.1}
            //    let result = results.map{(key, value) in
           //         return "\(key) = \(String(format: "%.2f", value * 100))%"
           //     }.joined(separator: "\n")
           //     self.label.text = result
           // }
            let probs = output.classLabelProbs[output.classLabel]
            let text = output.classLabel
            let confidence = probs ?? 0
            fruit_Name = text
            Clabel.text = "\(String(format: "%.2f",confidence * 100)) %"
            
            if (confidence < 0.2){
                FreshLevel = "Very rotten"
            }else if (confidence > 0.4 && confidence < 0.7){
                FreshLevel = "Medium fresh"
            }else if (confidence > 0.7 && confidence < 1){
                FreshLevel = "Very Fresh"
            }
            label.text = text
            //print("Fruit :\(text) && conf\(String(confidence))")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }
    //var
    var checkJPG : Bool = true
    var checkPNG : Bool = true
    //imagepicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let immage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        guard let imageData = immage.jpegData(compressionQuality: 0.8) else{

            return
        }
        guard let imageData1 = immage.pngData() else{
            return
        }
        imageView.image = immage
        analyzeImage(immage: immage)
        
        if (imageView.image == UIImage(systemName: "photo")){
            showAlert()
        }else{
            if(imageData.isEmpty){
                RecordBtn.alpha = 1
                showConfirmAlertpng(imageDataP: imageData1)
            }else{
                RecordBtn.alpha = 1
                showConfirmAlert(imageDataP: imageData)
            }
            
        }
    }
    
  //  @IBAction func SaveBtnOnTap(_ sender: Any) {
  //  if (imageView.image == UIImage(systemName: "photo")){
  //          showAlert()
  //      }else{
  //         //showConfirmAlert()
  //      }
  //  }
    
    //to RecordPage
    func toRecordPage(){
        let recordViewtableController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.recordViewtableController) as? RecordTableViewController
        
        self.view.window?.rootViewController = recordViewtableController
        self.view.window?.makeKeyAndVisible()
    }
    //Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Error!!", message: "You don't have select the image yet!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    //show recordpage alert
    func showAlerttoRecord(){
        let alert = UIAlertController(title: "save successful", message: "Do you want to record page?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.toRecordPage()}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: nil))
    }
    func showConfirmAlertpng(imageDataP: Data) {
        let alert = UIAlertController(title: "Save your fruit data", message: "Are you sure to save the fruit record", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.SaveFruitRecognitionResultpng(imageDatap: imageDataP)}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    func showConfirmAlert(imageDataP: Data) {
        let alert = UIAlertController(title: "Save your fruit data", message: "Are you sure to save the fruit record", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.SaveFruitRecognitionResult(imageDatap: imageDataP)}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    //Save jpg data to firestore
    func SaveFruitRecognitionResult(imageDatap: Data){
        //storage setup
        let storageRef = Storage.storage().reference()
        //get iamgedata from picker
        let imageData = imageDatap
        //set firestore
        let db = Firestore.firestore()
        //get record random number
        let randomint = Int.random(in:0..<100)
        //check Auth
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                //set image path
                let path = "Record/Record\(String(Int.random(in: 1..<60))).jpg"
                //set image path in firebase storage
                let Ref = storageRef.child(path)
                //upload image and record to firesotre
                //setdate
                let date = Date()
                let time1 = formatter.string(from: date)
                Ref.putData(imageData, metadata: nil){
                    _, error in
                    //check error
                    if error == nil{
                        //upload record to firebase and upload storage image path
                        db.collection(user.uid).document("\(self.fruit_Name!) \(String(randomint))").setData([
                            "FruitName": self.label.text!,
                            "fruitFreshLevel":self.Clabel.text!,
                            "lastUpdated":time1,
                            "Record_URL":path,
                            "FruitFreshLebal":self.FreshLevel!])
                        //display alert ask user to record page
                        self.showAlerttoRecord()
                    }
                }

            }
        }
        }
        //png
    func SaveFruitRecognitionResultpng(imageDatap: Data){
        //storage setup
        let storageRef = Storage.storage().reference()
        //get iamgedata from picker
        let imageData = imageDatap
        //set firestore
        let db = Firestore.firestore()
        //get record random number
        let randomint = Int.random(in:0..<100)
        //check Auth
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                //set image path
                let path = "Record/Record\(String(Int.random(in: 1..<60))).png"
                //set image path in firebase storage
                let Ref = storageRef.child(path)
                //upload image and record to firesotre
                //setdate
                let date = Date()
                let time1 = formatter.string(from: date)
                let time2 = formatter2.string(from: date)
                Ref.putData(imageData, metadata: nil){
                    _, error in
                    //check error
                    if error == nil{
                        //upload record to firebase and upload storage image path
                        db.collection(user.uid).document("\(self.fruit_Name!) \(String(randomint))").setData([
                            "FruitName": self.label.text!,
                            "fruitFreshLevel":self.Clabel.text!,
                            "lastUpdated":time1,
                            "Record_URL":path,
                            "FruitFreshLebal":self.FreshLevel!])
                        //display alert ask user to record page
                        self.showAlerttoRecord()
                    }
                }

            }
        }
        }
}
