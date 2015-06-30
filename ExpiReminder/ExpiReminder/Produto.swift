//
//  Produto.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import Foundation
import CoreData

class Produto: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var dataValidade: NSDate
    @NSManaged var codigoBarra: String
    @NSManaged var diasFaltando: NSNumber
    @NSManaged var foto: NSData

}
