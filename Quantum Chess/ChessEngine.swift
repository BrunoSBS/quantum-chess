//
//  ChessEngine.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import Foundation

struct ChessEngine {
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int){
        
        
        
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return
        }
        
        // If there is a piece in the square moved to (of _any_ colour), then it is removed
        // TODO: add colour as a variable(?) in the ChessPiece class
        if let capturedPiece = pieceAt(col: toCol, row: toRow){
            pieces.remove(capturedPiece)
            
        }
        
        //TODO: Understand why we can't just change position
        pieces.remove(movingPiece)
        

        
        pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: movingPiece.ImageName))
        
        
    }
    
    func pieceAt(col: Int, row: Int) -> ChessPiece?{
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece
            }
        }
        return nil
    }
    
    mutating func initializeGame(){
        pieces.removeAll()
        
        pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Rook-Black"))
        pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Knight-Black"))
        pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Bishop-Black"))
        pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Queen-Black"))
        pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "King-Black"))
        pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Bishop-Black"))
        pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Knight-Black"))
        pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Rook-Black"))
        
        pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Rook-White"))
        pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Knight-White"))
        pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Bishop-White"))
        pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Queen-White"))
        pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "King-White"))
        pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Bishop-White"))
        pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Knight-White"))
        pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Rook-White"))
        
        for i in 0..<8{
            pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Pawn-Black"))
            pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Pawn-White"))
        }

        
    }
}
