import UIKit
import SwiftyComments

struct Comentario : Decodable {
    var comentario : String
    var nome : String
    var resp : [Comentario]
    
    init(comentario:String, nome:String, resp:[Comentario]) {
        self.comentario = comentario
        self.nome = nome
        self.resp = resp
    }
}
class SimpleCommentsViewController: CommentsViewController, UITextViewDelegate {
    private let commentCellId = "simpleCommentCellId"
    var allComments: [Comment] = []
    var commentsRest : [Comentario] = []
    var comments: [AttributedTextComment]! = []
    var noticiaIdentifier: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SimpleCommentCell.self, forCellReuseIdentifier: commentCellId)
        let url = URL(string: "https://cgn.inf.br/appios/comentarios/\(self.noticiaIdentifier)")
        var disscussionThread = RandomDiscuss()
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.commentsRest = try JSONDecoder().decode([Comentario].self, from: data!)
                }catch{
                    print("request ErroRRRRR :(")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)){
                    disscussionThread = RandomDiscuss.generate(size: self.commentsRest.count, requestResponse: self.commentsRest)
                    self.allComments = disscussionThread.comments
                    self.currentlyDisplayed = self.allComments
                    self.fullyExpanded = true
                    self.tableView.reloadData()
                }
            }else{
                print("HTTP error: \(error!)")
            }
        }.resume()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! SimpleCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! Comment
        commentCell.level = comment.level
        commentCell.commentContent = comment.comentario
        commentCell.posterName = comment.nome
        return commentCell
    }
}
