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
    
    private var myData: [Medicamento] = []
    private var medicamento: Medicamento?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Perfil"
        fetchDataFromAPI()
        
    }
    
    private func fetchDataFromAPI() {
        AF.request("https://apisalud.wendyhuaman.com/api/listMedicamentos").responseDecodable(of: SuccessListMedicamento.self) { response in
            switch response.result {
            case .success(let data):
                self.myData = data.medicamentos
                                if self.myData.count > 1 {
                                    self.medicamento = self.myData[1]
                                    self.updateUI()
                                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func updateUI() {
           // Actualiza la interfaz de usuario con los datos obtenidos
           emailTextField.text = medicamento?.nombre
           // Puedes agregar más actualizaciones de UI según sea necesario
       }
    
}
