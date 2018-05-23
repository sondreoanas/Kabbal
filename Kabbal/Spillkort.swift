//
//  Spillkort.swift
//  Kabbal
//
//  Created by Sondre Oanæs on 09.06.2016.
//  Copyright © 2016 Sondre Oanæs. All rights reserved.
//

import SpriteKit

class Spillkort : SKSpriteNode {
    let frontTexture: SKTexture
    let backTexture: SKTexture
    
    var snudd: Bool
    var hand: Bool
    var finish: Bool
    let type: String
    let nummer: Int
    
    var posRad: Int
    var posCol: Int
    
    init(type: String, nummer: Int) {
        if nummer == 53 {
            self.nummer = 53
            self.snudd = true
            self.backTexture = SKTexture(imageNamed: "backside")
            self.frontTexture = SKTexture(imageNamed: "backside")
            
            self.posRad = -1
            self.posCol = -1
            
            if (type == "Tom") {
                self.type = "Tom"
                self.hand = false
                self.finish = false
                super.init(texture: backTexture, color: .red, size: backTexture.size())
                colorBlendFactor = 1.0
                self.alpha = 0.5
            } else {
                if (type == "Finish") {
                    self.type = "Finish"
                    self.hand = false
                    self.finish = true
                    super.init(texture: backTexture, color: .black, size: backTexture.size())
                    self.colorBlendFactor = 1.0
                    self.alpha = 0.5
                } else {
                    self.type = "Hand"
                    self.hand = true
                    self.finish = false
                    super.init(texture: backTexture, color: .clear, size: backTexture.size())
                }
            }
        } else {
            snudd = false
            self.hand = false
            self.finish = false
            self.type = type
            self.nummer = nummer
            self.backTexture = SKTexture(imageNamed: "backside")
        
            self.posRad = -1
            self.posCol = -1
        
            var resultat = ""
            resultat.append(String(nummer))
            resultat.append(type)
            self.frontTexture = SKTexture(imageNamed: resultat)
        
            super.init(texture: frontTexture, color: .clear, size: backTexture.size())
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func snu() {
        snudd = true
    }
    
    func move(_ spillkort: Spillkort) -> Bool {
        if spillkort.snudd && self.snudd {
            if self.finish { return false }
            if spillkort.finish {
                if self.nummer == spillkort.nummer + 1 && self.type == spillkort.type { return true }
                else { if self.nummer == 1 && spillkort.type == "Finish" { return true }
                else { return false }
                }
            }
            if self.nummer == 13 && spillkort.type == "Tom" {return true}
            if spillkort.type == "hjerter" || spillkort.type == "ruter" {
                if spillkort.nummer == self.nummer + 1 && (self.type == "klover" || self.type == "spar") {
                    return true
                } else {return false}
            } else {
                if spillkort.nummer == self.nummer + 1 && (self.type == "hjerter" || self.type == "ruter") { return true
                } else {return false}
            }
        } else {return false}
    }
}
