//
//  Util.swift
//  wchallenge
//
//  Created by Diego Hernandez on 11/08/21.
//

import Foundation

typealias VoidCallback = () -> Void

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
