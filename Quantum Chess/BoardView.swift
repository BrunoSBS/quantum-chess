//
//  BoardView.swift
//  Chess
//
//  Created by Bruno Barton-Singer on 21/04/2024.
//

import UIKit

class BoardView: UIView {

    // Board variables
    let boardProportion: CGFloat = 0.9
    var BoardAnchorX: CGFloat = -1
    var BoardAnchorY: CGFloat = -1
    var squareSize: CGFloat = -1
    let darkSquareColor: UIColor = UIColor.darkGray
    let lightSquareColor: UIColor = UIColor.white
    
    // Pieces
    var pieces = Set<ChessPiece>()
    
    // chessDelegate protocol that talks to chessEngine through/in (?) ViewController
    var chessDelegate: ChessDelegate?
    
    // piece moving
    var colTouchBegin = -1
    var rowTouchBegin = -1
    var isLeftTouchBegin = true //Bool for upperleft or lower-right quadrant
    
    
    
    // moving piece image that tracks mouse
    var movingPieceImage: UIImage? = nil
    var movingPieceX: CGFloat = -1
    var movingPieceY: CGFloat = -1
    
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        BoardAnchorX = bounds.width  * (1 - boardProportion)/2
        BoardAnchorY = bounds.height  * (1 - boardProportion)/2
        squareSize=bounds.width * boardProportion / 8
        drawBoard()
        
        drawPieces()

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        
        //TODO: fix touches to left and above board counting as on row/col zero due to integer casting
        colTouchBegin = Int( (fingerLocation.x - BoardAnchorX)/squareSize )
        rowTouchBegin = Int( (fingerLocation.y - BoardAnchorY)/squareSize )
        isLeftTouchBegin = Int(2*(fingerLocation.x - BoardAnchorX)/squareSize) % 2 == 0
        //isLeftTouchBegin = (fingerLocation.x - BoardAnchorX).truncatingRemainder(dividingBy: squareSize)<0.5*squareSize

        // start moving image of chess piece where touch begins
        movingPieceX = fingerLocation.x - squareSize/2
        movingPieceY = fingerLocation.y - squareSize/2
        
        if let movingPiece = chessDelegate?.pieceAt(col: colTouchBegin, row: rowTouchBegin,isLeft: isLeftTouchBegin){
            movingPieceImage = UIImage(named: movingPiece.ImageName)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        movingPieceX = fingerLocation.x - squareSize/2
        movingPieceY = fingerLocation.y - squareSize/2
        setNeedsDisplay()

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let first = touches.first!
        let fingerLocation = first.location(in: self)
        //TODO: fix touches to left and above board counting as on row/col zero due to integer casting
        let colTouchEnd: Int = Int( (fingerLocation.x - BoardAnchorX)/squareSize )
        let rowTouchEnd: Int = Int( (fingerLocation.y - BoardAnchorY)/squareSize )
        
        chessDelegate?.movePiece(fromCol: colTouchBegin, fromRow: rowTouchBegin, isLeftBegin: isLeftTouchBegin, toCol: colTouchEnd, toRow: rowTouchEnd)
        
        movingPieceImage = nil
        colTouchBegin = -1
        rowTouchBegin = -1
        isLeftTouchBegin = true
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
        
        // draw all static pieces
        for piece in pieces {
            
            // skip drawing piece if it is currently in motion (handled below)
            if colTouchBegin==piece.col && rowTouchBegin==piece.row && isLeftTouchBegin==piece.isLeft{
                continue
            }
            
            let pieceImage = UIImage(named: piece.ImageName)
            pieceImage?.draw(in: CGRect(x: BoardAnchorX + CGFloat(piece.col) * squareSize, y: BoardAnchorY + CGFloat(piece.row) * squareSize, width: squareSize, height:squareSize))
        }
        
        // draw moving piece
        movingPieceImage?.draw(in: CGRect(x: movingPieceX, y: movingPieceY, width: squareSize, height: squareSize))
    }
    
    func drawSquare(col: Int, row: Int, color: UIColor){
        let path=UIBezierPath(rect: CGRect(x: BoardAnchorX + CGFloat(col) * squareSize, y: BoardAnchorY + CGFloat(row) * squareSize , width: squareSize, height: squareSize))
        color.setFill()
        path.fill()
    }
    
    

}
