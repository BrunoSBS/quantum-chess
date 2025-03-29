//
//  ChessDelegate.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 22/04/2024.
//

import Foundation

protocol ChessDelegate {
    
    //promises function that takes co-ordinates from boardView and moves piece in chessEngine, updates boardView pieces and paints
    func movePiece(fromCol: Int, fromRow: Int, isLeftBegin: Bool, toCol: Int, toRow: Int)
    
    // promises function that finds piece (if there is one) at board co-ordinates and gives back to boardView
    func pieceAt(col: Int, row: Int, isLeft: Bool) ->ChessPiece?
}
