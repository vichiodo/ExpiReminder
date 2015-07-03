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
    
    var i : Int!
    
    var produto: Array<Produto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preencherLabel()

    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func preencherLabel() {
        produto = ProdutoManager.sharedInstance.buscarProdutos()
        lblNomeProduto.text = produto[i].nome
        
        var dataValidade = NSDateFormatter()
        dataValidade.dateFormat = "dd/MM/yyyy"
        var dataString = dataValidade.stringFromDate(produto[i].dataValidade)
        
        lblDataValidade.text = dataString
        imgProduto.image = UIImage(data: produto[i].foto)
        lblDiasRestantes.text = "\(produto[i].diasFaltando)"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editarProduto" {
            let VC = segue.destinationViewController as! AddProdutoTableViewController
//            VC.produto = produto?[i]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
