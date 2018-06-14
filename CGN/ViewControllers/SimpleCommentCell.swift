import UIKit
import SwiftyComments

class SimpleCommentCell: CommentCell {
    var content:SimpleCommentView {
        get {
            return self.commentViewContent as! SimpleCommentView
        }
    }
    open var commentContent: String! = "content" {
        didSet {
            (self.commentViewContent as! SimpleCommentView).commentContent = commentContent
        }
    }
    open var posterName: String! {
        get {
            return self.content.posterName
        } set(value) {
            self.content.posterName = value
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = SimpleCommentView()
        self.rootCommentMarginColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.rootCommentMargin = 20
        self.commentMarginColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.commentMargin = 10
        self.indentationColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.indentationIndicatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.indentationIndicatorThickness = 1
        self.indentationUnit = 30
        self.commentViewContent?.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.commentViewContent?.layer.cornerRadius = 5.0
        self.commentViewContent?.layer.masksToBounds = false
        self.commentViewContent?.layer.shadowColor = UIColor.black.cgColor
        self.commentViewContent?.layer.shadowOpacity = 0.5
        self.commentViewContent?.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.commentViewContent?.layer.shadowRadius = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class SimpleCommentView: UIView {
    open var commentContent: String! = "content" {
        didSet {
            contentLabel.text = commentContent
        }
    }
    open var posterName: String! = "username" {
        didSet {
            posterLabel.text = posterName
        }
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        let margin: CGFloat = 10
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        posterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        contentLabel.topAnchor.constraint(equalTo: posterLabel.bottomAnchor).isActive = true
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = UIColor.black
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    var posterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lbl.textAlignment = .left
        return lbl
    }()
    var controlView: UIView = {
        let v = UIView()
        let actionBtn = UIButton(type: UIButtonType.infoDark)
        actionBtn.setTitle("Like", for: .normal)
        v.addSubview(actionBtn)
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        actionBtn.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        actionBtn.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        return v
    }()
}
