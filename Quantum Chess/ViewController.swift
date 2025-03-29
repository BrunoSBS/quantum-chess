//
//  ViewController.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import UIKit

class ViewController: UIViewController, ChessDelegate {

    

    var chessEngine: ChessEngine = ChessEngine()
    
    @IBOutlet weak var boardView: BoardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chessEngine.initializeGame()
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
        
        boardView.chessDelegate = self
        
    }
    
    // move piece using chessEngine, then update pieces and redraw screen
    func movePiece(fromCol: Int, fromRow: Int, isLeftBegin: Bool, toCol: Int, toRow: Int){
        chessEngine.movePiece(fromCol: fromCol, fromRow: fromRow, isLeftBegin: isLeftBegin, toCol: toCol, toRow: toRow)
        boardView.pieces = chessEngine.pieces
        boardView.setNeedsDisplay()
    }
    
    func pieceAt(col: Int, row: Int,isLeft: Bool) -> ChessPiece? {
        chessEngine.pieceAt(col: col, row: row, isLeft: isLeft)
    }

    

}

