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
    
    var eventStore: EKEventStore!
  
    
    
    let usuarioManager = UsuarioManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventStore = EKEventStore()
        tableView.delegate = self
        tableView.dataSource = self
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        //self.tabBarController?.tabBar.hidden = false
        print(produtos.count)
    
    }

    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        self.tableView.reloadData()
    }

    
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return produtos.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        
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
        var diasFaltando: Int!
        if data == myDate {
            diasFaltando = 0
        }
        else {
            var convert: Int = Int(dataAgora.timeIntervalSinceDate(produtos[indexPath.row].dataValidade))
            diasFaltando = 1+(convert/86400)*(-1)
        }
        
        if diasFaltando < 0{
            ProdutoManager.sharedInstance.removerProduto(indexPath.row)
            self.tableView.reloadData()
        }
        else if diasFaltando == 0 {
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
            cancelarNotificacao(produtos[indexPath.row])
            excluirEventoCalendario(produtos[indexPath.row])
            ProdutoManager.sharedInstance.removerProduto(indexPath.row)
            //faltava essa linha pra não crashar mais, obs: o produto precisa estar cadastrado com notificacao on, pq falta implementar uma logica que não que o event não retorne nulo.
            produtos.removeAtIndex(indexPath.row)
        }
        
        self.tableView.reloadData()
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
