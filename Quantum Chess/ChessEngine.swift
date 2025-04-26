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
    
    // We record the destinations of both pieces, their colours and pieces in the respective target squares for the resolve full move function
    var toCol1: Int = -1
    var toCol2: Int = -1
    var toRow1: Int = -1
    var toRow2: Int = -1
    var piece1IsWhite: Bool = true
    var piece2IsWhite: Bool = true
    var targetPieces1: Set<ChessPiece> = Set<ChessPiece>()
    var targetPieces2: Set<ChessPiece> = Set<ChessPiece>()
    
    // the old position of the first half piece moved is also stored
    var ghostPiece: ChessPiece = ChessPiece(col: -1,row: -1, ImageName: "",isWhite: true, isLeft: true)
    var newString: String = ""
    
    mutating func movePiece(fromCol: Int, fromRow: Int, isLeftBegin: Bool, toCol: Int, toRow: Int){
        
        
        // Check there is a piece at the place we started our touch
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow, isLeft: isLeftBegin) else {
            return
        }
        
        
        // Check that move is legal in terms of starting and ending on different squares - is this where we put legal moves in also?
        if !canMovePiece(fromCol: fromCol, fromRow: fromRow, toCol: fromCol, toRow: toRow,pieceIsWhite: movingPiece.isWhite,pieceImageName: movingPiece.ImageName){
            return
        }
        


        // Add target pieces to relevant set
        if firstHalfTurn{
            targetPieces1.removeAll()
            for piece in allPiecesAt(col: toCol, row: toRow){
                targetPieces1.insert(piece)
            }
            
        }
        if !firstHalfTurn{
            targetPieces2.removeAll()
            for piece in allPiecesAt(col: toCol, row: toRow){
                targetPieces2.insert(piece)
            }
        }
        
        
        // Remove piece at start, add it at end TODO: Understand why we can't just change position
        pieces.remove(movingPiece)
        
        // If first half turn, move is done with ghost pieces to make clear move is provisional
        if firstHalfTurn{
            pieces.insert(ChessPiece(col: fromCol, row: fromRow, ImageName: "ghost" + movingPiece.ImageName, isWhite: movingPiece.isWhite, isLeft: movingPiece.isLeft))
            pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: "ghost" + movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: isLeftBegin))
            toCol1 = toCol
            toRow1 = toRow
        }
        
        // If second half turn, make move and clean up
        if !firstHalfTurn{

            if resolveFullMove(toCol1: toCol1, toCol2: toCol, toRow1: toRow1, toRow2: toRow, whitesTurn: whitesTurn, targetPieces1: targetPieces1, targetPieces2: targetPieces2){
                
                // move moving pieces to final destinations and clean up
                completeMove(movingPiece: movingPiece, toCol1: toCol1, toRow1: toRow1, toCol2: toCol, toRow2: toRow)
                
                // switch whose turn it is
                whitesTurn = !whitesTurn
                      
                
            }
            else{
                // move moving pieces back to original places and clean up
                cancelMove(movingPiece: movingPiece, toCol1: toCol1, toRow1: toRow1, fromCol2: fromCol, fromRow2: fromRow)
                
                
            }
            
            
        }
        
        
        // Switch half-move
        firstHalfTurn = !firstHalfTurn


        // TODO: need to insert piece in left or right depending if space is already occupied
        
        // TODO: instead of removing pieces, they should be moved to `dead' area outside board.
          
    }
    
    
    mutating func resolveFullMove(toCol1: Int, toCol2: Int, toRow1: Int, toRow2: Int, whitesTurn: Bool, targetPieces1: Set<ChessPiece>, targetPieces2: Set<ChessPiece>)->Bool{

        //if two half-pieces move to same square...
        if (toCol1 == toCol2 && toRow1 == toRow2){
            //...and  target pieces are all of opposite colour, delete all target pieces and make move.
            if targetPieces1.allSatisfy({$0.isWhite != whitesTurn}){
                print("Capture")
                for piece in targetPieces1{
                    pieces.remove(piece)
                }
                
            }
            // if two half-pieces move to same square, but at least one target piece is the opposite colour, cancel move.
            else{
                print("Cancel")
                // cancels move of first piece
                for piece in allPiecesAt(col: toCol1, row: toRow1){
                    if (piece.ImageName.prefix(5)=="ghost"){
                        pieces.remove(piece)
                    }
                }
                //cancels move of second piece
                return false
            }
            
            
            
        }

        
        // if two half-pieces move to different squares, they are resolved independently
        else{
            print("Two separate squares")
            // First 1 and then 2, so turn order currently matters
            //TODO: Make order of resolution player choice
            resolveHalfMove(col: toCol1, row: toRow1, whitesTurn: whitesTurn, targetPieces: targetPieces1)
            resolveHalfMove(col: toCol2, row: toRow2, whitesTurn: whitesTurn, targetPieces: targetPieces2)
            
            // Currently, always cancel move
            // TODO: correct checks for legality
            return false
        }
        
        return true
        
        
    }
    
    mutating func resolveHalfMove(col: Int, row: Int, whitesTurn: Bool, targetPieces: Set<ChessPiece>){
        for piece in targetPieces{
            print(piece.ImageName)
        }
        
    }
    
    
    mutating func completeMove(movingPiece: ChessPiece, toCol1: Int, toRow1: Int,toCol2: Int, toRow2: Int){
        
        // move second half-piece into square
        pieces.insert(ChessPiece(col: toCol2, row: toRow2, ImageName: movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: movingPiece.isLeft))

        // replace ghost piece in target square with normal half-piece
        for piece in allPiecesAt(col: toCol1, row: toRow1){
            if (piece.ImageName.prefix(5)=="ghost"){
                let newString = piece.ImageName.replacingOccurrences(of: "ghost", with: "", options: .regularExpression, range: nil)
                pieces.insert(ChessPiece(col: toCol1, row: toRow1, ImageName: newString, isWhite: piece.isWhite, isLeft: piece.isLeft))
            }
        }
            
        // remove all ghost pieces remaining
        for piece in pieces{
            if (piece.ImageName.prefix(5)=="ghost"){
                pieces.remove(piece)
            }
        }
    }
    
    mutating func cancelMove(movingPiece: ChessPiece, toCol1: Int, toRow1: Int, fromCol2: Int, fromRow2: Int){
        
        // remove ghost piece at target square
        for piece in allPiecesAt(col: toCol1, row: toRow1){
            if (piece.ImageName.prefix(5)=="ghost"){
                pieces.remove(piece)
            }
        }
        
        // replace movingpiece at start square
        pieces.insert(ChessPiece(col: fromCol2, row: fromRow2, ImageName: movingPiece.ImageName, isWhite: movingPiece.isWhite, isLeft: movingPiece.isLeft))
        
        // replace all ghost pieces remaining with normal half-pieces
        for piece in pieces{
            if (piece.ImageName.prefix(5)=="ghost"){
                let newString = piece.ImageName.replacingOccurrences(of: "ghost", with: "", options: .regularExpression, range: nil)
                pieces.insert(ChessPiece(col: piece.col, row: piece.row, ImageName: newString, isWhite: piece.isWhite, isLeft: piece.isLeft))
            }
        }
    }
    
    
    func canMovePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int, pieceIsWhite: Bool, pieceImageName: String)->Bool{
        
        // Check if start and end position are same
        if (fromCol==toCol && fromRow == toRow){
            return false
        }
        
        // Check that it is your turn
        if !(whitesTurn==pieceIsWhite){
            return false
        }
        
        // Check that piece is not ghost piece
        if (pieceImageName.prefix(5)=="ghost"){
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
    
    func allPiecesAt(col: Int, row: Int) -> Set<ChessPiece>{
        var pieceList: Set<ChessPiece> = Set<ChessPiece>()
        for piece in pieces {
            if col == piece.col && row == piece.row {
                pieceList.insert(piece)
            }
        }
        return pieceList
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
