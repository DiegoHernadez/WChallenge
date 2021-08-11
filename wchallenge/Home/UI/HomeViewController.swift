//
//  HomeViewController.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import UIKit

class WViewControllerFactory {
    func createHomeVC() -> HomeViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        return vc
    }
}

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
