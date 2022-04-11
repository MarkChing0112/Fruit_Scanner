//
//  FruitAIViewController.swift
//  Fruit_Scanner
//
//  Created by MARK ching on 11/4/2022.
//

import UIKit
import CoreML
import Vision

class FruitAIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
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
    private let Clabel: UILabel = {
        let Clabel = UILabel()
        Clabel.textAlignment = .center
        Clabel.text = ""
        Clabel.numberOfLines = 0
        return Clabel
    }()
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
        guard let buffer = immage?.resize(size: CGSize(width: 299, height: 299))?
                .getCVPixelBuffer() else {
            return
        }
        
        do{
            
            let config = MLModelConfiguration()
            let model = try FruitRecognition_5(configuration: config)
            let input = FruitRecognition_5Input(image: buffer)
            
            
            let output = try model.prediction(input: input)
            let probs = output.classLabelProbs[output.classLabel]
            let text = output.classLabel
            let confidence = probs ?? 0
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


}
