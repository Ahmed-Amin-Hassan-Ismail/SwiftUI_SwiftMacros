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

enum URLMacroError: CustomStringConvertible, Error {
    
    case requiresStaticStringLiteral
    case malforedURL(urlString: String)
    
    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case .malforedURL(let urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}
