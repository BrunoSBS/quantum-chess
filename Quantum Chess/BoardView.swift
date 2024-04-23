//
//  BoardView.swift
//  Quantum Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//


import UIKit

class BoardView: UIView {

    let boardProportion: CGFloat = 0.9
    var BoardAnchorX: CGFloat = -1
    var BoardAnchorY: CGFloat = -1
    var squareSize: CGFloat = -1
    let darkSquareColor: UIColor = UIColor.darkGray
    let lightSquareColor: UIColor = UIColor.white
    var pieces = Set<ChessPiece>()
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        BoardAnchorX = bounds.width  * (1 - boardProportion)/2
        BoardAnchorY = bounds.height  * (1 - boardProportion)/2
        squareSize=bounds.width * boardProportion / 8
        drawBoard()
        
        drawPieces()

    }
    
    func drawBoard(){
        for i in 0..<4{
            for j in 0..<4{
                drawSquare(col: 2*i, row: 2*j, color: lightSquareColor)
                drawSquare(col: 2*i + 1, row: 2*j, color: darkSquareColor)
                drawSquare(col: 2*i + 1, row: 2*j + 1, color: lightSquareColor)
                drawSquare(col: 2*i, row: 2*j+1, color: darkSquareColor)
            }
        }
    }
    
    func drawPieces(){
        
        for piece in pieces {
            let pieceImage = UIImage(named: piece.ImageName)
            pieceImage?.draw(in: CGRect(x: BoardAnchorX + CGFloat(piece.col) * squareSize, y: BoardAnchorY + CGFloat(piece.row) * squareSize, width: squareSize, height:squareSize))
        }
        
        
    }
    
    func drawSquare(col: Int, row: Int, color: UIColor){
        let path=UIBezierPath(rect: CGRect(x: BoardAnchorX + CGFloat(col) * squareSize, y: BoardAnchorY + CGFloat(row) * squareSize , width: squareSize, height: squareSize))
        color.setFill()
        path.fill()
    }
    
    

}
