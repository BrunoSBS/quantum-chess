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

            resolveFullMove(toCol1: toCol1, toCol2: toCol, toRow1: toRow1, toRow2: toRow, piece1isWhite: piece1IsWhite, piece2isWhite: movingPiece.isWhite, targetPieces1: targetPieces1, targetPieces2: targetPieces2)
            
            pieces.insert(ChessPiece(col: toCol, row: toRow, ImageName: movingPiece.ImageName,isWhite: movingPiece.isWhite, isLeft: isLeftBegin))
            
            // replace ghost piece in target square with normal half-piece
            for piece in allPiecesAt(col: toCol1, row: toRow1){
                if (piece.ImageName.prefix(5)=="ghost"){
                    let newString = piece.ImageName.replacingOccurrences(of: "ghost", with: "", options: .regularExpression, range: nil)
                    print(newString)
                    pieces.insert(ChessPiece(col: toCol1, row: toRow1, ImageName: newString, isWhite: ghostPiece.isWhite, isLeft: ghostPiece.isLeft))
                }
            }
            
            // remove all ghost pieces remaining
            for piece in pieces{
                if (piece.ImageName.prefix(5)=="ghost"){
                    pieces.remove(piece)
                }
            }
        }

        // TODO: need to insert piece in left or right depending if space is already occupied
        
        // TODO: Make insert move-reversing function, and delete resulting unnecessary code
        
        // If we've made it here, hopefully we made a move
        

        
        firstHalfTurn = !firstHalfTurn
        if firstHalfTurn {
            whitesTurn = !whitesTurn
        }
                
    }
    
    
    mutating func resolveFullMove(toCol1: Int, toCol2: Int, toRow1: Int, toRow2: Int, piece1isWhite: Bool, piece2isWhite: Bool, targetPieces1: Set<ChessPiece>, targetPieces2: Set<ChessPiece>){
        //pieces.remove....
        // Check occupants of target square
//        if let targetPieceLeft = pieceAt(col: toCol, row: toRow, isLeft: true){
//            print(targetPieceLeft.ImageName)
//            if let targetPieceRight = pieceAt(col: toCol, row: toRow, isLeft: false){
//                print(targetPieceRight.ImageName)
//                print(" have found two pieces in square")
//                // Check if the target square is fully occupied by allied half-pieces - if so, we cancel move
//                if (targetPieceLeft.isWhite == movingPiece.isWhite && targetPieceRight.isWhite == movingPiece.isWhite){
//                    return
//                }
//
//                // if target square is half-occupied, occupy other half
//                if (false){
//                    //
//                }
//
//
//                // if target square is occupied by two opposing pieces, record final and initialsquare as it will be important
//                if (targetPieceLeft.isWhite == targetPieceRight.isWhite){
//                    if firstHalfTurn{
//                        conflictRow = toRow
//                        conflictCol = toCol
//                        conflictImageName = movingPiece.ImageName
//                        conflictIsWhite = movingPiece.isWhite
//                        conflictStartRow = fromRow
//                        conflictStartCol = fromCol
//                        conflictIsLeft = isLeftBegin
//                        print("waiting to be resolved")
//                    }
//                    if (!firstHalfTurn) {
//
//
//                        // If both `conflict' pieces have moved to same square, make normal capture
//                        if (conflictCol == toCol  && conflictRow == toRow){
//                            pieces.remove(targetPieceLeft)
//                            pieces.remove(targetPieceRight)
//                            //TODO: Fix this (currently not working)
//                        }
//
//                        // TODO: What about if two half-pieces move to capture one? May be fixed if we update left and right immediately
//
//
//                        // otherwise, cancel move: move first piece back to starting position, and break here so second piece does not get moved.
//                        else{
//                            for piece in allPiecesAt(col: conflictCol, row: conflictRow){
//                                if (piece != targetPieceLeft && piece != targetPieceRight){
//                                    pieces.remove(piece)
//                                    pieces.insert(ChessPiece(col: conflictStartCol, row: conflictStartRow, ImageName: conflictImageName, isWhite: conflictIsWhite, isLeft: conflictIsLeft))
//                                }
//                            }
//                            firstHalfTurn = true
//                            return
//                        }
//                    }
//
//                }
//
//                // if target square is occupied by two opposite pieces, replace the one of opposite colour
//                if (targetPieceLeft.isWhite != targetPieceRight.isWhite){
//                    print("left not right")
//                    if (targetPieceLeft.isWhite != movingPiece.isWhite){
//                        pieces.remove(targetPieceLeft)
//                        print("left deleted")
//                    }
//                    if (targetPieceRight.isWhite != movingPiece.isWhite){
//                        pieces.remove(targetPieceRight)
//                        print("right deleted")
//                    }
//                }
//
//            }
//
//            //pieces.remove(targetPiece)
//        }
//        print("completed check of target square")
        
        for piece in targetPieces1{
            print(piece.ImageName)
        }
        
        for piece in targetPieces2{
            print(piece.ImageName)
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
