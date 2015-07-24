//
//  NotifManager.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 24/07/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class NotifManager: NSObject{
    static let sharedInstance = NotifManager()
    
    var eventStore: EKEventStore = EKEventStore()
    let usuarioManager = UsuarioManager.sharedInstance

    
    func criarNotificacao(prod: Produto) {
        var diasNoti: Int!
        
        var dataAgora = NSDate()
        var convert: Int = Int(dataAgora.timeIntervalSinceDate(prod.dataValidade))
        var diasFaltando = 1+(convert/86400)*(-2)
        print("\(diasFaltando)")
        
        if diasFaltando < usuarioManager.getDiasAlerta(){
            diasNoti = diasFaltando
        } else {
            diasNoti = usuarioManager.getDiasAlerta()
        }
        
        for i in 0...diasNoti {
            var localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Produto vencendo"
            var diasRestantes = diasNoti - i
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

}
