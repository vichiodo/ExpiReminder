//
//  CalendarioTableViewController.swift
//  ExpiReminder
//
//  Created by Vivian Dias on 11/07/15.
//  Copyright (c) 2015 Vivian Dias. All rights reserved.
//

import UIKit

class CalendarioTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    
    
    var produtos7Dias: Array<Produto> = []
    var produtos15Dias: Array<Produto> = []
    var produtos30Dias: Array<Produto> = []
    var produtos30MaisDias: Array<Produto> = []
    var produtosOrdenados: Array<Produto>!

    
    var produtos: Array<Produto>!



    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        ordenaVetores()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return produtos7Dias.count
        case 1: return produtos15Dias.count
        case 2: return produtos30Dias.count
        case 3: return produtos30MaisDias.count
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "7 dias"
        case 1: return "15 dias"
        case 2: return "30 dias"
        case 3: return "30+ dias"
        default: return ""
        }
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: CalendarioTableViewCell = tableView.dequeueReusableCellWithIdentifier("produto", forIndexPath: indexPath) as! CalendarioTableViewCell
        
        var produto: Produto!
        
        switch indexPath.section {
        case 0:
            produto = produtos7Dias[indexPath.row]
        case 1:
            produto = produtos15Dias[indexPath.row]
        case 2:
            produto = produtos30Dias[indexPath.row]
        case 3:
            produto = produtos30MaisDias[indexPath.row]
        default:
            break
        }

        var dataValidade = NSDateFormatter()
        dataValidade.dateFormat = "dd/MM/yyyy"
        var dataString = dataValidade.stringFromDate(produto.dataValidade)
        
        cell.lblNome.text = produto.nome
        cell.lblData.text = dataString

        
        return cell
    }

    
    func ordenaVetores() {
        produtos = ProdutoManager.sharedInstance.buscarProdutos()
        
        produtosOrdenados = produtos
        produtosOrdenados.sort({$0.dataValidade.timeIntervalSinceNow < $1.dataValidade.timeIntervalSinceNow })
        
        produtos7Dias = []
        produtos15Dias = []
        produtos30Dias = []
        produtos30MaisDias = []
        
        // organiza as atividades dentro de cada periodo de tempo
        if produtosOrdenados.count > 0 {
            for i in 0...produtosOrdenados.count - 1 {
                let dataCompara = produtosOrdenados[i].dataValidade
                
                let calendar = NSCalendar.currentCalendar()
                let comps30 = NSDateComponents()
                comps30.day = 30
                let date30 = calendar.dateByAddingComponents(comps30, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                let comps15 = NSDateComponents()
                comps15.day = 15
                let date15 = calendar.dateByAddingComponents(comps15, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                let comps7 = NSDateComponents()
                comps7.day = 7
                let date7 = calendar.dateByAddingComponents(comps7, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                
                
                if dataCompara.compare(date30!) == NSComparisonResult.OrderedDescending {
                    produtos30MaisDias.append(produtosOrdenados[i])
                } else if dataCompara.compare(date30!) == NSComparisonResult.OrderedAscending {
                    if dataCompara.compare(date15!) == NSComparisonResult.OrderedDescending {
                        produtos30Dias.append(produtosOrdenados[i])
                    } else {
                        if dataCompara.compare(date7!) == NSComparisonResult.OrderedDescending {
                            produtos15Dias.append(produtosOrdenados[i])
                        } else {
                            if dataCompara.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                                produtos7Dias.append(produtosOrdenados[i])
                            }
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
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
