//
//  verProdutoViewController.swift
//  ExpiReminder
//
//  Created by Leonardo Rodrigues de Morais Brunassi on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class verProdutoViewController: UITableViewController {

    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var lblNomeProduto: UILabel!
    @IBOutlet weak var lblDataValidade: UILabel!
    @IBOutlet weak var lblDiasRestantes: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!

    var i : Int! = 0
    
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
        imgProduto.contentMode = UIViewContentMode.ScaleAspectFit
        
        var dataAgora = NSDate()
        var convert: Int = Int(dataAgora.timeIntervalSinceDate(produto[i].dataValidade))
        var diasFaltando = 1+(convert/86400)*(-1)
        
        lblDiasRestantes.text = "\(diasFaltando)"
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
    
    
    // MARK: - Table view data source
    //por conta de estar ativo ou não, temos que controlar o numero de sections e  cells, dai tem que fazer na mão, mas se não fosse isso, a propria tableview estatica da conta do trabalho
    //se esta ativo, mostra duas sections, senão só a section de ativa!

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//    }
    
    
    //controla o numero de rows, sendo que ativo mostra tudo e desativado só o UISwitch
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//
//    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */

    
}
