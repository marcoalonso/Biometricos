//
//  ViewController.swift
//  Biometricos
//
//  Created by Marco Alonso Rodriguez on 20/11/22.
//

import UIKit
import LocalAuthentication
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var logitudCodigoMensajeLabel: UILabel!
    @IBOutlet weak var codigoTextField: UITextField!
    @IBOutlet weak var verCodigo: UIImageView!
    @IBOutlet weak var continuarBtn: UIButton!
    @IBOutlet weak var biometricTypeLabel: UILabel!
    @IBOutlet weak var biometricTypeButton: UIButton!
    @IBOutlet weak var faceOrTouch: UIImageView!
    
    let contexto = LAContext()
    var error: NSError? = nil
    var codigoVisible = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(teclado(notificacion:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
        codigoTextField.delegate = self
    }
    
    @objc func teclado(notificacion: Notification){
        guard let tecladoUp = (notificacion.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //Si se abre el teclado
        if notificacion.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -tecladoUp.height
        } else {
            self.view.frame.origin.y = 0 //regresar al ocultar teclado
        }
    }

    override func awakeFromNib() {
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Aceptar"
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        if contexto.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            evaluateBiometryType()
        }
        
        setupUI()
    }
    
    func setupUI(){
        logitudCodigoMensajeLabel.isHidden = true
        verCodigo.isUserInteractionEnabled = true
        verCodigo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(verPassword)))
        verCodigo.image = UIImage(systemName: "eye.slash")
        
        //Button Continuar
        continuarBtn.isHidden = true
    }
    
    @objc func verPassword(){
        codigoVisible = !codigoVisible
        if codigoVisible {
            verCodigo.image = UIImage(systemName: "eye")
            codigoTextField.isSecureTextEntry = false
        } else {
            verCodigo.image = UIImage(systemName: "eye.slash")
            codigoTextField.isSecureTextEntry = true
        }
    }
    
    func evaluateBiometryType() {
        switch contexto.biometryType {
        case .faceID:
            print("Face ID")
//            faceOrTouch.image = UIImage(named: "face")
            biometricTypeLabel.text = "Autenticar con Face ID"
            biometricTypeButton.setBackgroundImage(UIImage(named: "face"), for: .normal)
            biometricTypeButton.setBackgroundImage(UIImage(named: "face"), for: .selected)
        case .touchID:
            print("Touch ID")
//            faceOrTouch.image = UIImage(named: "touch")
            biometricTypeLabel.text = "Autenticar con Touch ID"
            biometricTypeButton.setBackgroundImage(UIImage(named: "touch"), for: .normal)
            biometricTypeButton.setBackgroundImage(UIImage(named: "touch"), for: .selected)
        case .none:
            print("No esta configurado")
            print("Iniciar sesion con contraseña")
                
        default:
            print("Desconocido")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    
    @IBAction func continuarButtonTapped(_ sender: UIButton) {
        //Avanzar o iniciar sesion
        self.performSegue(withIdentifier: "login", sender: self)
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



extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Hacer algo
        self.dismiss(animated: true)
        //ocultar teclado
        codigoTextField.endEditing(true)
    }
    
    //Evitar que el usuario no escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if codigoTextField.text != "" {
            if codigoTextField.text!.count < 6 {
                logitudCodigoMensajeLabel.isHidden = false
                continuarBtn.isHidden = true
                continuarBtn.isUserInteractionEnabled = false
                return false
            }
            logitudCodigoMensajeLabel.isHidden = true
            continuarBtn.isHidden = false
            continuarBtn.isUserInteractionEnabled = true
            return true
        } else {
            logitudCodigoMensajeLabel.isHidden = false
            continuarBtn.isHidden = true
            continuarBtn.isUserInteractionEnabled = false
            return false
        }
    }
}


