//
//  AddProdutoTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 30/06/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit
import EventKit

class AddProdutoTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var imagem: UIImageView!
    
    let usuarioManager = UsuarioManager.sharedInstance
    let notifManager = NotifManager.sharedInstance
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    var produto: Produto!
    
    var codigoBarras:String!

    var editando = false
    
    override func viewDidLoad() {
        if let p = produto {
            editando = true
            self.navigationItem.title = "Editar Produto"
            txtNome.text = p.nome
            datePicker.date = p.dataValidade
            imagem.image = UIImage(data: p.foto)
            codigoBarras = p.codigoBarra
        } else {
            editando = false
            datePicker.minimumDate = NSDate()
        }
        
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.txtNome.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recebeCodigoBarras:", name: "barCode", object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
//        if codigoBarras != nil { TENTATIVA DE FAZER RETORNAR OS VALORES JA SALVOS PELO MESMO CODIGO DE BARRAS
//            var produtoExiste: Produto! = ProdutoManager.sharedInstance.buscarCodigo(codigoBarras)
//            
//            if let existe = produtoExiste {
//                txtNome.text = produtoExiste.nome
//                imagem.image = UIImage(data: produtoExiste.foto)
//            }
//        }

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
//        self.imagem.contentMode = UIViewContentMode.ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func codigoBarra(sender: AnyObject) {
        let barCodeVC = BarCodeViewController()
        self.navigationController?.pushViewController(barCodeVC, animated: true)
    }
    
    @IBAction func salvar(sender: AnyObject) {
         if txtNome.text == nil || txtNome.text == "" && editando == true{
            let alerta: UIAlertController = UIAlertController(title: "Nome faltando", message: "Digite o nome do produto", preferredStyle: .Alert)
            let al1:UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (ACTION) -> Void in
                txtNome.becomeFirstResponder()
            })
            [alerta.addAction(al1)]
            self.presentViewController(alerta, animated: true, completion: nil)
        }
        else{
            if editando == false{
                produto = ProdutoManager.sharedInstance.novoProduto()
                produto.nome = txtNome.text
                produto.dataValidade = datePicker.date
                produto.foto = UIImageJPEGRepresentation(imagem.image, 1)
                if codigoBarras == nil{
                    produto.codigoBarra = ""
                } else{
                    produto.codigoBarra = codigoBarras
                }
                
                ProdutoManager.sharedInstance.salvarProduto()
                
                if usuarioManager.getAlerta() == true {
                    self.notifManager.criarNotificacao(produto)
                }
                self.notifManager.criarEventoCalendario(produto)
                
            } else if let p = produto {
                    self.notifManager.cancelarNotificacao(p)
                    self.notifManager.excluirEventoCalendario(p)
                    
                    produto.nome = txtNome.text
                    produto.dataValidade = datePicker.date
                    produto.foto = UIImageJPEGRepresentation(imagem.image, 1)
                    produto.codigoBarra = codigoBarras
                    
                    self.notifManager.criarNotificacao(produto)
                    self.notifManager.criarEventoCalendario(produto)
                
                    ProdutoManager.sharedInstance.salvarProduto()
                
            }
            
            self.tabBarController?.tabBar.hidden = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
    }

    
    func recebeCodigoBarras(notification:NSNotification) {
        var userInfo:NSDictionary = notification.userInfo!
        var barCode:String = userInfo.objectForKey("barCode") as! String
        codigoBarras = barCode
        println("meu Codigo de barras: \(codigoBarras)")
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
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
