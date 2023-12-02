//
//  PerfilViewController.swift
//  Salud
//
//  Created by DAMII on 29/11/23.
//

import UIKit
import Alamofire

class PerfilViewController: UIViewController {

    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var nombreTextField: UILabel!
    @IBOutlet weak var apellidoTextField: UILabel!
    @IBOutlet weak var telefonoTextField: UILabel!
    @IBOutlet weak var editarButton: UIButton!
    
    private var user: SuccessGetUser?
    private var email: GetUserStruct!

    init(emailHome: String) {
        super.init(nibName: nil, bundle: nil)
        self.email = GetUserStruct(email: emailHome)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        title = "Perfil"
        fetchDataFromAPI()
        
    }
    
    private func fetchDataFromAPI() {
            AF.request("https://apisalud.wendyhuaman.com/api/getUserByEmail", method: .post, parameters: email, encoder: JSONParameterEncoder.default).responseDecodable(of: SuccessGetUser.self) { response in
                switch response.result {
                case .success(let data):
                    print("Response Data: \(data)") // Muestra toda la respuesta
                    self.user = data
                    self.updateUI()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

        private func updateUI() {
            // Actualiza la interfaz de usuario con los datos obtenidos
            if let user = user {
                emailTextField.text = user.email
                nombreTextField.text = user.nombre
                apellidoTextField.text = user.apellido
                telefonoTextField.text = user.telefono
                print("Email: \(user.email), Nombre: \(user.nombre), Apellido: \(user.apellido), Teléfono: \(user.telefono)")
            } else {
                print("Error: No se pudo obtener el usuario.")
            }
        }
    
    
    @IBAction func editarButtonAction(_ sender: UIButton) {
        let editPerfilVC = EditPerfilViewController()

            // Configura los valores en la vista de edición
            editPerfilVC.nombreInicial = user?.nombre
            editPerfilVC.apellidoInicial = user?.apellido
            editPerfilVC.telefonoInicial = user?.telefono
            editPerfilVC.emailInicial = user?.email

            self.navigationController?.pushViewController(editPerfilVC, animated:true)
    }
    
}
