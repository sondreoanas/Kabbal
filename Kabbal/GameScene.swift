//
//  GameScene.swift
//  Kabbal
//
//  Created by Sondre Oanæs on 09.06.2016.
//  Copyright (c) 2016 Sondre Oanæs. All rights reserved.
//

import SpriteKit


var KortRaderMain = Solitire()
var fixedPos = [[CGPoint]]()
var finishPos = [CGPoint]()
var handPos = [CGPoint]()

var z = 0
var curCards = [Spillkort]()

let backgroundColorCostume = UIColor.orange

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = backgroundColorCostume
        
        // Posisjons oppsett
        
        KortRaderMain.getSpillkortInRad(0, kort: 0).setScale(0.7)
        let w = KortRaderMain.getSpillkortInRad(0, kort: 0).size.width
        let h = KortRaderMain.getSpillkortInRad(0, kort: 0).size.height
        let a = 305 + w/2
        
        for i in 0...6 {
            fixedPos.append([CGPoint]())
            for j in 0...(i+13) {
                fixedPos[i].append(CGPoint(x: a + CGFloat(Int(w+10)*i),y: CGFloat(650) - h - CGFloat(15*j)))
            }
        }
        
        for i in 0...3 {
            finishPos.append(CGPoint(x: fixedPos[3 + i][0].x, y: CGFloat(700)))
        }
        
        for i in 0...2 {
            handPos.append(CGPoint(x: fixedPos[4][0].x + CGFloat(Int(20)*i), y: CGFloat(75)))
        }
 
        
        
        // Kort oppsett
        
        for i in 0...6 {
            let baseKort = Spillkort(type: "Tom", nummer: 53)
            baseKort.setScale(0.7)
            baseKort.position = fixedPos[i][0]
            baseKort.posRad = i
            baseKort.posCol = 0
            baseKort.zPosition = CGFloat(z)
            addChild(baseKort)
            z += 1
            for j in 0...i {
                let kortet = KortRaderMain.getSpillkortInRad(i, kort: j)
                kortet.setScale(0.7)
                kortet.position = fixedPos[i][j]
                kortet.zPosition = CGFloat(z)
                if !kortet.snudd { kortet.texture = kortet.backTexture }
                addChild(kortet)
                z += 1
            }
        }

        // Hånd oppsett
        for i in 0...2 {
            let kortet = KortRaderMain.getSpillkortInHand(0, kort: i)
            kortet.setScale(0.7)
            kortet.position = handPos[i]
            kortet.zPosition = CGFloat(z)
            addChild(kortet)
            z += 1
        }
        // resten av hånda

        for i in 1...7 {
            for j in 0...2 {
                let kortet = KortRaderMain.getSpillkortInHand(i, kort: j)
                kortet.setScale(0.7)
                kortet.position = CGPoint(x: 2000, y: 2000)
                //addChild(kortet)
            }
        }

        // Tomme sluttrader
        for i in 0...3 {
            let kortet = Spillkort(type: "Finish", nummer: 53)
            kortet.setScale(0.7)
            kortet.position = finishPos[i]
            kortet.posRad = i
            kortet.posCol = 0
            kortet.zPosition = CGFloat(z)
            addChild(kortet)
            z += 1
        }
        let kortet = Spillkort(type: "Hand", nummer: 53)
        kortet.setScale(0.7)
        kortet.position = CGPoint(x: fixedPos[6][0].x, y: CGFloat(75))
        kortet.zPosition = CGFloat(z)
        addChild(kortet)
        z += 1
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if let kortet = atPoint(location) as? Spillkort {
                if curCards.isEmpty {
                    if !(kortet.nummer == 53) {
                        curCards = KortRaderMain.multiMoveFinder(kortet)
                    } else {
                        if kortet.type == "Hand" {
                            KortRaderMain.handOppsett(<#T##curHand: Int##Int#>)
                        }
                    }
                    if !(kortet.type == "Finish") || !(curCards[0].nummer == 53) {
                        for kort in curCards {
                            kort.color = .green
                            kort.colorBlendFactor = 0.5
                        }
                    }
                } else {
                    if !curCards[0].finish && !curCards[0].finish {
                        for kort in curCards {
                            kort.colorBlendFactor = 0
                        }
                    }
                    if curCards[0].move(kortet) {
                        if kortet.finish {
                            if curCards.count < 2 {
                                curCards[0].position = finishPos[kortet.posRad]
                                curCards[0].zPosition = kortet.zPosition + CGFloat(1)
                                KortRaderMain.move(curCards[0], nyttKort: kortet)
                            }
                        } else {
                            var i = 1
                            var j = 1
                            if kortet.type == "Tom" { i = 0 }
                            for kort in curCards {
                                kort.position = fixedPos[kortet.posRad][kortet.posCol + i]
                                kort.zPosition = kortet.zPosition + CGFloat(j)
                                KortRaderMain.move(kort, nyttKort: kortet)
                                i += 1
                                j += 1
                            }
                        }
                    }
                    curCards = [Spillkort]()
                }
            }
        }
    }
}



/*
 - making snudd static objects
 - fixe snuddboolen
 - sjekke move av ikke snudde objcts
 - designe hele UI-en
 -
 
 - kortene på hånda
 - move functions include empty arrays
 - faste plasser
 - animasjoner
 - meny og instillinger
 */
