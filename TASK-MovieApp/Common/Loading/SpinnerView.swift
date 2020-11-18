//
//  SpinnerView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import UIKit

class SpinnerView: UIView {
    
    let spinner: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.style = .large
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(spinner)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startSpinner(){
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        spinner.stopAnimating()
    }

}
