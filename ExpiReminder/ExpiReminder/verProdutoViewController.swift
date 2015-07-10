//
//  verProdutoViewController.swift
//  ExpiReminder
//
//  Created by Leonardo Rodrigues de Morais Brunassi on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class verProdutoViewController: UITableViewController {

    @IBOutlet weak var imgProduto: UIImageView!
    @IBOutlet weak var lblNomeProduto: UILabel!
    @IBOutlet weak var lblDataValidade: UILabel!
    @IBOutlet weak var lblDiasRestantes: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    var eventStore: EKEventStore!

    var i : Int! = 1
    
    var produto: Array<Produto>!
    
    let usuarioManager = UsuarioManager.sharedInstance
    
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
            VC.produto = produto?[i]
        }
    }

    
    
    
    func alert(){
        let alerta: UIAlertController = UIAlertController(title: "Atenção!", message: "Você tem certeza que deseja apagar este produto?", preferredStyle: .Alert)
        
        let ok: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            self.cancelarNotificacao(self.produto[self.i])
            self.excluirEventoCalendario(self.produto[self.i])
            ProdutoManager.sharedInstance.removerProduto(self.i)
            
            //self.produto.removeAtIndex(self.i)
            
            //ProdutoManager.sharedInstance.salvarProduto()
            self.navigationController?.popViewControllerAnimated(true)
        }
        alerta.addAction(ok)
        
        let cancelar: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Default) { action -> Void in
        }
        alerta.addAction(cancelar)
        self.presentViewController(alerta, animated: true, completion: nil)
    }

    
    
    
    @IBAction func btnApagar(sender: AnyObject) {
        alert()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func cancelarNotificacao(prod: Produto) {
        for i in 0...usuarioManager.getDiasAlerta() {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Produto vencendo"
            var diasRestantes = 7 - i
            var strNotif = "\(prod.nome)"
            if diasRestantes == 0 {
                localNotification.alertBody = "'\(strNotif)' vai vencer hoje!"
            }
            else if diasRestantes == 1 {
                localNotification.alertBody = "'\(strNotif)' vai vencer amanhã!"
            }
            else {
                localNotification.alertBody = "Faltam \(diasRestantes) dias para '\(strNotif)' vencer!"
            }
            
            let dateFix: NSTimeInterval = floor(prod.dataValidade.timeIntervalSinceReferenceDate / 60.0) * 60.0 * 24
            var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
            
            let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = 1
            
            localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
            UIApplication.sharedApplication().cancelLocalNotification(localNotification)
        }
    }
    
    func excluirEventoCalendario(prod: Produto){
        var endData: NSDate = NSDate(timeInterval: 3600, sinceDate: prod.dataValidade)
        var predicate = eventStore.predicateForEventsWithStartDate(prod.dataValidade, endDate: endData, calendars:[eventStore.defaultCalendarForNewEvents])
        var eventos = eventStore.eventsMatchingPredicate(predicate)
        eventStore.removeEvent((eventos.last as! EKEvent), span: EKSpanThisEvent, error: NSErrorPointer())
        
        
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
