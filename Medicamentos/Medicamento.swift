//
//  Medicamento.swift
//  Salud
//
//  Created by DAMII on 28/11/23.
//

import UIKit

struct Medicamento: Codable {
    var id: Int
    var nombre: String
    var descripcion: String
    //var imagen: Images
    var unidades: String
    var precio: Double
    var id_categoria: Int

}

