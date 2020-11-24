//
//  ButtonTappedDelegate.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 23.11.2020..
//

import Foundation

protocol ButtonTapped {
    func buttonTapped(for id: Int64, type: ButtonType)
}
