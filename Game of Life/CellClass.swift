//
//  CellClass.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

class Cell: Hashable {
    var state: Bool
    let position: Position
    var hashValue: Int {
        get {
            return state ? Set(position.position + [1]).hashValue  : Set(position.position + [0]).hashValue
        }
    }
    
    init(position: Position, initState: Bool = false) {
        self.state = initState
        self.position = position
    }
    
    convenience init(position: [Int], initState: Bool = false) {
        self.init(position: Position(position: position), initState: initState)
    }
    
    func step(from currentBoardState: Board) -> Cell {
        var liveNeighbours = 0
        var nextStepCell: Cell
        for neighbour in position.neighbouringPositions {
            if currentBoardState[neighbour].state {
                liveNeighbours += 1
            }
        }
        switch liveNeighbours {
        case 2:
            nextStepCell = Cell(position: position, initState: state)
        case 3:
            nextStepCell = Cell(position: position, initState: true)
        default:
            nextStepCell = Cell(position: position, initState: false)
        }
        return nextStepCell
    }
}

func ==(left: Cell, right: Cell) -> Bool{
    return left.state == right.state && left.position == right.position
}
