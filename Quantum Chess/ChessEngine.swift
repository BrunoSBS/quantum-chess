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
    
    var turnNumber: Int = 1
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
        print("turn number: ",turnNumber)
        //TODO: make moving piece ghost piece, have piece in initial spot become ghost piece immediately?
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
                print(piece.ImageName,piece.isWhite,piece.isLeft)
            }
            
            
        }
        if !firstHalfTurn{
            targetPieces2.removeAll()
            for piece in allPiecesAt(col: toCol, row: toRow){
                targetPieces2.insert(piece)
            }
        }
        
        
        // Remove piece at start, add it at end
        pieces.remove(movingPiece)
        
        // If first half turn, move is done with ghost pieces to make clear move is provisional
        if firstHalfTurn{
            // turn starting place to ghost piece
            pieces.insert(ChessPiece(col: fromCol, row: fromRow, ImageName: "ghost" + movingPiece.ImageName, isWhite: movingPiece.isWhite, isLeft: movingPiece.isLeft))
            
            // insert ghost piece in target square, changing isLeft of piece if there is already half-piece in its orientation
            //TODO: if target square has two pieces of friendly colour (and possibly in other scenarios) we should cancel move early
//            if targetPieces1.contains(where: {$0.isLeft == movingPiece.isLeft}){
//                pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: "ghost" + movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: !isLeftBegin))
//                print("changed first moving piece's isLeft")
//            }
//            else{
//                pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: "ghost" + movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: isLeftBegin))
//            }
            
            // insert ghost piece in target square, not changing isLeft (we will visualise it differently anyway)
            pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: "ghost" + movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: isLeftBegin))
            
            toCol1 = toCol
            toRow1 = toRow
        }
        
        // If second half turn, decide whether whole move is legal
        if !firstHalfTurn{

            if resolveFullMove(toCol1: toCol1, toCol2: toCol, toRow1: toRow1, toRow2: toRow, whitesTurn: whitesTurn, targetPieces1: targetPieces1, targetPieces2: targetPieces2){
                
                // move moving pieces to final destinations and clean up
                completeMove(movingPiece: movingPiece, toCol1: toCol1, toRow1: toRow1, toCol2: toCol, toRow2: toRow)

                // switch whose turn it is
                whitesTurn = !whitesTurn
                turnNumber += 1
            }
            else{
                // move moving pieces back to original places and clean up
                cancelMove(movingPiece: movingPiece, toCol1: toCol1, toRow1: toRow1, fromCol2: fromCol, fromRow2: fromRow)
            }
        }
        
        
        // Switch half-move
        firstHalfTurn = !firstHalfTurn

        // TODO: instead of removing pieces, they should be moved to `dead' area outside board.
          
    }
    
    // Function that checks legality at end of second half-move in a turn, returning false if second half-move is to be cancelled
    mutating func resolveFullMove(toCol1: Int, toCol2: Int, toRow1: Int, toRow2: Int, whitesTurn: Bool, targetPieces1: Set<ChessPiece>, targetPieces2: Set<ChessPiece>)->Bool{

        //if two half-pieces move to same square...
        if (toCol1 == toCol2 && toRow1 == toRow2){
            
            if targetPieces1.isEmpty{
                print("Empty target square")
            }
            //if two half-pieces move to same square and target pieces are all of opposite colour, delete all target pieces and make move.
            else if targetPieces1.allSatisfy({$0.isWhite != whitesTurn}){
                print("Capture")
                for piece in targetPieces1{
                    pieces.remove(piece)
                }
            }
            
            // if two half-pieces move to same square, but at least one target piece is the same colour, cancel move.
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
        // both must resolve true to return true
        else{
            print("Two separate squares")
            // First 1 and then 2, so turn order currently matters
            //TODO: Make order of resolution player choice
            //resolveHalfMove(col: toCol1, row: toRow1, whitesTurn: whitesTurn, targetPieces: targetPieces1)
            //resolveHalfMove(col: toCol2, row: toRow2, whitesTurn: whitesTurn, targetPieces: targetPieces2)
            
            // Currently, always cancel move
            // TODO: correct checks for legality
            return resolveHalfMove(col: toCol1, row: toRow1, whitesTurn: whitesTurn, targetPieces: targetPieces1) && resolveHalfMove(col: toCol2, row: toRow2, whitesTurn: whitesTurn, targetPieces: targetPieces2)
        }
        
        return true
        
        
    }
    
    // Function that checks legality of move of one half-piece on its own to a target square
    // i.e. it checks the first half-move, and if two half-pieces move to different squares, each will be resolved here too
    mutating func resolveHalfMove(col: Int, row: Int, whitesTurn: Bool, targetPieces: Set<ChessPiece>)->Bool{
        // if there is one or zero pieces in the square being moved to, then the half-move is legal
        if (targetPieces.count <= 1){
            return true
        }
        // if there are two half-pieces present, currently we always cancel move
        return false
        //TODO: if two half-pieces of different colour, capture the opposing colour one
        //TODO: if two half-pieces of same, opposing colour, resolve collapse
    }
    //.rotate(radians: .pi).
    
    // Function that
    mutating func completeMove(movingPiece: ChessPiece, toCol1: Int, toRow1: Int,toCol2: Int, toRow2: Int){


        // move second half-piece into square
        pieces.insert(ChessPiece(col: toCol2, row: toRow2, ImageName: movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: movingPiece.isLeft))
        

        // replace ghost piece in target square with normal half-piece
        for piece in allPiecesAt(col: toCol1, row: toRow1){
            if (piece.ImageName.prefix(5)=="ghost"){
                // name of new piece needs us to remove 'ghost'
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
        
        //TODO: Check two half-pieces per square?
        if (allPiecesAt(col: toCol1, row: toRow1).count > 2){
            print("ERROR: more than two half-pieces at square")
        }
        
        if (allPiecesAt(col: toCol2, row: toRow2).count > 2){
            print("ERROR: more than two half-pieces at square")
        }
        
        // make sure all pieces at (toCol1,toRow1) have different isLeft
        if (allPiecesAt(col: toCol1, row: toRow1).count == 2){
            separateIsLeft(piece1: allPiecesAt(col: toCol1, row: toRow1)[0], piece2: allPiecesAt(col: toCol1, row: toRow1)[1])
        }
        
        // make sure all pieces at (toCol2,toRow2) have different isLeft
        if (allPiecesAt(col: toCol2, row: toRow2).count == 2){
            separateIsLeft(piece1: allPiecesAt(col: toCol2, row: toRow2)[0], piece2: allPiecesAt(col: toCol2, row: toRow2)[1])
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
    
    // Function that takes two half pieces at square and if they have same isLeft it is switched
    mutating func separateIsLeft(piece1: ChessPiece, piece2: ChessPiece){
        if (piece1.isLeft == piece2.isLeft){
            pieces.insert(ChessPiece(col: piece2.col, row: piece2.row, ImageName: piece2.ImageName, isWhite:piece2.isWhite,isLeft: !piece2.isLeft))
            pieces.remove(piece2)
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
    
    // Returns array of pieces at given column and row
    func allPiecesAt(col: Int, row: Int) -> Array<ChessPiece>{
        var pieceList: Array<ChessPiece> = Array<ChessPiece>()
        for piece in pieces {
            if col == piece.col && row == piece.row {
                pieceList.append(piece)
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
