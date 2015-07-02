//
//  ConfigTableViewController.swift
//  ExpiReminder
//
//  Created by Rafael  Hieda on 02/07/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class ConfigTableViewController: UITableViewController {
    
    //flag pra indicar se o switch de ativo ou não funciona!
    var estaAtivo:Bool!
    
    //indicador de dias
    @IBOutlet weak var diasAlertaLabel: UILabel!
    
    //switch de ativo ou não
    @IBAction func alertaSwitch(sender: AnyObject) {
        var mySwitch = sender as! UISwitch
            estaAtivo = mySwitch.on
        
        self.tableView.reloadData()
    }
    
    //slider que controla a quantidade de dias
    @IBAction func diasSlider(sender: AnyObject) {
        println(sender.value as Float)
        diasAlertaLabel.text = "\(Int(round(sender.value as Float)))"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estaAtivo = true
        
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    //por conta de estar ativo ou não, temos que controlar o numero de sections e  cells, dai tem que fazer na mão, mas se não fosse isso, a propria tableview estatica da conta do trabalho
    //se esta ativo, mostra duas sections, senão só a section de ativa!
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if estaAtivo == true {
            return 2
        }
        else {
            return 1
        }
    }
    
    
    //controla o numero de rows, sendo que ativo mostra tudo e desativado só o UISwitch
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if estaAtivo == true {
            switch section{
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 0
            }
        }
        else {
            switch section{
            case 0:
                return 1
            case 1:
                return 0
            default:
                return 0
            }
        }
    }


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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
