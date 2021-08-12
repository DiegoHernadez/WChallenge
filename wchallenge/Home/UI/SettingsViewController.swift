//
//  SettingsViewController.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logOutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "¿Estás seguro de cerrar sesión?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: { (_) in
            let defaults = UserDefaults()
            defaults.setValue(false, forKey: keyForLogin)
            let vc = UINavigationController(rootViewController: WViewControllerFactory().createLoginVC())
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }))
        self.present(alert, animated: true)
    }
}
