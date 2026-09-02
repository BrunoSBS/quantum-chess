//
//  ViewController.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import UIKit

class ViewController: UIViewController, ChessDelegate {

    

    var chessEngine: ChessEngine = ChessEngine()
    
    var turnNum: Float = 0.0
    
    @IBOutlet weak var boardView: BoardView!
    
    @IBOutlet weak var whoseMoveLabel: UILabel!
    
    @IBOutlet weak var turnNumLabel: UILabel!
    
    
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
        
        if chessEngine.whitesTurn{
            whoseMoveLabel.text = "White to move"
        }
        else{
            whoseMoveLabel.text = "Black to move"
        }
        
        turnNum = Float(chessEngine.turnNumber + 1)
        if !chessEngine.firstHalfTurn{
            turnNum = turnNum + 0.5
        }
        turnNumLabel.text = "Turn number: " + String(turnNum)
    }
    
    func pieceAt(col: Int, row: Int,isLeft: Bool) -> ChessPiece? {
        chessEngine.pieceAt(col: col, row: row, isLeft: isLeft)
    }

    
    @IBAction func reset(_ sender: Any) {
        chessEngine.initializeGame()
        boardView.pieces = chessEngine.pieces
        whoseMoveLabel.text = "White to move"
        turnNumLabel.text = "Turn number: 1.0"
        boardView.setNeedsDisplay()
    }
    
}

