//
//  TabBarPage.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 29.12.2020..
//

import UIKit

enum TabBarPage {
    case Favourites
    case Watched
    case NowPlaying
    
    init? (index: Int) {
        
        switch index {
        case 0:
            self = .Favourites
        case 1:
            self = .NowPlaying
        case 2:
            self = .Watched
        default:
            return nil
        }
        
    }
    
    func getOrderNumber() -> Int {
        
        switch self {
        case .Favourites:
            return 0
        case .NowPlaying:
            return 1
        case .Watched:
            return 2
            
        }
    }
    
    func getIcon(selected: Bool) -> UIImage? {
        
        if selected {
            
            switch self {
            case .NowPlaying:
                return UIImage(systemName: "house")
            case .Favourites:
                return UIImage(systemName: "star")
            case .Watched:
                return UIImage(systemName: "checkmark.seal")
            }
            
        } else {
            
            switch self {
            case .NowPlaying:
                return UIImage(systemName: "house.fill")
            case .Favourites:
                return UIImage(systemName: "star.fill")
            case .Watched:
                return UIImage(systemName: "checkmark.seal.fill")
            }
        }
    }
    
}
