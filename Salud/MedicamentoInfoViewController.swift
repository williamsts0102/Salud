//
//  MedicamentoInfoViewController.swift
//  Salud
//
//  Created by DAMII on 2/12/23.
//

import UIKit
import Kingfisher
import Alamofire
import Toaster

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
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURL = URL(string: imagen ?? "") {
                    imagenImageView.kf.setImage(with: imageURL)
        }
        nombreLabel.text = nombre
        descripcionLabel.text = descripcion
        precioLabel.text = precio
        categoriaLabel.text = categoria
        unidadesLabel.text = unidades
        
        
        // Recuperar el email almacenado en UserDefaults
                if let storedEmail = UserDefaults.standard.string(forKey: "email") {
                    userEmail = storedEmail
                    print("Email del usuario: \(userEmail ?? "N/A")")
                } else {
                    print("No se encontró ningún email en UserDefaults")
                }
    }

    
    
    @IBAction func contraEntregaButtonAction(_ sender: UIButton) {
        // Obtén el nombre del usuario y el nombre del medicamento
            let nombreUsuario = "Nombre del Usuario"  // Reemplaza con la lógica para obtener el nombre del usuario
            let nombreMedicamento = userEmail ?? "Nombre Desconocido"

            // Construye el mensaje personalizado
            let message = "\(nombreUsuario), tu \(nombreMedicamento) está listo! Repartidor en camino. Prepara pago y comparte ubicación. Gracias"

            let phoneNumber = "+51945714598"

            let parameters: [String: Any] = [
                "phone_number": phoneNumber,
                "message": message
            ]

            // Realiza la solicitud a la API
            AF.request("https://apisalud.wendyhuaman.com/api/send-whatsapp-message", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // Muestra un cuadro de diálogo con el mensaje personalizado
                        self.mostrarAlertaContigoEnUnosSegundos()
                    case .failure(let error):
                        print("Error en la solicitud: \(error)")
                    }
                }
    }
    
    
    @IBAction func enLineaButtonAction(_ sender: UIButton) {
    }
    
    func mostrarAlertaContigoEnUnosSegundos() {
        let message = "En unos segundos nos comunicaremos contigo"
        let alertController = UIAlertController(title: "Mensaje", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Cuando el usuario presiona "OK", cierra la vista actual y navega a TiendaViewController
            self.dismiss(animated: true) {
                if let tiendaViewController = self.navigationController?.viewControllers.first(where: { $0 is TiendaViewController }) as? TiendaViewController {
                    self.navigationController?.popToViewController(tiendaViewController, animated: true)
                }
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
