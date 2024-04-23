//
//  ViewController.swift
//  Quantum Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import UIKit

class ViewController: UIViewController {

    var chessEngine: ChessEngine = ChessEngine()
    
    
    @IBOutlet weak var boardView: BoardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chessEngine.initializeGame()
        boardView.pieces = chessEngine.pieces
        //boardView.setNeedsDisplay()
    }

    

}



