//
//  BoardConsoleView.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

func stringBoardState(for board: Board, upTo boundaries: [Int]) -> String {
    var boardState = "Board at step " + String(board.stepNumber) + "\n"
    for y in (-boundaries[1]...boundaries[1]).reversed() {
        for x in -boundaries[0]...boundaries[0] {
            if board[[x,y]].state {
                boardState += "x"
            } else {
                boardState += "."
            }
        }
        boardState += "\n"
    }
    return boardState
}

func stringBoardState(for board: Board, upTo boundaries: Int) -> String {
    return stringBoardState(for: board, upTo: [Int](repeating: boundaries, count: board.dimensions))
}

func stringBoardState(for board: Board) -> String {
    return stringBoardState(for: board, upTo: board.maxCellValues)
}

func stringCellPositions(board: Board) -> String {
    var cellPositions = ""
    for cell in board.board {
        cellPositions += String(describing: cell.position)
        cellPositions += "\n"
    }
    return cellPositions
}
