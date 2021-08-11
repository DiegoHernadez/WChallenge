//
//  LoginViewController.swift
//  wchallenge
//
//  Created by Diego Hernandez on 9/08/21.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var textFieldName: WTextField!
    @IBOutlet weak var textFieldLasName: WTextField!
    @IBOutlet weak var textFieldEmail: WTextField!
    @IBOutlet weak var labelInvalidEmail: WLabel!
    @IBOutlet weak var switchTerms: UISwitch!
    @IBOutlet weak var logInBtn: WButton!
    @IBOutlet weak var dropdownBtn: WButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var model: LogInViewModel!
    
    private var listOfAges: [String] = []
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 10
    private var enableButtonPub: AnyCancellable?
    private var cancellableShowLoader: AnyCancellable?
    private var cancellableAlert: AnyCancellable?
    private var cancellableLogin: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.hidesWhenStopped = true
        
        for i in 5...100{
            listOfAges.append("\(i)")
        }
        
        model = LogInViewModel()
        
        textFieldName.delegate = self
        textFieldLasName.delegate = self
        textFieldEmail.delegate = self
        
        switchTerms.isOn = model.switchIsOn
        switchTerms.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        logInBtn.isEnabled = false
        logInBtn.isUserInteractionEnabled = false
        
        enableButtonPub = model.$enableButton.sink(receiveValue: { [weak self] enable in
            self?.logInBtn.isEnabled = enable
            self?.logInBtn.isUserInteractionEnabled = enable
        })
        
        cancellableShowLoader = model.$isLoading.sink(receiveValue: { [weak self] value in
            if value {
                self?.spinner.startAnimating()
            }else{
                self?.spinner.stopAnimating()
            }
        })
        
        cancellableAlert = model.$alert.sink(receiveValue: { [weak self] (alert) in
            if alert?.show ?? false{
                guard let alertAux = alert else {return}
                let alert = UIAlertController(title: "\(alertAux.message)", message: "", preferredStyle: .alert)

                if let action = alertAux.firstAction {
                    alert.addAction(UIAlertAction(title: action.title, style: .default, handler: { (_) in
                        action.handler?()
                    }))
                }
                self?.present(alert, animated: true)
            }
        })
        
        cancellableLogin = model.$loginSucces.sink(receiveValue: { [weak self] success in
            if success{
                let vc = WViewControllerFactory().createHomeVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }

    @IBAction func dropdownButtonAction(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(model.selectedRow, inComponent: 0, animated: true)
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        let alert = UIAlertController(title: "Selecciona tu edad", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = dropdownBtn
        alert.popoverPresentationController?.sourceRect = dropdownBtn.bounds
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [weak self] alertAction in
            guard let self = self else {return}
            self.model.selectedRow = pickerView.selectedRow(inComponent: 0)
            let selected = self.listOfAges[self.model.selectedRow]
            let age = selected
            self.model.ageSelected = Int(age)
            self.dropdownBtn.setTitle("\(age) año/s", for: .normal)
            self.model.verifyEnableButton()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logInBtnAction(_ sender: Any) {
        model.logIn()
    }

    @objc func switchChanged(mySwitch: UISwitch) {
        model.switchIsOn = mySwitch.isOn
        model.verifyEnableButton()
    }

}

extension LoginViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        var invalidEmail = false
        if textField == textFieldName {
            model.txtName = text
        } else if textField == textFieldLasName {
            model.txtLastName = text
        } else if textField == textFieldEmail {
            model.txtEmail = text
            invalidEmail = !model.isValidEmail(email: model.txtEmail)
        }
        labelInvalidEmail.isHidden = !invalidEmail
        model.verifyEnableButton()
        return true
    }
}

extension LoginViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        let selected = self.listOfAges[row]
        let age = selected
        label.text = age
        label.sizeToFit()
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        30
    }
}

extension LoginViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listOfAges.count
    }
    
    
}
