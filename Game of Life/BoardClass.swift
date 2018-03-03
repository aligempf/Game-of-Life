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
    let stepNumber: Int
    private var cellBoard: Set<Cell>
    var board: Set<Cell> {
        get {
            return cellBoard
        }
    }
    var maxCellValues: [Int] {
        var maxCellValues = [Int](repeating: 0, count: dimensions)
        for cell in self.cellBoard {
            let position = cell.position.position
            for dimension in 0..<dimensions {
                if abs(position[dimension]) > maxCellValues[dimension] {
                    maxCellValues[dimension] = abs(position[dimension])
                }
            }
        }
        return maxCellValues
    }
    subscript(index: Position) -> Cell {
        get {
            for count in 0..<index.dimensions {
                // if any of the dimensions of the requested position are higher than the boundary the cell is dead
                let position = index.position[count]
                if let boundary = boundaries[count] {
                    if abs(position) > abs(boundary) {
                        return Cell(position: index)
                    }
                }
            }
            // check if cell exists, if it does, then just return cell, otherwise it's dead and should return a dead cell
            if (cellBoard.contains(Cell(position: index))) {
                return Cell(position: index)
            } else if (cellBoard.contains(Cell(position: index, initState: true))) {
                return Cell(position: index, initState: true)
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
            for cell in cellBoard {
                if cell.position == index {
                    cell.state = value.state
                }
            }
            // if the cell doesn't already exist, we should add all its neighbours too to ensure they are evaluated in the next stage
            outerLoop: for neighbour in index.neighbouringPositions {
                let neighbourCellTrue = Cell(position: neighbour, initState: true)
                if !self.cellBoard.contains(neighbourCellTrue) {
                    self.cellBoard.insert(Cell(position: neighbour))
                }
            }
            cellBoard.insert(value)
        }
    }
    subscript(index: [Int]) -> Cell {
        get {
            return self[Position(position: index)]
        }
        set(value) {
            self[Position(position: index)] = value
        }
    }
    
    init(dimensions: Int, upTo boundaries: [Int?], cellBoard: Set<Cell> = Set<Cell>(), stepNumber: Int = 0) {
        self.dimensions = dimensions
        self.cellBoard = cellBoard
        self.boundaries = boundaries
        self.stepNumber = stepNumber
    }
    
    convenience init(dimensions: Int, cellBoard: Set<Cell> = Set<Cell>(), stepNumber: Int = 0) {
        self.init(dimensions: dimensions, upTo: [Int?](repeatElement(nil, count: dimensions)), cellBoard: cellBoard, stepNumber: stepNumber)
    }
    
    convenience init(dimensions: Int, stepNumber: Int = 0) {
        self.init(dimensions: dimensions, upTo: [Int?](repeatElement(nil, count: dimensions)), cellBoard: Set<Cell>(), stepNumber: stepNumber)
    }
    
    convenience init(dimensions: Int, upTo boundaries: [Int?], liveCells positions: [[Int]], stepNumber: Int = 0) {
        var cellBoard = Set<Cell>()
        for position in positions {
            cellBoard.insert(Cell(position: position, initState: true))
        }
        self.init(dimensions: dimensions, upTo: boundaries, cellBoard: cellBoard, stepNumber: stepNumber)
    }
    
    convenience init(dimensions: Int, liveCells positions: [[Int]], stepNumber: Int = 0) {
        var cellBoard = Set<Cell>()
        for position in positions {
            cellBoard.insert(Cell(position: position, initState: true))
        }
        self.init(dimensions: dimensions, upTo: [Int?](repeatElement(nil, count: dimensions)), cellBoard: cellBoard, stepNumber: stepNumber)
    }
    
    func nextStep() -> Board {
        let nextBoard = Board(dimensions: dimensions, upTo: boundaries, stepNumber: stepNumber+1)
        
        for cell in cellBoard {
            nextBoard[cell.position] = cell.step(from: self)
        }
        nextBoard.pruneCells()
        return nextBoard
    }
    
    func pruneCells() {
        // remove dead cells that definitely remain dead to prevent infinite increase of the board size
        var prunedBoard = Set<Cell>()
        for cell in cellBoard {
            if cell.state {
                // if the cell is live we should not get rid of it
                prunedBoard.insert(cell)
                continue
            }
            for neighbour in cell.position.neighbouringPositions {
                if self[neighbour].state {
                    // if cell has a live neighbour, it could turn live next step so keep it
                    prunedBoard.insert(cell)
                    break
                }
            }
        }
        self.cellBoard = prunedBoard
    }
}
