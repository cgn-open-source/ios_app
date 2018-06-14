//import UIKit
//struct Noticia : Decodable {
//    var noticias_id : String
//    var cidade : String
//    var titulo : String
//    var editorias_id : String
//    var gravata : String
//    var imagem : Optional<URL>
//    var data_inicio : String
//    var agora : String
//    var video : Optional<String>
//    var chapeu : String
//    var milli : Int
//    var editoria_color : String
//
//    init(noticias_id : String, cidade : String, titulo : String, editorias_id : String, gravata : String, imagem : Optional<URL>, data_inicio : String, agora : String, video : Optional<String>, chapeu : String, milli : Int, editoria_color : String) {
//        self.noticias_id = noticias_id
//        self.cidade = cidade
//        self.titulo = titulo
//        self.editorias_id = editorias_id
//        self.gravata = gravata
//        self.imagem = imagem
//        self.data_inicio = data_inicio
//        self.agora = agora
//        self.video = video
//        self.chapeu = chapeu
//        self.milli = milli
//        self.editoria_color = editoria_color
//    }
//}
//class API: NSObject {
//    
//    func calculaMediaGeralDosAlunos(alunos:Array<Optional<Any>>, sucesso:@escaping(_ dicionarioDeMedias:Array<Noticia>) -> Void, falha:@escaping(_ error:Error) -> Void) {
//        
//        guard let url = URL(string: "https://cgn.inf.br/aplicativo/ios/10?page=1&editoria=31") else { return }
//        var listaDeAlunos:Array<Dictionary<String, Any>> = []
//        var json:Dictionary<String, Any> = [:]
//        
//        
//        do {
//            var requisicao = URLRequest(url: url)
//            let data = try JSONSerialization.data(withJSONObject: json, options: [])
//            requisicao.httpBody = data
//            requisicao.httpMethod = "GET"
//            requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            let task = URLSession.shared.dataTask(with: requisicao, completionHandler: { (data, response, error) in
//                if error == nil {
//                    do {
//                        let dicionario = try JSONDecoder().decode([Noticia].self, from: data!)
//                        sucesso(dicionario)
//                    } catch {
//                        falha(error)
//                    }
////                    DispatchQueue.main.async {
////                        CollectionViewListagemDeNoticias().collectionView?.reloadData()
////                    }
//                }
//            })
//            task.resume()
//            
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//}
//
//
//
