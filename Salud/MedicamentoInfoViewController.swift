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
    
    var id:Int?
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
        let parameters: [String: Any] = [
                "email": userEmail,
                "id": id
            ]

            // Realiza la solicitud a la API
            AF.request("https://apisalud.wendyhuaman.com/api/send-whatsapp-message", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        // Maneja la respuesta de la API
                        if let jsonResponse = try? response.result.get() as? [String: Any],
                           let message = jsonResponse["message"] as? String {
                            // Muestra un cuadro de diálogo con el mensaje personalizado
                            self.mostrarAlertaConMensaje(message)
                        } else {
                            // Respuesta inesperada del servidor
                            self.mostrarAlertaConMensaje("Respuesta inesperada del servidor")
                        }
                    case .failure(let error):
                        // Muestra detalles del error en caso de fallo
                        print("Error en la solicitud: \(error)")
                        self.mostrarAlertaConMensaje("Error en la solicitud: \(error.localizedDescription)")
                    }
                }
    }
    
    
    @IBAction func enLineaButtonAction(_ sender: UIButton) {
    }
    
    func mostrarAlertaConMensaje(_ message: String) {
        let alertController = UIAlertController(title: "Mensaje", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Cuando el usuario presiona "OK", decide a qué vista navegar
            self.dismiss(animated: true) {
                if message == "En unos segundos nos comunicaremos contigo" {
                    // Navega a TiendaViewController
                    if let tiendaViewController = self.navigationController?.viewControllers.first(where: { $0 is TiendaViewController }) as? TiendaViewController {
                        self.navigationController?.popToViewController(tiendaViewController, animated: true)
                    }
                } else {
                    // Navega a PerfilViewController
                    if let perfilViewController = self.navigationController?.viewControllers.first(where: { $0 is PerfilViewController }) as? PerfilViewController {
                        self.navigationController?.popToViewController(perfilViewController, animated: true)
                    }
                }
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
