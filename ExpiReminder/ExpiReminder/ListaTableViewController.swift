//
//  ListaTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 29/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class ListaTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var produtos:Array<Produto> = {
        return ProdutoManager.sharedInstance.buscarProdutos()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = false
        self.tableView.reloadData()
        print(produtos.count)
    
    }

    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
        
//        var dataString: NSString = "\(produtos[indexPath.row].dataValidade)"
//        var dateFormatter: NSDateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale.currentLocale()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        var myDate: NSDate = dateFormatter.dateFromString(dataString as String)!

        cell.lblNomeProduto.text = produtos[indexPath.row].nome
        cell.lblDataValidade.text = "8"
        cell.lblDiasRestantes.text = "3"
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
