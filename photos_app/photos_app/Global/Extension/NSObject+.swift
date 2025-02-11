//
//  NSObject.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//


import Foundation

extension NSObject {

    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}
