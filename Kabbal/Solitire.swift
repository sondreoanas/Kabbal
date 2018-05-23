//
//  Spillet.swift
//  Kabbal
//
//  Created by Sondre Oanæs on 12.06.2016.
//  Copyright © 2016 Sondre Oanæs. All rights reserved.
//

import Foundation
import SpriteKit

class Solitire {
    var rader: [[Spillkort]]
    var hand: [[Spillkort]]
    var finish: [[Spillkort]]
    
    init() {
        let kortstokk = Kortstokk()
        rader = [[Spillkort]]()
        hand = [[Spillkort]]()
        finish = [[Spillkort]]()
        //kortstokk.shuffle()
        var n = 0
        
        // bordet
        for i in 0...6 {
            rader.append([Spillkort]())
            for j in 0...i {
                let kortet = kortstokk.stokk[n]
                rader[i].append(kortet)
                kortet.posRad = i
                kortet.posCol = j
                n += 1
            }
            kortstokk.stokk[n-1].snu()
            
        }

        // hånda
        for i in 0...7 {
            hand.append([Spillkort]())
            for j in 0...2 {
                let kortet = kortstokk.stokk[n]
                hand[i].append(kortet)
                kortet.hand = true
                kortet.posRad = i
                kortet.posCol = j
                kortet.snu()
                n += 1
            }
        }
        
        // finish
        for _ in 0...3 {
            finish.append([Spillkort]())
        }
    }
    
    func getSpillkortInRad(_ rad: Int,kort: Int) -> Spillkort {
        return rader[rad][kort]
    }
    
    func getSpillkortInHand(_ rad: Int,kort: Int) -> Spillkort {
        return hand[rad][kort]
    }
    func move(_ kortet: Spillkort, nyttKort: Spillkort) {
        if kortet.hand && nyttKort.finish {
            hand[kortet.posRad].remove(at: kortet.posCol)
            kortet.posRad = nyttKort.posRad
            kortet.posCol = nyttKort.posCol + 1
            finish[kortet.posRad].append(kortet)
            kortet.hand = false
            kortet.finish = true
            return
        }
        if kortet.finish && !nyttKort.hand {
            finish[kortet.posRad].remove(at: kortet.posCol)
            kortet.posRad = nyttKort.posRad
            kortet.posCol = nyttKort.posCol + 1
            rader[kortet.posRad].append(kortet)
            kortet.finish = false
            return
        }
        if !kortet.hand && nyttKort.finish {
            rader[kortet.posRad].remove(at: kortet.posCol)
            if kortet.posCol > 0 {
                if !rader[kortet.posRad][kortet.posCol - 1].snudd {
                    let bakKort = rader[kortet.posRad][kortet.posCol - 1]
                    bakKort.snu()
                    bakKort.texture = bakKort.frontTexture
                }
            }
            kortet.posRad = nyttKort.posRad
            kortet.posCol = nyttKort.posCol + 1
            finish[kortet.posRad].append(kortet)
            kortet.finish = true
            return
        }
        if kortet.hand && !nyttKort.hand {
            hand[kortet.posRad].remove(at: kortet.posCol)
            kortet.posRad = nyttKort.posRad
            kortet.posCol = nyttKort.posCol + 1
            rader[kortet.posRad].append(kortet)
            kortet.hand = false
            return
        }
        if !kortet.hand && !nyttKort.hand {
            rader[kortet.posRad].remove(at: kortet.posCol)
            if kortet.posCol > 0 {
                if !rader[kortet.posRad][kortet.posCol - 1].snudd {
                    let bakKort = rader[kortet.posRad][kortet.posCol - 1]
                    bakKort.snu()
                    bakKort.texture = bakKort.frontTexture
                }
            }
            kortet.posRad = nyttKort.posRad
            kortet.posCol = nyttKort.posCol + 1
            rader[kortet.posRad].append(kortet)
        }
    }
    
    func rearrangeHand() {
        var nyBonke = [[ Spillkort]]()
        for i in 7...14 {
            for _ in 0...2 {
                if !rader[i].isEmpty {
                    nyBonke[i - 7].append(rader[i][0])
                    rader[i].remove(at: 0)
                } else { continue }
            }
        }
        
        for i in 7...14 {
            for _ in 0...2 {
                if !nyBonke[i].isEmpty {
                    rader[i].append(nyBonke[i][0])
                    nyBonke.remove(at: 0)
                } else { continue }
            }
        }
    }
    
    func handOppsett(_ curHand: Int) {
        var newHand = curHand
        if curHand == 7 || finish[curHand + 1].isEmpty {
            rearrangeHand()
            newHand = 0
        }
        for j in 0...2 {
            let kortet = rader[newHand][j]
            kortet.position = handPos[j]
            kortet.zPosition = CGFloat(z)
            z += 1
        }
    }
    
    func multiMoveFinder (_ kortet: Spillkort) -> [Spillkort] {
        var curCard = kortet
        var flyttKort = [Spillkort]()
        flyttKort.append(kortet)
        while true {
            if rader[curCard.posRad].indices.contains(curCard.posCol + 1) {
                let kort = rader[curCard.posRad][curCard.posCol + 1]
                flyttKort.append(kort)
                curCard = kort
            } else {
                break
            }
        }
        return flyttKort
    }
}
