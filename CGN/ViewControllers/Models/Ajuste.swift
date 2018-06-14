//
//  Ajustes.swift
//  tabviewcontroller
//
//  Created by henrique on 16/01/2018.
//  Copyright © 2018 Mark Hoath. All rights reserved.
//

import UIKit

class Ajuste{
    let editoriaId:Int
    let name:String
    let description:String
    let color:UIColor
    init(editoriaId:Int , name:String , description:String , color:UIColor) {
        self.editoriaId = editoriaId
        self.name = name
        self.description = description
        self.color = color
    }
}
