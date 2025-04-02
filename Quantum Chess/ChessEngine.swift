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
    var firstHalfTurn: Bool = true
    
    // Putting a half-piece into a square with two opposing half-pieces leads to `conflict' squares that must be tracked.
    var conflict1Row: Int = -1
    var conflict1Col: Int = -1
    var conflict2Row: Int = -1
    var conflict2Col: Int = -1
    
    mutating func movePiece(fromCol: Int, fromRow: Int, isLeftBegin: Bool, toCol: Int, toRow: Int){
        
        
        // Check there is a piece at the place we started our touch
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow, isLeft: isLeftBegin) else {
            return
        }
        
        
        // Check that move is legal in terms of starting and ending on different squares - is this where we put legal moves in also?
        if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: fromCol, toRow: toRow,pieceIsWhite: movingPiece.isWhite){
            return
        }
        

        // Check occupants of target square
        if let targetPieceLeft = pieceAt(col: toCol, row: toRow, isLeft: true){
            print(targetPieceLeft.ImageName)
            if let targetPieceRight = pieceAt(col: toCol, row: toRow, isLeft: false){
                print(targetPieceRight.ImageName)
                print(" have found two pieces in square")
                // Check if the target square is fully occupied by allied half-pieces - if so, we cancel move
                if (targetPieceLeft.isWhite == movingPiece.isWhite && targetPieceRight.isWhite == movingPiece.isWhite){
                    return
                }
                
                // if target square is half-occupied, occupy other half
                if (false){
                    //
                }
                // if target square is occupied by two opposing pieces, record square as it will be important
                if (targetPieceLeft.isWhite == targetPieceRight.isWhite){
                    if firstHalfTurn{
                        conflict1Col = toCol
                        conflict1Row = toRow
                    }
                    if (!firstHalfTurn) {
                        conflict2Col = toCol
                        conflict2Row = toRow
                    }
                    print("waiting to be resolved")
                }
                
                // if target square is occupied by two opposite pieces, replace the one of opposite colour
                if (targetPieceLeft.isWhite != targetPieceRight.isWhite){
                    print("left not right")
                    if (targetPieceLeft.isWhite != movingPiece.isWhite){
                        pieces.remove(targetPieceLeft)
                        print("left deleted")
                    }
                    if (targetPieceRight.isWhite != movingPiece.isWhite){
                        pieces.remove(targetPieceRight)
                        print("right deleted")
                    }
                }
                
            }
            
            //pieces.remove(targetPiece)
        }
        print("completed check of target square")
    
        
        
        
        // Remove piece at start, add it at end TODO: Understand why we can't just change position
        pieces.remove(movingPiece)
        pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: isLeftBegin))
        // TODO: need to insert piece in left or right depending if space is already occupied
        
        // Resolve conflicts
        // if one conflict: collapse
        // if two conflicts: collapse in either order
        // if both conflicts in same place: capture piece
        
        // If we've made it here, hopefully we made a move
        
        firstHalfTurn = !firstHalfTurn
        if firstHalfTurn {
            whitesTurn = !whitesTurn
        }
                
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
    
    
    func pieceAt(col: Int, row: Int, isLeft: Bool) -> ChessPiece?{
        for piece in pieces {
            if col == piece.col && row == piece.row && isLeft == piece.isLeft {
                
                return piece
            }
        }
        return nil
    }
    
    mutating func initializeGame(){
        pieces.removeAll()
        
        whitesTurn = true

        pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Half1Rook-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 0, row: 0, ImageName: "Half2Rook-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Half1Knight-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 1, row: 0, ImageName: "Half2Knight-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Half1Bishop-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 2, row: 0, ImageName: "Half2Bishop-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Half1Queen-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 3, row: 0, ImageName: "Half2Queen-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "Half1King-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 4, row: 0, ImageName: "Half2King-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Half1Bishop-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 5, row: 0, ImageName: "Half2Bishop-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Half1Knight-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 6, row: 0, ImageName: "Half2Knight-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Half1Rook-Black",isWhite: false, isLeft: true))
        pieces.insert(ChessPiece(col: 7, row: 0, ImageName: "Half2Rook-Black",isWhite: false, isLeft: false))
        pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Half1Rook-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 0, row: 7, ImageName: "Half2Rook-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Half1Knight-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 1, row: 7, ImageName: "Half2Knight-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Half1Bishop-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 2, row: 7, ImageName: "Half2Bishop-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Half1Queen-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 3, row: 7, ImageName: "Half2Queen-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "Half1King-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 4, row: 7, ImageName: "Half2King-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Half1Bishop-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 5, row: 7, ImageName: "Half2Bishop-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Half1Knight-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 6, row: 7, ImageName: "Half2Knight-White",isWhite: true, isLeft: false))
        pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Half1Rook-White",isWhite: true, isLeft: true))
        pieces.insert(ChessPiece(col: 7, row: 7, ImageName: "Half2Rook-White",isWhite: true, isLeft: false))
        
        for i in 0..<8{
            pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Half1Pawn-Black",isWhite: false, isLeft: true))
            pieces.insert(ChessPiece(col: i, row: 1, ImageName: "Half2Pawn-Black",isWhite: false, isLeft: false))
            pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Half1Pawn-White",isWhite: true, isLeft: true))
            pieces.insert(ChessPiece(col: i, row: 6, ImageName: "Half2Pawn-White",isWhite: true, isLeft: false))
        }
        
    }
}
