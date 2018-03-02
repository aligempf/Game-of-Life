//
//  CellClass.swift
//  Game of Life
//
//  Created by Alistair Gempf on 02/03/2018.
//  Copyright © 2018 Alistair Gempf. All rights reserved.
//

class Cell {
    var state: Bool
    let position: Position
    init(position: Position, initState: Bool = false) {
        self.state = initState
        self.position = position
    }
}
