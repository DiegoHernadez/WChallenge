//
//  LogInViewModel.swift
//  wchallenge
//
//  Created by Diego Hernandez on 10/08/21.
//

import Foundation
import Combine
import UIKit

class LogInViewModel: ObservableObject {
    @Published var enableButton: Bool = false
    @Published var showInvalidText: Bool = false
    @Published var isLoading: Bool = false
    @Published var loginSucces: Bool = false
    @Published var alert: AlertViewModel?
    
    var txtName: String = ""
    var txtLastName: String = ""
    var txtEmail: String = ""
    var switchIsOn: Bool = false
    var selectedRow = 0
    var ageSelected: Int?
    
    let service: LogInService
    
    private var logInPub: AnyCancellable?
    
    init() {
        service = UsersLoginApiService()
    }
    
    func verifyEnableButton(){
        var enable = true
        var invalidEmail = false
        invalidEmail = !isValidEmail(email: txtEmail)
        if txtName.isEmpty || txtLastName.isEmpty || txtEmail.isEmpty || invalidEmail || !switchIsOn || ageSelected == nil{
            enable = false
        }
        enableButton = enable
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func logIn(){
        guard let age = ageSelected else {
            return
        }
        isLoading = true
        let request = RequestLogin(name: txtName, lastname: txtLastName, email: txtEmail, age: age)
        logInPub = service.makeLogIn(request: request)
            .sink { [weak self] (tmp) in
                self?.isLoading = false
                switch tmp {
                case .failure(let err):
                    print("Error login users: \(err)")
                    self?.alert = AlertViewModel(show: true, title: "Alerta", message: err.localizedDescription, firstAction: AlertViewModel.Action(title: "Ok"))
                case .finished:
                    print("Finished login users")
                }
            } receiveValue: { [weak self] (response) in
                self?.alert = AlertViewModel(show: true, title: "", message: response.message ?? "", firstAction: AlertViewModel.Action(title: "Aceptar", handler: { [weak self] in
                    self?.loginSucces = true
                    let defaults = UserDefaults()
                    defaults.setValue(true, forKey: "login")
                }))
            }
    }
}
