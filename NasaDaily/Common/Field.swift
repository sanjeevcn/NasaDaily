//
//  Field.swift
//  NasaDaily
//
//  Created by Sanjeev on 26/02/22.
//

import Foundation

enum FieldType { case date, text }

struct Field {
    let id: String
    let name: String
    var value: String
    let type: FieldType
    
    init(_ id: String = UUID().uuidString.lowercased(),
         name: String, value: String = "", type: FieldType) {
        self.id = id
        self.name = name
        self.value = value
        self.type = type
    }
}
