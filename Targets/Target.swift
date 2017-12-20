//
//  Target.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 18/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Target: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var desc: String
    var dueDate: String
    var photo: UIImage?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("targets")
    //MARK: Types
    
    struct PropertyKey{
        static let name = "name"
        static let desc = "desc"
        static let dueDate = "dueDate"
        static let photo = "photo"
    }
    
    //MARK: Initialisation
    
    init?(name: String, desc: String, dueDate: String, photo: UIImage?){
        self.name = name
        self.desc = desc
        self.dueDate = dueDate
        self.photo = photo
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(desc, forKey: PropertyKey.desc)
        aCoder.encode(dueDate, forKey: PropertyKey.dueDate)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name, description and due dates are required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Target object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as? String else {
            os_log("Unable to decode the description for a Target object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let dueDate = aDecoder.decodeObject(forKey: PropertyKey.dueDate) as? String else {
            os_log("Unable to decode the due date for a Target object.", log: OSLog.default, type: .debug)
            return nil
        }
        //Because photos and days remaining are optional, use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        //Must call designated initialiser
        self.init(name: name, desc: desc, dueDate: dueDate, photo: photo)
    }
    
    
}
