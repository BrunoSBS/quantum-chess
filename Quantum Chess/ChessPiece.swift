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
    //let identity: String // unchanging identity associated to piece
    //?let isGhost: Bool // state marking whether piece is greyed or not?
}

//TODO: insert extra features of piece for cleaner separation of presentation (ImageName) and internal identity (distinguishing it from other pieces of same type, and remaining the same under image being modified)
