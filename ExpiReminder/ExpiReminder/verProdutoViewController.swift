//
//  verProdutoViewController.swift
//  ExpiReminder
//
//  Created by Leonardo Rodrigues de Morais Brunassi on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class verProdutoViewController: UIViewController {

    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var lblNomeProduto: UILabel!
    @IBOutlet weak var lblDataValidade: UILabel!
    @IBOutlet weak var lblDiasRestantes: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
