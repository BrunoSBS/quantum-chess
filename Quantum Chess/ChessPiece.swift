//
//  ChessPiece.swift
//  Quantum Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//
import Foundation

struct ChessPiece: Hashable {
    let col: Int
    let row: Int
    let ImageName: String
    let isWhite: Bool // true: White, false: Black

}

