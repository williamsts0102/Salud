//
//  AuthViewController.swift
//  Salud
//
//  Created by DAMII on 27/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import FacebookLogin
import Alamofire

class AuthViewController: UIViewController {

    @IBOutlet weak var authStackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login"
        
        //COMPROBAR LA SESION DEL USUARIO AUTENTICADO
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String,
        let provider = defaults.value(forKey: "provider") as? String{
            
            authStackView.isHidden = true
            
            navigationController?.pushViewController(HomeViewController(email: email, provider: ProviderType.init(rawValue: provider)!), animated: false)
        }
        
        // Google Auth
        //GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authStackView.isHidden = false
        
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    // Llamar a la función registerUser después de que el usuario se ha registrado con éxito
                    if error == nil, let result = result {
                        // Crear un objeto RegisterUserStruct con la información del usuario recién registrado
                        let registerUserObj = RegisterUserStruct(email: email, password: password)
                        
                        // Llamar a la función registerUser con el objeto creado
                        self.registerUser(obj: registerUserObj)
                    }
                    self.showHome(result: result, error: error, provider: .basic)
                    
                }
            }
        
    }
    
    @IBAction func logInButtonAction(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password){
                (result, error) in
                
                self.showHome(result: result, error: error, provider: .basic)
            }
        }
    }
    
    
    @IBAction func googleButtonAction(_ sender: UIButton) {
        //GIDSignIn.sharedInstance()?.signIn()
        let email:String
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard error == nil, let self = self else { return }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            
            // Save user info to UserDefaults
            /*
            let defaults = UserDefaults.standard
            defaults.set(result?.user.profile?.email, forKey: "email")
            defaults.set("google", forKey: "provider")
             */
            Auth.auth().signIn(with: credential){(result, error) in
                self.showHome(result: result, error: error, provider: .google)
            }
        }
        
    }
    
    private func showHome(result: AuthDataResult?, error: Error?, provider: ProviderType){
        
        if let result = result, error == nil {
            
            self.navigationController?.pushViewController(HomeViewController(email: result.user.email!, provider: provider), animated: true)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Se ha producito un error autenticacion mediante \(provider.rawValue)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true,completion: nil)
        }
    }
    
    
    @IBAction func facebookButtonAction(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self){
        (result) in
            switch result {
            case .success(granted: let granted, declined: let declined, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                Auth.auth().signIn(with: credential){ (result, error) in
                    self.showHome(result: result, error: error, provider: .facebook)
                    
                }
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
        
    }
    
    func registerUser(obj: RegisterUserStruct) {
        AF.request("https://apisalud.wendyhuaman.com/api/register", method: .post, parameters: obj, encoder: JSONParameterEncoder.default)
            .response(completionHandler: { data in
                switch data.result{
                case .success(let info):
                    do{
                        let result = try JSONDecoder().decode(SuccesRegisterUser.self, from: info!)
                    }catch{
                        print("error en el json registra: \(error)")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            })
    }
    
}

