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
}

