//
//  Board.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

class Board {
    let dimensions: Int
    let boundaries: [Int?]
    private var cellBoard: [Cell]
    var board: [Cell] {
        get {
            return cellBoard
        }
    }
    subscript(index: Position) -> Cell {
        get {
            for count in 0..<index.position.count {
                // if any of the dimensions of the requested position are higher than the boundary the cell is dead
                let position = index.position[count]
                if let boundary = boundaries[count] {
                    if abs(position) > abs(boundary) {
                        return Cell(position: index)
                    }
                }
            }
            // check if cell exists, if it does, then just return cell, otherwise it's dead and should return a dead cell
            for cell in cellBoard {
                if cell.position == index {
                    return cell
                }
            }
            return Cell(position: index)
        }
        set(value) {
            for count in 0..<index.position.count {
                // if any of the dimensions of the requested position are higher than the boundary the cell is dead
                let position = index.position[count]
                if let boundary = boundaries[count] {
                    if abs(position) > abs(boundary) {
                        return
                    }
                }
            }
            
            // if the cell already exists, set the cell to the value
            var inAlready = false
            for cell in cellBoard {
                if cell.position == index {
                    cell.state = value.state
                    inAlready = true
                }
            }
            // if the cell doesn't already exist, we should add all its neighbours too to ensure they are evaluated in the next stage
            outerLoop: for neighbour in index.neighbouringPositions {
                for cell in cellBoard {
                    if cell.position == neighbour {
                        continue outerLoop
                    }
                }
                self.cellBoard.append(Cell(position: neighbour))
            }
            if !inAlready {
                cellBoard.append(value)
            }
        }
    }
    
    init(dimensions: Int, upTo boundaries: [Int?], cellBoard: [Cell] = [Cell]()) {
        self.dimensions = dimensions
        self.cellBoard = cellBoard
        self.boundaries = boundaries
    }
    
    convenience init(dimensions: Int, cellBoard: [Cell] = [Cell]()) {
        self.init(dimensions: dimensions, upTo: [Int?](repeatElement(nil, count: dimensions)), cellBoard: cellBoard)
    }
    
    func nextStep() -> Board {
        let nextBoard = Board(dimensions: dimensions)
        
        for cell in cellBoard {
            nextBoard[cell.position] = cell.step(from: self)
        }
        nextBoard.pruneCells()
        return nextBoard
    }
    
    func pruneCells() {
        // remove dead cells that definitely remain dead to prevent infinite increase of the board size
        var prunedBoard = [Cell]()
        for cell in cellBoard {
            if cell.state {
                // if the cell is live we should not get rid of it
                prunedBoard.append(cell)
                continue
            }
            for neighbour in cell.position.neighbouringPositions {
                if self[neighbour].state {
                    // if cell has a live neighbour, it could turn live next step so keep it
                    prunedBoard.append(cell)
                    break
                }
            }
        }
        self.cellBoard = prunedBoard
    }
}
