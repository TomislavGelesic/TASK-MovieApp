//
//  Extensions+UITableView.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 12/11/2020.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell> (for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell.")
        }
        
        return cell
    }
}
