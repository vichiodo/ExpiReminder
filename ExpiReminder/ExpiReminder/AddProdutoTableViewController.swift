//
//  AddProdutoTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class AddProdutoTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var imagem: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
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
        
    }
    
    @IBAction func codigoBarra(sender: AnyObject) {
        
    }
    
    @IBAction func salvar(sender: AnyObject) {
        
        
        
        
        if txtNome == nil{
            let alerta: UIAlertController = UIAlertController(title: "Nome faltando", message: "Digite o nome do produto", preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                txtNome.becomeFirstResponder()
            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else{
            var produto = ProdutoManager.sharedInstance.novoProduto()
            
            produto.nome = txtNome.text
            produto.dataValidade = datePicker.date
            
            var dataAgora = NSDate()
            var convert: Int = Int(dataAgora.timeIntervalSinceDate(datePicker.date))
            
            produto.diasFaltando = convert - 86400

            ProdutoManager.sharedInstance.salvarProduto()
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
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
