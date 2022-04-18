//
//  FirstPageViewController.swift
//  Fruit_Scanner
//
//  Created by kin ming ching on 3/4/2022.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
class FirstPageViewController: UIViewController {

    @IBOutlet weak var ScanBtn: UIButton!
    @IBOutlet weak var FruitDesBtn: UIButton!
    @IBOutlet weak var RecordBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setbtnShadow()
    }
    func setbtnShadow(){
        ScanBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ScanBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        ScanBtn.layer.shadowOpacity = 1.0
        ScanBtn.layer.shadowRadius = 10
        ScanBtn.layer.masksToBounds = false
        ScanBtn.layer.cornerRadius = 4.0
        
        FruitDesBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        FruitDesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        FruitDesBtn.layer.shadowOpacity = 1.0
        FruitDesBtn.layer.shadowRadius = 10
        FruitDesBtn.layer.masksToBounds = false
        FruitDesBtn.layer.cornerRadius = 4.0
        
        RecordBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        RecordBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        RecordBtn.layer.shadowOpacity = 1.0
        RecordBtn.layer.shadowRadius = 10
        RecordBtn.layer.masksToBounds = false
        RecordBtn.layer.cornerRadius = 4.0

    }
    @IBAction func SignOutBtnOnTap(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do{
        try firebaseAuth.signOut()
              let firebaseAuth = Auth.auth()
              print("signout success")
              showAlertS()
          } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
          }
    }
    func toHomeView(){
        let loginFirstPageViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginFirstPageViewController) as? LoginFirstPageViewController
        
        view.window?.rootViewController = loginFirstPageViewController
        view.window?.makeKeyAndVisible()
    }
    func showAlertS(){
        let alert = UIAlertController(title: "SignOut Success!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: {action in self.toHomeView()}))
        present(alert, animated: true)
    }
}
