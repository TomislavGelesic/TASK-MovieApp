//
//  Extensions.swift
//  TASK-NewsReader
//
//  Created by Tomislav Gelesic on 22/10/2020.
//

import UIKit

//MARK: Spinner Indicator

let spinnerView = SpinnerView()

extension UIViewController {
    
    func showSpinner() {
        view.addSubview(spinnerView)
        spinnerView.center = view.center
        spinnerView.startSpinner()
    }
    
    func hideSpinner() {
        spinnerView.stopSpinner()
        spinnerView.removeFromSuperview()
    }
}






