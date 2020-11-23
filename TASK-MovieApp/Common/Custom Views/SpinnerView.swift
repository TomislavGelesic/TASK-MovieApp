//
//  SpinnerView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 23.11.2020..
//

import UIKit
import SnapKit

class SpinnerView: UIView {
    
    let spinner: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .white
        view.hidesWhenStopped = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
        
        addSubview(spinner)
        
        spinner.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SpinnerView {
    
    func startSpinner(){
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        spinner.stopAnimating()
    }

}
