//
//  ViewController.swift
//  Webflix
//
//  Created by K on 19/09/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    var searchValue = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self



        view.addGestureRecognizer(UIGestureRecognizer(target:self, action:#selector(hideKeyboard)))    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func searchFIeldAction(_ sender: UITextField) {
        searchValue = searchField.text ?? ""
        getMovies()
    }
    
    
    func getMovies(){
        let url = "https://www.omdbapi.com/?s=\(searchValue)&apikey=c6c2a5e9"
        
        print(url)
    }
}



extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

