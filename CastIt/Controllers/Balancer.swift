//
//  Balancer.swift
//  Enemy Spawn
//
//  Created by Paulo Tadashi Tokikawa on 31/01/22.
//

import Foundation

class Balancer {
    let start:Double
    let range:Double
    let time:Double
    let step: Double
    let ascending:Bool
    let startFast:Bool
    
    var currentTime:Int
    var total:Double
    var end:Bool = false
    
    
    init(start:Int, range: Int, time: Int, ascending: Bool, startFast:Bool){
        self.start = Double(start)
        self.total = Double(start)
        self.range = Double(range)
        self.time = Double(time)
        self.step = ((2 * Double(range))/self.time)/self.time
        self.ascending = ascending
        self.startFast = startFast
        
        if startFast {
            currentTime = time
        }
        else {
            currentTime = 0
        }
    }
    
    func reset(){
        if startFast {
            currentTime = Int(time)
        }
        else {
            currentTime = 0
        }
        total = start
    }
    
//        bal = Balancer(start: 3, range: 2, time: 300, ascending: false, startFast: true)
    func nextStep() -> Double{
        
        if startFast {
            currentTime -= 1
        }
        else {
            currentTime += 1
        }
        if ascending{
            if startFast {
                if currentTime < 0{
                    return start + range
                }
            }
            else {
                if Double(currentTime) > time{
                    return start + range
                }
            }
            total += step * Double(currentTime)
        }
        else {
            if startFast {
                if currentTime < 0{
                    return start - range
                }
            }
            else {
                if Double(currentTime) > time{
                    return start - range
                }
            }
            total -= step * Double(currentTime)
        }
        
        return total
    }
}
