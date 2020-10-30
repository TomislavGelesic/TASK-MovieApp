//
//  Dates.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 27/10/2020.
//

import Foundation


class Dates: Codable {
    
    var maximum: String
    var minimum: String
    
    init(maximum: String, minimum: String) {
        self.maximum = maximum
        self.minimum = minimum
    }
    
    required init?(coder: NSCoder) {
        fatalError("Dates required init not implemented")
    }
}
