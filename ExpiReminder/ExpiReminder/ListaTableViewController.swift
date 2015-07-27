//
//  ListaTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 29/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class ListaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
        lazy var produtos:Array<Produto> = {
        return ProdutoManager.sharedInstance.buscarProdutos()
        }()
    
    let usuarioManager = UsuarioManager.sharedInstance
    let notifManager = NotifManager.sharedInstance
    
    var diasFaltando: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        print(produtos.count)
    
    }

    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        var dataAgora = NSDate()
        for var i = 0; i<produtos.count;{
            var dateComparisionResult:NSComparisonResult = dataAgora.compare(produtos[i].dataValidade)

            if dateComparisionResult == NSComparisonResult.OrderedDescending && dateComparisionResult != NSComparisonResult.OrderedSame {
                if usuarioManager.getAlerta() == true {
                    self.notifManager.cancelarNotificacao(produtos[i])
                }
                self.notifManager.excluirEventoCalendario(produtos[i])
                ProdutoManager.sharedInstance.removerProduto(i)
                produtos.removeAtIndex(i)
            }
            ++i
        }
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return produtos.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell: ProdutosTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellProduto", forIndexPath: indexPath) as! ProdutosTableViewCell
        
        let dataString: String = "\(produtos[indexPath.row].dataValidade)"
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let myDate: String = dateFormatter.stringFromDate(produtos[indexPath.row].dataValidade)
        let data: String = dateFormatter.stringFromDate(NSDate())
        
        
        cell.lblNomeProduto.text = produtos[indexPath.row].nome
        cell.lblDataValidade.text = "\(myDate)"
        
        var dataAgora = NSDate()
        print("\(data)")
        print("\(myDate)")
        
        if data == myDate {
            diasFaltando = 0
        }
        else {
            var convert: Int = Int(dataAgora.timeIntervalSinceDate(produtos[indexPath.row].dataValidade))
            diasFaltando = 1+(convert/86400)*(-1)
        }
        
        if diasFaltando == 0 {
            cell.lblDiasRestantes.text = "Vence hoje!"
            cell.lblDiasRestantes.font = UIFont(name: cell.lblDiasRestantes.font.fontName, size: 15)
            cell.lblDiasRestantes.textColor = UIColor.redColor()
        }
        else if diasFaltando == 1 {
            cell.lblDiasRestantes.text = "Vence amanhã!"
            cell.lblDiasRestantes.font = UIFont(name: cell.lblDiasRestantes.font.fontName, size: 15)
            cell.lblDiasRestantes.textColor = UIColor.redColor()
        } else {
            cell.lblDiasRestantes.text = "\(diasFaltando) dias para vencer!"
            cell.lblDiasRestantes.font = UIFont(name: cell.lblDiasRestantes.font.fontName, size: 14)
            cell.lblDiasRestantes.textColor = UIColor.blueColor()
        }
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "verProduto" {
            let VC = segue.destinationViewController as! verProdutoViewController
            let cell = sender as? UITableViewCell
            VC.i = tableView.indexPathForCell(cell!)!.row
        }
    }

    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if usuarioManager.getAlerta() == true {
                self.notifManager.cancelarNotificacao(produtos[indexPath.row])
            }
            self.notifManager.excluirEventoCalendario(produtos[indexPath.row])
            ProdutoManager.sharedInstance.removerProduto(indexPath.row)
            //faltava essa linha pra não crashar mais, obs: o produto precisa estar cadastrado com notificacao on, pq falta implementar uma logica que não que o event não retorne nulo.
            produtos.removeAtIndex(indexPath.row)
        }
        
        self.tableView.reloadData()
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
