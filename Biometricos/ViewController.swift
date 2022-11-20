//
//  ViewController.swift
//  Biometricos
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func autenticarButton(_ sender: Any) {
        biometrics()
    }
    
    func biometrics() {
        let contexto = LAContext()
        var error: NSError? = nil
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

