//
//  ViewController.swift
//  Biometricos
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var faceOrTouch: UIImageView!
    
    let contexto = LAContext()
    var error: NSError? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if contexto.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            evaluateBiometryType()
        }
    }
    
    func evaluateBiometryType() {
        switch contexto.biometryType {
        case .faceID:
            print("Face ID")
            faceOrTouch.image = UIImage(named: "face")
        case .touchID:
            print("Touch ID")
            faceOrTouch.image = UIImage(named: "touch")
        case .none:
            print("No esta configurado")
            print("Iniciar sesion con contraseña")
                
        default:
            print("Desconocido")
        }
    }

    @IBAction func autenticarButton(_ sender: Any) {
        biometrics()
    }
    
    func biometrics() {
        if contexto.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reasen = "Por favor autoriza el inicio de sesion con touchID o FaceID"
            contexto.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasen) { succes, error in
                DispatchQueue.main.async {
                    guard succes, error == nil else {
                        print("error no se detecto huella o rostro")
                        return
                    }
                    //Avanzar o iniciar sesion
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
            
        }else {
            print("Error en la autenticacion, al usar biometricos")
        }
    }
    
}

