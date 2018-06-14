//
//  Notificacoes.swift
//  Agenda
//
//  Created by Alura on 13/12/17.
//  Copyright © 2017 Alura. All rights reserved.
//

import UIKit

class Notificacoes: NSObject {
    
    func exibeNotificacaoDeMediaDosAlunos(dicionarioDeMedia:Array<Noticia>) -> UIAlertController? {
        if let media = dicionarioDeMedia[0].titulo as? String {
            let alerta = UIAlertController(title: "Noticia", message: media, preferredStyle: .alert)
            let botao = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alerta.addAction(botao)
            
            return alerta
        }
        return nil
    }

}
