//
//  utils.swift
//  ZenTheaSource
//
//  Created by felix on 03/02/2025.
//

import Foundation

/// recuperer la date formattée sous forme de chaine
func getFormattedDate(_ date : Date? = Date(),_ isLocal:Bool=true)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    if(isLocal){
        //= Locale(identifier: "fr_FR")
        dateFormatter.locale = Locale.current
    }
    return dateFormatter.string(from: date!)
}

/// lorsque l'on travaile avec des liste et que l'on veut accéder a un
/// élément on éviter de parcourir tout le tableau jusq'a l'index trouvé
/// on utilise cette approche
/// paramètre 1 liste d'objets, 2 fonction anonyme qui donne l'attribut
/// qui nous intéresse de comparer (uniquement type primitifs)
/// renvoie l'indice sous un nombre int de la liste
func rechercheDichotomique(_ list: [AnyObject],_ searchFor: (AnyObject) -> Any)->Int{
    var res : Int = 0
    
    // a implémenter
    return res
}
<<<<<<< HEAD

/// color ration between 0 and 1 from color number (from 0 to 255)
func colorRatio(_ colorValue: CGFloat)->CGFloat{
    return colorValue/255.0
}


=======
>>>>>>> main
