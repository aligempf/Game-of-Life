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
var p = [[Int]]()
for x in -maxBoundary/2...maxBoundary/2 {
    for y in -maxBoundary/2...maxBoundary/2 {
        if arc4random_uniform(2) == 1 {
            p.append([x,y])
        }
    }
}
//let p = [[0,0],[1,0],[1,1],[0,1]]
var b = Board(dimensions: 2, upTo: [maxBoundary, maxBoundary])

for position in p {
    b[position] = Cell(position: position, initState: true)
}
print(stringBoardState(for: b, upTo: maxBoundary))

while true {
    b = b.nextStep()
    print(stringBoardState(for: b, upTo: maxBoundary))
    let response = readLine()
    if response == "q" {
        break
    }
}
