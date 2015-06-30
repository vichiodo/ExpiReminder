//
//  AddProdutoTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class AddProdutoTableViewController: UITableViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var imagem: UIImageView!
    
    var eventStore: EKEventStore = EKEventStore()
    
    let imagePicker: UIImagePickerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
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
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var imagemProduto:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagem.image = imagemProduto
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func codigoBarra(sender: AnyObject) {
        
    }
    
    @IBAction func salvar(sender: AnyObject) {
        
        
        
        
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
            var diasFaltando = convert - 86400
    

            ProdutoManager.sharedInstance.salvarNovoProduto(txtNome.text, foto: imagem.image!, data: datePicker.date, codigoBarra: "", diasFaltando: diasFaltando)
            criarNotificacao(ProdutoManager.sharedInstance.buscarProdutoNome(txtNome.text))
            criarEventoCalendario(ProdutoManager.sharedInstance.buscarProdutoNome(txtNome.text))
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }
    
    
    func notif(prod: Produto, i: Int) -> UILocalNotification{
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Produto vencendo"
        //falta pegar a quantidade na tela de configurações
        var diasRestantes = 7 - i
        var strNotif = "\(prod.nome)"
        if diasRestantes == 0 {
            localNotification.alertBody = "'\(strNotif)' vai vencer hoje!"
        }
        else if diasRestantes == 1 {
            localNotification.alertBody = "Falta \(diasRestantes) dia para '\(strNotif)' vencer!"
        }
        else {
            localNotification.alertBody = "Faltam \(diasRestantes) dias para '\(strNotif)' vencer!"
        }
        
        let dateFix: NSTimeInterval = floor(prod.dataValidade.timeIntervalSinceReferenceDate / 60.0) * 60.0
        var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
        
        let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
        
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = 1
        
        localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
        return localNotification
    }
    
    func criarNotificacao(prod: Produto) {
        for i in 0...7 {
            UIApplication.sharedApplication().scheduleLocalNotification(notif(prod, i: i))
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
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
