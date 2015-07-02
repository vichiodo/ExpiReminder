//
//  UsuarioManager.swift
//  ExpiReminder
//
//  Created by Rafael  Hieda on 02/07/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class UsuarioManager: NSObject {
   static let sharedInstance = UsuarioManager()
    
    func setAlerta(sender:Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender, forKey: "alertaStatus")
    }
    
    func getAlerta() ->Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let status = defaults.boolForKey("alertaStatus")
        return status
    }
    
    func setDiasAlerta(sender:Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(sender, forKey: "diasAlerta")
    }
    
    func getDiasAlerta() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey("diasAlerta") as Int
    }
    
}
