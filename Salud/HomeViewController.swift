//
//  HomeViewController.swift
//  Salud
//
//  Created by DAMII on 27/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

enum ProviderType:String {
    case basic
    case google
    case facebook
}

class HomeViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var closeSessionButton: UIButton!
    
    private let email:String
    private let provider: ProviderType
    
    init(email:String, provider:ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemendt")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inicio"
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        emailLabel.text = email
        providerLabel.text = provider.rawValue
        
        //GUARDAR DATOS DEL USUARIO
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        defaults.set(provider.rawValue, forKey: "provider")
        defaults.synchronize()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeSessionButtonAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "provider")
        defaults.synchronize()
        
        switch provider {
        case .basic :
            firebaseLogOut()
        case .google :
            //GIDSignIn.sharedInstance()?.inputGain.signnOut()
            firebaseLogOut()
        case .facebook :
            LoginManager().logOut()
            firebaseLogOut()
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func firebaseLogOut(){
        do{
            try Auth.auth().signOut()
        } catch {
            //error
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
