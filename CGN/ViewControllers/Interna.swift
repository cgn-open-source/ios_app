//
//  ViewController.swift
//  scrollViewAutoLayout
//
//  Created by Pradeep Chauhan on 12/22/16.
//  Copyright © 2016 Pradeep Chauhan. All rights reserved.
//

import UIKit
import Kanna
import Kingfisher

struct New : Decodable {
    var titulo : String
    var editoria_tit : String
    var gravata : String
    var descricao : String
    var autor : Optional<String>
    var fonte : String
    var data_inicio : String
    var imagem : Optional<String>
    
    init(titulo:String, editoria_tit:String, gravata:String, descricao:String, autor:Optional<String>, fonte: String, data_inicio:String, imagem:Optional<String>) {
        self.titulo = titulo
        self.editoria_tit = editoria_tit
        self.gravata = gravata
        self.descricao = descricao
        self.autor = ""
        self.fonte = fonte
        self.data_inicio = data_inicio
        self.imagem = imagem
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
class Interna: UIViewController {
    var textLabel:String = ""
    var noticia : New = New.init(titulo:"",editoria_tit:"",gravata:"", descricao:"", autor:"",fonte:"",data_inicio:"", imagem:"")


    @IBOutlet weak var labelEditoria: UILabel!
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelGravata: UILabel!
    @IBOutlet weak var imageViewFoto: UIImageView!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelAutorFonte: UILabel!
    @IBOutlet weak var labelDescricao: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.doNewsRequest(id: textLabel)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    func doNewsRequest(id:String){
        let jsonURL = "https://cgn.inf.br/appios/viewios/\(id)"
        let url = URL(string: jsonURL)

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.noticia = try JSONDecoder().decode(New.self, from: data!)
                }catch{
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    self.labelTitulo?.text = self.noticia.titulo
                    self.labelEditoria?.text = self.noticia.editoria_tit
                    self.labelGravata?.text = self.noticia.gravata
                    if let image = self.noticia.imagem{
                        self.imageViewFoto?.heightAnchor.constraint(equalToConstant: 267).isActive = true
                        let url = URL(string: String.init(describing: image))
                        self.imageViewFoto?.kf.indicatorType = .activity
                        self.imageViewFoto?.kf.setImage(with: url, completionHandler: { (image, error, cacheType, imageUrl) in
                        })
                    }else{
                        self.imageViewFoto?.image = nil
                        self.imageViewFoto?.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    }
                    self.labelDescricao.text = self.noticia.descricao.html2String
                    if let autor = self.noticia.autor{
                        self.labelAutorFonte?.text = "\(autor) | \(self.noticia.fonte)"
                    }else{
                        self.labelAutorFonte?.text = self.noticia.fonte
                    }
                    let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        dateFormatterGet.timeZone = NSTimeZone(name: "GMT-3:00") as TimeZone?
                        dateFormatterGet.locale = Locale(identifier: "pt_BR")
                    let dateFormatterPrint = DateFormatter()
                        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm"
                    
                    if let date = dateFormatterGet.date(from: self.noticia.data_inicio){
                        self.labelData?.text = dateFormatterPrint.string(from: date)
                    }
                    else {
                        print("There was an error decoding the string")
                    }
                }

            }
            }.resume()
    }
    @IBAction func Comments(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "SimpleCommentCell", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ComentariosStory") as! SimpleCommentsViewController
        vc.noticiaIdentifier = textLabel
        let backItem = UIBarButtonItem()
        let addComment = UIBarButtonItem()
        backItem.title = "Voltar"
        addComment.title = "Adicionar Comentário"
        navigationItem.backBarButtonItem = backItem
        vc.navigationItem.rightBarButtonItem = addComment
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

