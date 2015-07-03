//
//  AddProdutoTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class AddProdutoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var imagem: UIImageView!
    
    var eventStore: EKEventStore = EKEventStore()
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    var produto: Produto!
    
    var codigoBarras:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recebeCodigoBarras:", name: "barCode", object: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */
    
    @IBAction func camera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }
        else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var imagemProduto:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagem.image = imagemProduto
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func codigoBarra(sender: AnyObject) {
        let barCodeVC = BarCodeViewController()
        self.navigationController?.pushViewController(barCodeVC, animated: true)
    }
    
    @IBAction func salvar(sender: AnyObject) {
        
        var produto = ProdutoManager.sharedInstance.novoProduto()
        
        if txtNome.text == nil || txtNome.text == ""{
            let alerta: UIAlertController = UIAlertController(title: "Nome faltando", message: "Digite o nome do produto", preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                txtNome.becomeFirstResponder()
            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else{
            var dataAgora = NSDate()
            var convert: Int = Int(dataAgora.timeIntervalSinceDate(datePicker.date))
            var diasFaltando = 1+(convert/86400)*(-1)
    
            produto.nome = txtNome.text
            produto.dataValidade = datePicker.date
            produto.diasFaltando = diasFaltando
            produto.foto = UIImageJPEGRepresentation(imagem.image, 1)
            //produto.codigoBarra = codigoBarras
            ProdutoManager.sharedInstance.salvarProduto()
            
            criarNotificacao(produto)
            criarEventoCalendario(produto)
                        
            self.tabBarController?.tabBar.hidden = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    func criarNotificacao(prod: Produto) {
        for i in 0...7 {
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
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }

    }
    
    func criarEventoCalendario(prod: Produto){
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(prod.nome)"
        evento.startDate = prod.dataValidade
        evento.endDate = NSDate(timeInterval: 3600, sinceDate: evento.startDate)
        
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error NSError) -> Void in
            if !granted {
                return
            } else {
                evento.calendar = self.eventStore.defaultCalendarForNewEvents
                
                self.eventStore.saveEvent(evento, span: EKSpanThisEvent, commit: true, error: NSErrorPointer())
            }
        })
    }
    
    func recebeCodigoBarras(notification:NSNotification) {
        var userInfo:NSDictionary = notification.userInfo!
        var barCode:String = userInfo.objectForKey("barCode") as! String
        codigoBarras = barCode
        println("meu Codigo de barras: \(codigoBarras)")
        
    }
    
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
