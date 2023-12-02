//
//  MedicamentoInfoViewController.swift
//  Salud
//
//  Created by DAMII on 2/12/23.
//

import UIKit
import Kingfisher

class MedicamentoInfoViewController: UIViewController {

    @IBOutlet weak var imagenImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var unidadesLabel: UILabel!
    
    @IBOutlet weak var contraEntregaButton: UIButton!
    @IBOutlet weak var enLineaButton: UIButton!
    
    var imagen: String?
    var nombre: String?
    var descripcion: String?
    var precio: String?
    var categoria: String?
    var unidades: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //imagenImageView.image = imagen
        if let imageURL = URL(string: imagen ?? "") {
                    imagenImageView.kf.setImage(with: imageURL)
        }
        nombreLabel.text = nombre
        descripcionLabel.text = descripcion
        precioLabel.text = precio
        categoriaLabel.text = categoria
        unidadesLabel.text = unidades
    }

    
    
    @IBAction func contraEntregaButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func enLineaButtonAction(_ sender: UIButton) {
    }
    
}
