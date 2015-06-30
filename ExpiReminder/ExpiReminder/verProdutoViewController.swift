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
    
    var produto: Array<Produto>!
    var i: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        preencherLabel()
    }
    
    func preencherLabel() {
        produto = ProdutoManager.sharedInstance.buscarProdutos()
        lblNomeProduto.text = produto[i].nome
        lblDataValidade.text = "\(produto[i].dataValidade)"
        lblDiasRestantes.text = "\(produto[i].diasFaltando)"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editarProduto" {
            let VC = segue.destinationViewController as! AddProdutoTableViewController
            VC.produto = produto?[i]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
