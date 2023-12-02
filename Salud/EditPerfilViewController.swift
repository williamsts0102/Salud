//
//  EditPerfilViewController.swift
//  Salud
//
//  Created by DAMII on 2/12/23.
//

import UIKit
import Alamofire

class EditPerfilViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var apellidoTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var guardarButton: UIButton!
    
    var nombreInicial: String?
    var apellidoInicial: String?
    var telefonoInicial: String?
    var emailInicial: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nombreTextField.text = llenarTextField(nombreInicial)
        apellidoTextField.text = llenarTextField(apellidoInicial)
        telefonoTextField.text = llenarTextField(telefonoInicial)
        
    }
    
    @IBAction func guardarButtonAction(_ sender: Any) {
        guard let nuevoNombre = nombreTextField.text,
                      let nuevoApellido = apellidoTextField.text,
                      let nuevoTelefono = telefonoTextField.text,
                      let nuevoEmail = emailInicial else {
                    return
                }

                let editUser = EditUserStruct(email: nuevoEmail,
                                              nombre: nuevoNombre,
                                              apellido: nuevoApellido,
                                              telefono: nuevoTelefono)

                updateUserInfo(with: editUser)
    }
    
    private func llenarTextField(_ valorInicial: String?) -> String {
        return (valorInicial == "Completa tu información") ? "" : valorInicial ?? ""
    }
    
    private func updateUserInfo(with user: EditUserStruct) {
            AF.request("https://apisalud.wendyhuaman.com/api/updateUserInfo", method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: SuccessUpdateUser.self) { response in
                switch response.result {
                case .success(let data):
                    print("Response Data: \(data)") // Muestra toda la respuesta
                    // Puedes manejar la respuesta según tus necesidades
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    // Puedes manejar el error según tus necesidades
                }
            }
    }
}
