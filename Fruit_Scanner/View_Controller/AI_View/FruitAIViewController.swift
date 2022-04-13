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

class FruitAIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var SaveBtn: UIButton!
    //declear
    private var fruit_Name : String!
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select Image"
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
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
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
            label.text = "fruit detected:  \(text)"
            print("Fruit :\(text) && conf\(String(confidence))")
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let immage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = immage
        analyzeImage(immage: immage)
    }
    
    @IBAction func SaveBtnOnTap(_ sender: Any) {
        if (imageView.image == UIImage(systemName: "photo")){
            showAlert()
        }else{
            showConfirmAlert()
        }
    }
    
    //to RecordPage
    func toRecordPage(){
   //     let recordViewtalbeController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.recordtableViewController) as? RecordTableViewController
        
     //   self.view.window?.rootViewController = recordViewtableController
     //   self.view.window?.makeKeyAndVisible()
    }
    //Show Alert
    func showAlert() {
        let alert = UIAlertController(title: "Error!!", message: "You don't have select the image yet!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func showConfirmAlert() {
        let alert = UIAlertController(title: "Save your fruit data", message: "Are you sure to save the fruit record", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.SaveFruitRecognitionResult()}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    //Save data to firestore
    func SaveFruitRecognitionResult(){
        let db = Firestore.firestore()
        let randomint = Int.random(in:0..<100)
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                db.collection(user.uid).document("\(fruit_Name!)_\(String(randomint))").setData(["FruitName": label.text!,"fruitFreshLevel":Clabel.text!,"lastUpdated":FieldValue.serverTimestamp()])
            }
        }
        
    }
}
