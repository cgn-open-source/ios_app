import UIKit

class SecondViewController: UIViewController {
    var tableView: UITableView = UITableView()
    var editoriasArray:Array<Int> = [Int]()
    let defaults = UserDefaults.standard
    
    let ajustes:Array<Ajuste> = [
        Ajuste(editoriaId: 31, name: "Cascavel", description: "Principais fatos e notícias da cidade" , color : UIColor(red:0.16, green:0.62, blue:0.99, alpha:1.0)),
        Ajuste(editoriaId: 3, name: "Cotidiano", description: "Destaques das notícias de todo país" , color : UIColor(red:0.75, green:0.05, blue:0.08, alpha:1.0)),
        Ajuste(editoriaId: 35, name: "Achados e Perdidos", description: "Avisos sobre animais e objetos perdidos" , color : UIColor(red:0.05, green:0.75, blue:0.22, alpha:1.0)),
        Ajuste(editoriaId: 2, name: "Esportes", description: "Futebol e outros esportes no Brasil" , color : UIColor(red:0.91, green:0.45, blue:0.05, alpha:1.0)),
        Ajuste(editoriaId: 1, name: "Entretenimento", description: "Famosos e artistas em notícias" , color : UIColor(red:0.89, green:0.21, blue:0.48, alpha:1.0))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //append defaults to active array
        let userDefinitions = defaults.array(forKey: "editorias")
        if let UD = userDefinitions as? Array<Int>{
            for UserDef in UD{
                editoriasArray.append(UserDef)
            }
        }
        self.initializeInterfaceElements()
        self.autolayoutInterfaceElements()
        if(UserDefaults.standard.array(forKey: "editorias")?.isEmpty)!{
            let tabBarControllerItems = self.tabBarController?.tabBar.items
            if let tabArray = tabBarControllerItems {
                let tabBarNews = tabArray[0]
                tabBarNews.isEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //change navigation item title
        if let tabBar = self.tabBarController{
            tabBar.navigationItem.title = "Ajustes"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeInterfaceElements() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }

    func autolayoutInterfaceElements() {
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        self.tableView.layer.cornerRadius = 5
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ajustes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "defaultCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle , reuseIdentifier: "defaultCell")
        }
        if indexPath.row != 6 {
            let ajuste = ajustes[indexPath.row]
            self.createAjustesCell(celula: cell!, ajusteItem: ajuste)
        }
        return cell!
    }
    
    func createAjustesCell(celula: UITableViewCell, ajusteItem: Ajuste){
        celula.textLabel?.text = ajusteItem.name
        celula.textLabel?.textColor = ajusteItem.color
        celula.detailTextLabel?.text = ajusteItem.description
        self.addSwitch(self.view, row: celula, switchColor: ajusteItem.color, switchName: ajusteItem.name, switchIdentifier: ajusteItem.editoriaId);
    }
    
    @objc func addSwitch(_ view:UIView, row: UITableViewCell, switchColor: UIColor, switchName: String, switchIdentifier: Int) {
        let uiSwitch:UISwitch = UISwitch(frame: .zero)
        
        uiSwitch.onTintColor = switchColor
        uiSwitch.tag = switchIdentifier
        let userDefinitions = defaults.array(forKey: "editorias")
        if let UD = userDefinitions as? Array<Int>{
            self.switchSetState(tag: uiSwitch.tag, userPref: UD, switc: uiSwitch)
        }
        uiSwitch.addTarget(self, action: #selector(SecondViewController.toggle(_:)), for: UIControlEvents.valueChanged)
        row.accessoryView = uiSwitch
        return
    }
    
    func switchSetState(tag: Int, userPref: Array<Int>, switc: UISwitch){
        if let index = userPref.index(of: tag) {
            if(userPref[index] == switc.tag){
                switc.setOn(true, animated: false)
            }else{
                switc.setOn(false, animated: false)
            }
        }
    }
    
    @objc func toggle(_ uiSwitch:UISwitch) {
        if(uiSwitch.isOn) {
            editoriasArray.append(uiSwitch.tag)
            defaults.removeObject(forKey: "editorias")
            defaults.set(editoriasArray, forKey: "editorias")
            if(UserDefaults.standard.array(forKey: "editorias")?.isEmpty)!{}else{
                let tabBarControllerItems = self.tabBarController?.tabBar.items
                if let tabArray = tabBarControllerItems {
                    let tabBarNews = tabArray[0]
                    tabBarNews.isEnabled = true
                }
            }
        }else{
            if let index = editoriasArray.index(of: uiSwitch.tag) {
                editoriasArray.remove(at: index)
            }
            defaults.removeObject(forKey: "editorias")
            defaults.set(editoriasArray, forKey: "editorias")
            if(UserDefaults.standard.array(forKey: "editorias")?.isEmpty)!{
                let tabBarControllerItems = self.tabBarController?.tabBar.items
                if let tabArray = tabBarControllerItems {
                    let tabBarNews = tabArray[0]
                    tabBarNews.isEnabled = false
                }
            }
        }
        return
    }
}
