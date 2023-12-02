//
//  EditUserStruct.swift
//  Salud
//
//  Created by DAMII on 2/12/23.
//

import UIKit

struct EditUserStruct: Codable {
    var email:String
    var nombre:String
    var apellido:String
    var telefono:String
    var foto:String = ""
}
