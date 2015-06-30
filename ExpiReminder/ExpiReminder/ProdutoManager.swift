
import CoreData
import UIKit

class ProdutoManager {
    
    static let sharedInstance = ProdutoManager()
    static let entityName: String = "Produto"
    
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }()
    
    private init(){}
    
    func novoProduto() ->Produto {
        return NSEntityDescription.insertNewObjectForEntityForName(ProdutoManager.entityName, inManagedObjectContext: managedContext) as! Produto
    }
    
    func buscarProdutos() ->Array<Produto> {
        let buscaRequest = NSFetchRequest(entityName: ProdutoManager.entityName)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Produto] {
            return resultados
        } else {
            println("Não foi possível buscar esse produto. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Produto>()
    }
    
    func buscarProdutoNome(nome: String) ->Produto {
        let buscaRequest = NSFetchRequest(entityName: ProdutoManager.entityName)
        buscaRequest.predicate = NSPredicate(format: "nome == %s", nome)
        var erro: NSError?
        let buscaResultados = managedContext.executeFetchRequest(buscaRequest, error: &erro) as? [NSManagedObject]
        if let resultados = buscaResultados as? [Produto] {
            return resultados.last!
        } else {
            println("Não foi possível buscar esse produto. Erro: \(erro), \(erro!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Produto()
    }

    
    func buscarProduto(index: Int) -> Produto{
        var produto: Produto = buscarProdutos()[index]
        return produto
    }
    
    func salvarProduto() {
        var erro: NSError?
        managedContext.save(&erro)
        
        if let e = erro {
            println("Não foi possível salvar esse produto. Erro: \(erro), \(erro!.userInfo)")
        }
    }
    
    func removerTodos() {
        var arrayProd: Array<Produto> = buscarProdutos()
        for produto: Produto in arrayProd {
            managedContext.deleteObject(produto)
        }
    }
    
    func removerJogador(index: Int) {
        var arrayProd: Array<Produto> = buscarProdutos()
        managedContext.deleteObject(arrayProd[index] as NSManagedObject)
        salvarProduto()
    }
    
    func salvarNovoProduto(nome: String, foto: UIImage, data: NSDate, codigoBarra: String, diasFaltando: Int) {
        let produto = novoProduto()
        let imagem = UIImageJPEGRepresentation(foto, 1)
        
        produto.setValue(nome, forKey: "nome")
        produto.setValue(imagem, forKey: "foto")
        produto.setValue(data, forKey: "dataValidade")
        produto.setValue(codigoBarra, forKey: "codigoBarra")
        produto.setValue(diasFaltando, forKey: "diasFaltando")
        salvarProduto()
    }
    
}
