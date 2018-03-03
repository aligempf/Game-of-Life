//
//  main.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

import Foundation

let numSteps = 5
let maxBoundary = 10
/*var p = [[Int]]()
for x in -maxBoundary/2...maxBoundary/2 {
    for y in -maxBoundary/2...maxBoundary/2 {
        if arc4random_uniform(2) == 1 {
            p.append([x,y])
        }
    }
}*/
let p = [[0,0],[1,0],[-1,0]]
var b = Board(dimensions: 2, upTo: [maxBoundary, maxBoundary])

for position in p {
    b[position] = Cell(position: position, initState: true)
}

if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    var fileURL = dir.appendingPathComponent("Step" + String(b.stepNumber) + ".txt")
    
    var boardState = stringBoardState(for: b, upTo: maxBoundary)
    print(boardState)
    try boardState.write(to:fileURL, atomically: false, encoding: .utf8)
    
    for _ in 1...numSteps {
        b = b.nextStep()
        boardState = stringBoardState(for: b, upTo: maxBoundary)
        print(boardState)
        fileURL = dir.appendingPathComponent("Step" + String(b.stepNumber) + ".txt")
        try boardState.write(to: fileURL, atomically: false, encoding: .utf8)
        /*let response = readLine()
        if response == "q" {
            break
        }*/
    }
}
