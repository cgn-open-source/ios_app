
import UIKit
import Kingfisher
import SwiftPullToRefresh

struct Noticia : Decodable {
    var noticias_id : String
    var cidade : String
    var titulo : String
    var editorias_id : String
    var gravata : String
    var imagem : Optional<URL>
    var data_inicio : String
    var agora : String
    var video : Optional<String>
    var chapeu : String
    var milli : Int
    var editoria_color : String
    
    init(noticias_id : String, cidade : String, titulo : String, editorias_id : String, gravata : String, imagem : Optional<URL>, data_inicio : String, agora : String, video : Optional<String>, chapeu : String, milli : Int, editoria_color : String) {
        self.noticias_id = noticias_id
        self.cidade = cidade
        self.titulo = titulo
        self.editorias_id = editorias_id
        self.gravata = gravata
        self.imagem = imagem
        self.data_inicio = data_inicio
        self.agora = agora
        self.video = video
        self.chapeu = chapeu
        self.milli = milli
        self.editoria_color = editoria_color
    }
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension String
{
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "GMT-3:00") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
class CollectionViewListagemDeNoticias: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var noticias : Array<Noticia> = Array<Noticia>()
    let defaults = UserDefaults.standard
    var editoriasSelecionadas : String = ""
    var page = 1
    var perPage = 10
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.size.width - 20)
        layout.estimatedItemSize = CGSize(width: width, height: 100)
        layout.itemSize = CGSize(width: width, height: 1000)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.collectionViewLayout = layout
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(MyCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.backgroundColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
        collectionView?.collectionViewLayout = layout
        
        collectionView?.spr_setTextHeader { [weak self] in
            self?.doNewsRequest(false, itensPerPage: self!.perPage, actualPage: self!.page)
        }
        collectionView?.spr_setIndicatorAutoFooter { [weak self] in
            self?.page += 1
            self?.doNewsRequest(true, itensPerPage: self!.perPage, actualPage: self!.page)
        }
        collectionView?.layoutIfNeeded()
}
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noticias.count
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.isAppAlreadyLaunchedOnce()
        self.readUserDefaults()
        self.doNewsRequest(false, itensPerPage: perPage, actualPage: page)
    }
    func doNewsRequest(_ isAppend:Bool, itensPerPage:Int, actualPage:Int){
        let url = URL(string: "https://cgn.inf.br/appios/ios/\(itensPerPage)?page=\(actualPage)&editoria=\(editoriasSelecionadas)")
        if(editoriasSelecionadas.isEmpty){
            print("sem editorias Selecionadas")
        }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                
                do{
                    if(isAppend == true){
                        self.noticias += try JSONDecoder().decode([Noticia].self, from: data!)
                    }else{
                        self.noticias = try JSONDecoder().decode([Noticia].self, from: data!)
                    }
                }catch{
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.viewWithTag(0)?.snapshotView(afterScreenUpdates: true)
                    self.collectionView?.reloadData()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.collectionView?.reloadData()
                    self.collectionView?.viewWithTag(0)?.snapshotView(afterScreenUpdates: true)
                    self.collectionView?.spr_endRefreshing()
                }
            }
            
            }.resume()
    }
    func isAppAlreadyLaunchedOnce(){
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            defaults.set([31,36], forKey: "editorias")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if let tabBar = self.tabBarController{
            tabBar.navigationItem.title = "Notícias"
        }
    }
    func readUserDefaults(){
        let userDefinitions = defaults.array(forKey: "editorias")
        if let UD = userDefinitions as? Array<Int>{
            editoriasSelecionadas.removeAll()
            for userDefault in UD{
                self.editoriasSelecionadas += "\(userDefault),"
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MyCell
        
        switch noticias[indexPath.item].editorias_id {
            case "31":
                cell.editoria.text = "Cascavel"
                cell.editoria.textColor = UIColor(red:0.16, green:0.62, blue:0.99, alpha:1.0)
            case "3":
                cell.editoria.text = "Cotidiano"
                cell.editoria.textColor = UIColor(red:0.75, green:0.05, blue:0.08, alpha:1.0)
            case "35":
                cell.editoria.text = "Achados e perdidos"
                cell.editoria.textColor = UIColor(red:0.05, green:0.75, blue:0.22, alpha:1.0)
            case "2":
                cell.editoria.text = "Esportes"
                cell.editoria.textColor = UIColor(red:0.91, green:0.45, blue:0.05, alpha:1.0)
            case "1":
                cell.editoria.text = "Entretenimento"
                cell.editoria.textColor = UIColor(red:0.89, green:0.21, blue:0.48, alpha:1.0)
            default : break
        }
        cell.titulo.text = noticias[indexPath.item].titulo
        cell.gravata.text = noticias[indexPath.item].gravata
        if let image = noticias[indexPath.item].imagem{
            let url = URL(string: String.init(describing: image))
            let processor = ResizingImageProcessor(referenceSize: CGSize(width: 475, height: 267))
            cell.imgView.kf.indicatorType = .activity
            cell.imgView.kf.setImage(with: url,
                options: [.processor(processor)],
                completionHandler: { (image, error, cacheType, imageUrl) in
                    self.collectionView?.superview?.autoresizesSubviews = true
                }
            )
//            cell.imgView.heightAnchor.constraint(equalToConstant: 267).isActive = true
        }else{
//            cell.imgView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            cell.imgView.image = nil
        }
        if(noticias[indexPath.item].video == "0" || noticias[indexPath.item].video == nil){
            cell.imgViewHasVideo.image = nil
        }else{
            cell.imgViewHasVideo.image = #imageLiteral(resourceName: "play")
        }

        let date = noticias[indexPath.item].data_inicio.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        let stringDate =  date.toString(dateFormat: "dd/MM/yyyy HH:mm")
        cell.timeString.text = stringDate
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Interna", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InternaViewController") as! Interna
        vc.textLabel = self.noticias[indexPath.item].noticias_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class MyCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: (bounds.size.width - 20))
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.backgroundColor = UIColor.blue
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imgView.image = nil
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 100))
    }
    
    func setupViews() {
        contentView.addSubview(editoria)
        editoria.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        editoria.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0).isActive = true
        editoria.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(titulo)
        titulo.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        titulo.topAnchor.constraint(equalTo: editoria.bottomAnchor, constant: 10.0).isActive = true
        titulo.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        
        contentView.addSubview(gravata)
        gravata.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        gravata.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 10.0).isActive = true
        gravata.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.0).isActive = true
        
        contentView.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: gravata.bottomAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        contentView.addSubview(imgViewHasVideo)
        imgViewHasVideo.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        imgViewHasVideo.bottomAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        imgViewHasVideo.centerYAnchor.constraint(equalTo: imgView.centerYAnchor).isActive = true
        imgViewHasVideo.centerXAnchor.constraint(equalTo: imgView.centerXAnchor).isActive = true
        
        contentView.addSubview(imgTime)
        imgTime.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 10.0).isActive = true
        imgTime.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        
        contentView.addSubview(timeString)
        timeString.leadingAnchor.constraint(equalTo: imgTime.trailingAnchor, constant: 10.0).isActive = true
        timeString.centerYAnchor.constraint(equalTo: imgTime.centerYAnchor).isActive = true
        timeString.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    let editoria : UILabel = {
        let editoriaAttr = UILabel()
        editoriaAttr.sizeToFit()
        editoriaAttr.numberOfLines = 1
        editoriaAttr.textColor = UIColor.black
        editoriaAttr.font = UIFont.systemFont(ofSize: 15)
        editoriaAttr.translatesAutoresizingMaskIntoConstraints = false
        
        return editoriaAttr
    }()
    
    let titulo : UILabel = {
        let tituloAttr = UILabel()
        tituloAttr.text = "greve dos correios atrasa encomendas"
        tituloAttr.sizeToFit()
        tituloAttr.numberOfLines = 0
        tituloAttr.font = UIFont.boldSystemFont(ofSize: 23)
        tituloAttr.textColor = UIColor.black
        tituloAttr.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return tituloAttr
    }()
    
    let gravata : UILabel = {
        let gravataAttr = UILabel()
        gravataAttr.sizeToFit()
        gravataAttr.numberOfLines = 3
        gravataAttr.textColor = UIColor.black
        gravataAttr.font = UIFont.systemFont(ofSize: 15)
        gravataAttr.translatesAutoresizingMaskIntoConstraints = false
        return gravataAttr
    }()
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    let imgViewHasVideo : UIImageView = {
        let hasVideo = UIImageView()
        hasVideo.image = #imageLiteral(resourceName: "play")
        hasVideo.contentMode = .scaleAspectFit
        hasVideo.clipsToBounds = true
        hasVideo.translatesAutoresizingMaskIntoConstraints = false
        
        return hasVideo
    }()
    
    let imgTime : UIImageView = {
        let imageTime = UIImageView()
        imageTime.image = #imageLiteral(resourceName: "time")
        imageTime.frame.size = CGSize(width: 15, height: 15)
        imageTime.contentMode = .scaleAspectFit
        imageTime.clipsToBounds = true
        imageTime.translatesAutoresizingMaskIntoConstraints = false
        return imageTime
    }()
    
    let timeString : UILabel = {
        let time = UILabel()
        time.sizeToFit()
        time.numberOfLines = 1
        time.textColor = UIColor.black
        time.text = "Há 4 horas"
        time.font = UIFont.systemFont(ofSize: 12)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()
}
