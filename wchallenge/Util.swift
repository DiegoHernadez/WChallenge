//
//  Util.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation
import UIKit

typealias VoidCallback = () -> Void
let APIBaseUrl = "https://private-59a7d9-iostrainingapi.apiary-mock.com"
let keyForLogin = "login"

class AlertViewModel {
    
    class Action {
        init(title: String, handler: VoidCallback? = nil) {
            self.title = title
            self.handler = handler
        }
        
        var title: String
        var handler: VoidCallback?
        
    }
    
    init(show: Bool, title: String?, message: String, firstAction: Action? = nil, secondAction: Action? = nil) {
        self.show = show
        self.title = title
        self.message = message
        self.firstAction = firstAction
        self.secondAction = secondAction
    }
    
    var show: Bool
    var title: String?
    var message: String
    var firstAction: Action?
    var secondAction: Action?
}

class CellBook: UITableViewCell {
    @IBOutlet weak var titleBook: WLabel!
    @IBOutlet weak var subTitleBook: WLabel!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var cardView: UIView!
}

class DefaultCell: UITableViewCell{
    @IBOutlet var defaultImage: UIImageView!
    @IBOutlet var labelTitle: UILabel!
}

class CellHeader: UITableViewCell {
    @IBOutlet weak var titleBook: WLabel!
    @IBOutlet weak var stateBook: UILabel!
    @IBOutlet weak var authorBook: WLabel!
    @IBOutlet weak var yearBook: WLabel!
    @IBOutlet weak var genreBook: WLabel!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var addButton: WButton! {
        didSet {
            addButton.addTarget(self, action: #selector(onAddAction(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var rentButton: WButton! {
        didSet {
            rentButton.addTarget(self, action: #selector(onRentAction(_:)), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func onAddAction(_ button: WButton?) {
        addHandler?()
    }
    
    @objc fileprivate func onRentAction(_ button: WButton?) {
        rentHandler?()
    }
    
    fileprivate var addHandler: (()->Void)?
    fileprivate var rentHandler: (()->Void)?
    
    func setAddHandler(_ handler: @escaping ()->Void ) {
        addHandler = handler
    }
    
    func setRentHandler(_ handler: @escaping ()->Void ) {
        rentHandler = handler
    }
}
