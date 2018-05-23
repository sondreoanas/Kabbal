//
//  Kortstokk.swift
//  Kabbal
//
//  Created by Sondre Oanæs on 09.06.2016.
//  Copyright © 2016 Sondre Oanæs. All rights reserved.
//

import Foundation
var kort = 0

class Kortstokk {
    var stokk = [Spillkort]()
    
    
    init () {
        let type = ["hjerter","ruter","spar","klover"]
        for typen in type {
            for index in 1...13 {
                self.stokk.append(Spillkort(type: typen,nummer: index))
            }
        }
    }

    
    func shuffle() {
        var hjelpestokk = [Spillkort]()
        
        for _ in 1...52 {
            hjelpestokk.append(Spillkort(type: "hjelp",nummer: 0))
        }
        
        for spillkort in stokk {
            while kort < 30 {
                let random = Int(arc4random_uniform(52))
                if hjelpestokk[random].snudd == false {
                    stokk[kort] = stokk[random]
                    stokk[random] = spillkort
                    hjelpestokk[random].snu()
                    hjelpestokk[kort].snu()
                    break
                }
            }
            kort += 1
        }
        for spillkort in stokk {
            spillkort.snudd = false
        }
    }
}
