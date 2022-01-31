//
//  Balancer.swift
//  Enemy Spawn
//
//  Created by Paulo Tadashi Tokikawa on 31/01/22.
//

import Foundation

//// Lets divide in seconds
//// So, for me to move 2 seconds in 300 seconds
//// And start it faster than slow down
//// I guess 10 is a cool number
//// Every second I'll be upping the number a little bit
//// I have 3000 parts to up a percentage every second
//
//// sn = n(a1 + an) / 2
//// 2 = 300(0 + x) /2
//// 2 = 150x
//// x = 1/75
//var result:Double = 0
//var total:Double = 0
//for _ in 1..<300 {
//    result += ((1/75)/300)
//    total += result
//}
//print(total)
class Balancer {
    let range:Double
    let time:Double
    let step: Double
    init(range: Int, time: Int){
        self.range = Double(range)
        self.time = Double(time)
        self.step = ((2 * Double(range))/self.time)/self.time
    }
}
