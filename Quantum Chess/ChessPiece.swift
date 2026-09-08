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
    let isLeft: Bool // true: occupies left side of square, false: on right side
    let isLeaving: Bool // true: is tentative departure square, false: default
    let isArriving: Bool // true: is tentative destination square, false: default
    let isCaptured: Bool // true: has been captured
    let id: UUID // unique identifier
    let otherHalfId: UUID
    //TODO: otherHalfId = [id of other half piece]
    
    // Default initialisation
    init (col: Int, row: Int, ImageName: String, isWhite: Bool, isLeft: Bool, id: UUID, otherHalfId: UUID){
        self.col = col
        self.row = row
        self.ImageName = ImageName
        self.isWhite = isWhite
        self.isLeft = isLeft
        isLeaving = false
        isArriving = false
        isCaptured = false
        self.id = id
        self.otherHalfId = otherHalfId
    }
    
    // Initialisation when we want to specify isTentative, isGhost
    init (col: Int, row: Int, ImageName: String, isWhite: Bool, isLeft: Bool, isLeaving: Bool, isArriving: Bool, id: UUID, otherHalfId: UUID){
        self.col = col
        self.row = row
        self.ImageName = ImageName
        self.isWhite = isWhite
        self.isLeft = isLeft
        self.isLeaving = isLeaving
        self.isArriving = isArriving
        isCaptured = false
        self.id = id
        self.otherHalfId = otherHalfId
    }

    // Initialisation for captured pieces
    init ( capturedCount: Int, ImageName: String, isWhite: Bool, isLeft: Bool, id: UUID, otherHalfId: UUID){
        self.ImageName = ImageName
        self.isWhite = isWhite
        self.isLeft = isLeft
        isLeaving = false
        isArriving = false
        isCaptured = true
        self.col = capturedCount
        self.row = 9
        self.id = id
        self.otherHalfId = otherHalfId
    }
}


func makeHalfPiecePair(col: Int, row: Int, name: String, isWhite: Bool)->[ChessPiece]{
    let id1 = UUID()
    let id2 = UUID()
    let half1 = ChessPiece(col: col, row: row, ImageName: "Half1" + name,isWhite: isWhite, isLeft: true,id: id1, otherHalfId: id2)
    let half2 = ChessPiece(col: col, row: row, ImageName: "Half2" + name,isWhite: isWhite, isLeft: false, id: id2, otherHalfId: id1)
    return [half1, half2]
}
