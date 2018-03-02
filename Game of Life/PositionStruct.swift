//
//  PositionStruct.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

enum Dimension: Int {
    case x = 0, y, z
}

struct Position {
    let position: [Int]
    var neighbouringPositions: [Position] {
        get {
            var neighbouring = [self]
            for dimension in 0..<position.count {
                let currentNeighbouring = neighbouring
                let plusOne = Position(1, at: dimension, of: self.position.count)
                let minusOne = Position(-1, at: dimension, of: self.position.count)
                for neighbouringPosition in currentNeighbouring {
                    neighbouring.append(neighbouringPosition + plusOne)
                    neighbouring.append(neighbouringPosition + minusOne)
                }
            }
            neighbouring.remove(at: 0)
            return neighbouring
        }
    }
    init(_ dimensionLength: Int, at dimension: Int, of numberOfDimensions: Int) {
        var position = [Int](repeating: 0, count: numberOfDimensions)
        position[dimension] = dimensionLength
        self.position = position
    }
    init(position: [Int]) {
        self.position = position
    }
}

func +(left: Position, right: Position) -> Position {
    var sum = [Int]()
    let larger = left.position.count > right.position.count ? left : right
    let smaller = left.position.count > right.position.count ? right : left
    
    for count in 0..<smaller.position.count {
        sum.append(left.position[count] + right.position[count])
    }
    
    for count in smaller.position.count..<larger.position.count {
        sum.append(larger.position[count])
    }
    return Position(position: sum)
}
