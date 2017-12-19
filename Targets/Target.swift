//
//  Target.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 18/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import Foundation
import UIKit

class Target {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    //MARK: Initialisation
    
    init?(name: String, photo: UIImage?){
        self.name = name
        self.photo = photo
    }
}
