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
}






