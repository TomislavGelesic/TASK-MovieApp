//
//  Extensions+UITableView.swift
//  TASK-NewsReader
//
//  Created by Tomislav Gelesic on 26/10/2020.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell> (for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell.")
        }
        
        return cell
    }
}
