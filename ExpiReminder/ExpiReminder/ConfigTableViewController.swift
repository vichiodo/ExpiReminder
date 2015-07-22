//
//  ConfigTableViewController.swift
//  ExpiReminder
//
//  Created by Rafael  Hieda on 02/07/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class ConfigTableViewController: UITableViewController {
    
    //UsuarioManager
    var usuarioManager = UsuarioManager.sharedInstance
    
    //flag pra indicar se o switch de ativo ou não funciona!
    var estaAtivo:Bool!
    
    var eventStore: EKEventStore = EKEventStore()
    
    lazy var produtos:Array<Produto> = {
        return ProdutoManager.sharedInstance.buscarProdutos()
        }()
    
    @IBOutlet weak var alertaUISwitch: UISwitch!
    //indicador de dias
    @IBOutlet weak var diasAlertaLabel: UILabel!
    
    @IBOutlet weak var diasAlertaSlider: UISlider!
    
    @IBOutlet weak var horarioDatePicker: UIDatePicker!
    
    
    //switch de ativo ou não
    @IBAction func alertaSwitch(sender: AnyObject) {
        var mySwitch = sender as! UISwitch
            estaAtivo = mySwitch.on
            usuarioManager.setAlerta(estaAtivo)

        if estaAtivo == true {
            for i in 0...produtos.count {
                criarNotificacao(produtos[i])
            }
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        
        self.tableView.reloadData()
    }
    
    //slider que controla a quantidade de dias
    @IBAction func diasSlider(sender: AnyObject) {
        println(sender.value as Float)
        diasAlertaLabel.text = "\(Int(round(sender.value as Float)))"
        usuarioManager.setDiasAlerta(Int(round(sender.value as Float)))
    }
    @IBAction func tempoNotification(sender: AnyObject) {
       let date = sender as! UIDatePicker
       usuarioManager.setHorarioNotificacao(date.date)
    }
    
    func configInitialize() {
        diasAlertaLabel.text = "\(usuarioManager.getDiasAlerta())"
        estaAtivo = usuarioManager.getAlerta()
        alertaUISwitch.setOn(estaAtivo, animated: false)
        //olhar aqui direito
        horarioDatePicker.setDate(usuarioManager.getHorarioNotificacao(), animated: false)
        diasAlertaSlider.value = Float(usuarioManager.getDiasAlerta())
        
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.configInitialize()
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
                return 3
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
    
    
    
    
    func criarNotificacao(prod: Produto) {
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
            
            /*
            vivi, como vc está mexendo aqui, e eu não entendi tão bem a logica como vc montou as notifications, tem uma  maneira mais facil de colocar a hora na data que temos rs, é algo que foi implementado agora no iOS 8.0
            
            let date: NSDate = NSDate()
            let cal: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            
            let newDate: NSDate = cal.dateBySettingHour(0, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())!
            */
            
            let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
            
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.applicationIconBadgeNumber = 1
            
            localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
    }
    
    func criarEventoCalendario(prod: Produto){
        var evento: EKEvent = EKEvent(eventStore: eventStore)
        
        evento.title = "\(prod.nome) vai vencer nesse dia!"
        
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
