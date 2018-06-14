//
//  CustomerTabBar.swift
//  tabviewcontroller
//
//  Created by Mark Hoath on 3/10/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

class CustomNavBar: UINavigationController {
    let listaDeAlunos : Array<Any> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar  = CustomTabBar()
        

        let image = #imageLiteral(resourceName: "cgn-logo")
        let imageView = UIImageView(image: image)

        let bannerWidth = navigationBar.frame.size.width
        let bannerHeight = navigationBar.frame.size.height

        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2

        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(tapButton))
//        tabBar.navigationItem.leftBarButtonItem = addButton
//        
//        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBttn))
//        tabBar.navigationItem.rightBarButtonItem = shareButton
        
        tabBar.navigationItem.titleView = imageView
        navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationBar.prefersLargeTitles = true
//
//
//        

//        tabBar.navigationItem.title = "tested"
//
//
        viewControllers = [tabBar]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tapButton(){
//        API().calculaMediaGeralDosAlunos(alunos: listaDeAlunos, sucesso: { (dicionario) in
//            if let alerta = Notificacoes().exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia: dicionario) {
//                self.present(alerta, animated: true, completion: nil)
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    @objc func shareBttn(){
        print("share app or news")
//        API().calculaMediaGeralDosAlunos(alunos: listaDeAlunos, sucesso: { (dicionario) in
//            if let alerta = Notificacoes().exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia: dicionario) {
//                self.present(alerta, animated: true, completion: nil)
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
