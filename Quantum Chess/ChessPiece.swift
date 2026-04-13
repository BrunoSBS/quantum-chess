//
//  ChessPiece.swift
//  Quantum Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//
import Foundation

import Foundation

struct ChessPiece: Hashable {
    let col: Int
    let row: Int
    let ImageName: String
    let isWhite: Bool // true: White, false: Black
    let isLeft: Bool // true: occupies left side of square, false: on right side
    let isLeaving: Bool // true: is tentative departure square, false: default
    let isArriving: Bool // true: is tentative destination square, false: default
    
    // Default initialisation
    init (col: Int, row: Int, ImageName: String, isWhite: Bool, isLeft: Bool){
        self.col = col
        self.row = row
        self.ImageName = ImageName
        self.isWhite = isWhite
        self.isLeft = isLeft
        isLeaving = false
        isArriving = false
    }
    
    // Initialisation when we want to specify isTentative, isGhost
    init (col: Int, row: Int, ImageName: String, isWhite: Bool, isLeft: Bool, isLeaving: Bool, isArriving: Bool){
        self.col = col
        self.row = row
        self.ImageName = ImageName
        self.isWhite = isWhite
        self.isLeft = isLeft
        self.isLeaving = isLeaving
        self.isArriving = isArriving
    }

    
}

//TODO: insert extra features of piece for cleaner separation of presentation (ImageName) and internal identity (distinguishing it from other pieces of same type, and remaining the same under image being modified)
