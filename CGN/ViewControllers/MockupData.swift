import Foundation
import SwiftyComments

class RandomDiscuss {
    var comments: [AttributedTextComment]! = []
    /**
     Generate a list of comments from webservice
     */
    static func generate(size: Int, requestResponse: [Comentario], maximumChildren: Int = 1) -> RandomDiscuss {
        let discussion = RandomDiscuss()
        for comme in requestResponse{
            var rootComment = structComment(comentario: comme)
            addReplyRecurs(&rootComment, maximumChildren: 1, respostasComentario: comme.resp)
            discussion.comments.append(rootComment)
        }
        return discussion
    }
    
    /**
     Generate a comment.
     */
    static func structComment(comentario: Comentario) -> AttributedTextComment {
        let comm = AttributedTextComment()
        comm.nome = comentario.nome
        comm.comentario = comentario.comentario
        return comm
    }
    /**
     Recursively add a random number of replies to parent.
     At each recursion, the maximum number of children is
     decreased by 1 until it reaches 0.
     */
    private static func addReplyRecurs( _ parent: inout AttributedTextComment, maximumChildren: Int, respostasComentario: [Comentario]) {
        if maximumChildren == 0 { return }
//        for _ in 0..<(Int(arc4random_uniform(UInt32(maximumChildren-1))) + 1) {
//            var com = randomComent()
//            parent.addReply(com)
//            com.replyTo = parent
//            com.level = parent.level+1
//            addReplyRecurs(&com, maximumChildren: maximumChildren-1)
//        }
        for respostas in respostasComentario{
            var com = structComment(comentario: respostas)
            parent.addReply(com)
            com.replyTo = parent
            com.level = parent.level+1
            addReplyRecurs(&com, maximumChildren: maximumChildren-1, respostasComentario: respostasComentario)
        }
        
    }
}

/// Model of a comment with attributedText content.
class AttributedTextComment: Comment {
    var attributedContent: NSAttributedString?
}


/**
 This class models a comment with all the most
 common attributes in the commenting systems.
 It's used as an exemple through the implemented
 commenting systems.
 **/
class Comment: BaseComment {
    var nome: String?
    var comentario: String?
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
    
}

