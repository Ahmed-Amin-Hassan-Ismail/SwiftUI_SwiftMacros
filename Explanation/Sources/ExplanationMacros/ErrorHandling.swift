//
//  File.swift
//  
//
//  Created by Ahmed Amin on 11/10/2023.
//

import Foundation


enum StructInitError: CustomStringConvertible, Error {
    
    case onlyApplicableToStruct
    
    var description: String {
        switch self {
        case .onlyApplicableToStruct: return "@StructInit can only be applied to a structure"
        }
    }
}


enum EnumInitError: CustomStringConvertible, Error {
    
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "@EnumInit can only be applied to a enumeration"
        }
    }
}
