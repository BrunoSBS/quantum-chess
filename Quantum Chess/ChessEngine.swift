//
//  ChessEngine.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import Foundation

struct ChessEngine {
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    var whitesTurn: Bool = true
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int){
        
        
        
        // Check there is a piece at the place we started our touch
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return
        }
        
        
        // Check that move is legal in terms of starting and ending on different squares - is this where we put legal moves in also?
        if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: fromCol, toRow: toRow,pieceIsWhite: movingPiece.isWhite){
            return
        }
        

        // Check if we move to allied piece - if so, we cancel move
        if let targetPiece = pieceAt(col: toCol, row: toRow){
            if (targetPiece.isWhite == movingPiece.isWhite){
                return
            }
            //pieces.remove(targetPiece)
        }
        
    
        // Remove piece at start, add it at end TODO: Understand why we can't just change position
        pieces.remove(movingPiece)
        pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: movingPiece.ImageName,isWhite: movingPiece.isWhite))
        
        // If we've made it here, hopefully we made a move
        whitesTurn = !whitesTurn
        
    }
    
    
    func canMovePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int, pieceIsWhite: Bool)->Bool{
        
        // Check if start and end position are same
        if (fromCol==toCol && fromRow == toRow){
            return false
        }
        
        // Check that it is your turn
        if !(whitesTurn==pieceIsWhite){
            return false
        }
        
        return true
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
        
        whitesTurn = true
        
        
        //pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Rook-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Half1Rook-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Half2Rook-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Knight-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Half1Knight-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Half2Knight-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Bishop-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Half1Bishop-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Half2Bishop-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Queen-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Half1Queen-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Half2Queen-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "King-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "Half1King-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "Half2King-Black",isWhite: false))
       // pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Bishop-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Half1Bishop-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Half2Bishop-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Knight-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Half1Knight-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Knight-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Rook-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Half1Rook-Black",isWhite: false))
        pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Half2Rook-Black",isWhite: false))
        //pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Rook-White",isWhite: true))
        pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Half1Rook-White",isWhite: true))
        pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Half2Rook-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Knight-White",isWhite: true))
        pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Half1Knight-White",isWhite: true))
        pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Half2Knight-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Bishop-White",isWhite: true))
        pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Half1Bishop-White",isWhite: true))
        pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Half2Bishop-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Queen-White",isWhite: true))
        pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Half1Queen-White",isWhite: true))
        pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Half2Queen-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "King-White",isWhite: true))
        pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "Half1King-White",isWhite: true))
        pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "Half2King-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Bishop-White",isWhite: true))
        pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Half1Bishop-White",isWhite: true))
        pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Half2Bishop-White",isWhite: true))
       // pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Knight-White",isWhite: true))
        pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Half1Knight-White",isWhite: true))
        pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Half2Knight-White",isWhite: true))
        //pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Rook-White",isWhite: true))
        pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Half1Rook-White",isWhite: true))
        pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Half2Rook-White",isWhite: true))
        
        for i in 0..<8{
            //pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Pawn-Black",isWhite: false))
            pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Half1Pawn-Black",isWhite: false))
            pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Half2Pawn-Black",isWhite: false))
            //pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Pawn-White",isWhite: true))
            pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Half1Pawn-White",isWhite: true))
            pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Half2Pawn-White",isWhite: true))
        }
        
    }
}
