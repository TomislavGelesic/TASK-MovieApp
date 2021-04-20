//
//  Extensions.swift
//  TASK-NewsReader
//
//  Created by Tomislav Gelesic on 22/10/2020.
//

import UIKit


extension UIViewController {
    
    func showSpinner() {
        
        SpinnerViewManager.addSpinnerView(to: self.view)
    }
    
    func hideSpinner() {
        
        SpinnerViewManager.removeSpinnerView()
    }
    
    func showAPIFailedAlert(for errorMessage: String, completion: (() -> ())?) {
        
        let alert: UIAlertController = {
            let alert = UIAlertController(title: "Error", message: "Ups, error occured!\n\(errorMessage)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            return alert
        }()
        
        hideSpinner()
        
        present(alert, animated: true, completion: nil)
    }
}
