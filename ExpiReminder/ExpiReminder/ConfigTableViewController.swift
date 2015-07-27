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
    let notifManager = NotifManager.sharedInstance
    
    //flag pra indicar se o switch de ativo ou não funciona!
    var estaAtivo:Bool!
    
    lazy var produtos:Array<Produto> = {
        return ProdutoManager.sharedInstance.buscarProdutos()
        }()
    
    @IBOutlet weak var alertaUISwitch: UISwitch!
    //indicador de dias
    @IBOutlet weak var diasAlertaLabel: UILabel!
    
    @IBOutlet weak var diasAlertaSlider: UISlider!
    
    //switch de ativo ou não
    @IBAction func alertaSwitch(sender: AnyObject) {
        var mySwitch = sender as! UISwitch
            estaAtivo = mySwitch.on
            usuarioManager.setAlerta(estaAtivo)

        if estaAtivo == true {
            for i in 0...produtos.count {
                self.notifManager.criarNotificacao(produtos[i])
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
