//
//  ViewController.swift
//  TicTacToe
//
//  Created by Marquis Dennis on 12/12/15.
//  Copyright © 2015 Marquis Dennis. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    var whichTurn:GamePiece = .Nought
    var whichTurnImage:UIImage?
    var checkedDict = [Int : GamePiece]()
    var winningCombinations = [[100,110,111], [100, 200, 300], [100, 220, 333], [200, 220, 222], [300, 330, 333], [110,220,330], [111,222,333], [111,220,300]]
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var isWinnerFound = false

    @IBOutlet weak var winningLabel: UILabel!
    
    @IBOutlet weak var playAgain: UIButton!
    
    @IBAction func squareButton(sender: AnyObject) {
        //get the correct button
        //determine if the button image is set
        //determine if the game has been won
        //change the gamepiece
        let btn = sender as! UIButton
        
        if btn.backgroundImageForState(UIControlState.Normal) == nil {
            if whichTurn == .Nought {
                btn.setImage(UIImage(named: "nought.png"), forState: UIControlState.Normal)
            } else {
                btn.setImage(UIImage(named: "cross.png"), forState: UIControlState.Normal)
            }
            
            btn.enabled = false
            
            //add checked
            checkedDict[btn.tag] = whichTurn
            
            //only check for a winner if it's possible to have a winner yet
            if checkedDict.keys.count > 3 {
                isWinnerFound = evaluateOutcome()
                
                if isWinnerFound {
                    //whichTurn wins the game
                    winningLabel.text = "\(whichTurn) wins!"
                    
                    winningLabel.hidden = false
                    playAgain.hidden = false
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.winningLabel.center = CGPointMake(self.winningLabel.center.x + 500,
                            self.winningLabel.center.y)
                    })
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.playAgain.center = CGPointMake(self.playAgain.center.x + 500,
                        self.playAgain.center.y)
                    })
                    
                    return
                }
                
                if !isWinnerFound && checkedDict.keys.count == 9 {
                    winningLabel.hidden = false
                    playAgain.hidden = false
                    winningLabel.text = "It's a draw!"
                    return
                }
            }
            
            //get the next game piece
            whichTurn = getNextGamePiece(whichTurn)
        }
    }
    
    @IBAction func gameReset(sender: AnyObject) {
        var buttonToClear = [UIButton]()
        
        //clear button images
        buttonToClear.append(view.viewWithTag(100) as! UIButton)
        buttonToClear.append(view.viewWithTag(110) as! UIButton)
        buttonToClear.append(view.viewWithTag(111) as! UIButton)
        buttonToClear.append(view.viewWithTag(200) as! UIButton)
        buttonToClear.append(view.viewWithTag(220) as! UIButton)
        buttonToClear.append(view.viewWithTag(222) as! UIButton)
        buttonToClear.append(view.viewWithTag(300) as! UIButton)
        buttonToClear.append(view.viewWithTag(330) as! UIButton)
        buttonToClear.append(view.viewWithTag(333) as! UIButton)

        for button in buttonToClear {
            button.setImage(nil, forState: .Normal)
            button.enabled = true
        }
        
        winningLabel.hidden = true
        
        winningLabel.center = CGPointMake(winningLabel.center.x - 500, winningLabel.center.y)
        
        playAgain.hidden = true
        
        playAgain.center = CGPointMake(playAgain.center.x - 500, playAgain.center.y)
        
        isWinnerFound = false
        
        checkedDict = [Int : GamePiece]()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winningLabel.hidden = true
        
        winningLabel.center = CGPointMake(winningLabel.center.x - 500, winningLabel.center.y)
        
        playAgain.hidden = true
        
        playAgain.center = CGPointMake(playAgain.center.x - 500, playAgain.center.y)
        
        //determine who goes first
        whoGoesFirst()
        
        //set appropriate game piece image
        getGamePieceImage(whichTurn)
        
        
    }

    func evaluateOutcome() -> Bool {
        //winning combinations
        for winningCombination in winningCombinations {
            if checkedDict[winningCombination[0]] == nil ||
                checkedDict[winningCombination[1]] == nil ||
                checkedDict[winningCombination[2]] == nil {
                    continue
            }
            
            if checkedDict[winningCombination[0]]! == checkedDict[winningCombination[1]]! &&
                checkedDict[winningCombination[1]]! == checkedDict[winningCombination[2]]! {
                
                return true
            }
        }
        
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func whoGoesFirst() {
        let rand = Int(arc4random_uniform(2))
        
        whichTurn = GamePiece(rawValue: rand)!
    }
    
    func getNextGamePiece(piece: GamePiece) -> GamePiece {
        if piece.rawValue == 0 {
            return .Cross
        } else {
            return .Nought
        }
        
    }
    
    func getGamePieceImage(piece: GamePiece) {
        //nil coalesce game piece
        if piece.rawValue == 0 {
            whichTurnImage = UIImage(named: "nought.png")
        } else {
            whichTurnImage = UIImage(named: "cross.png")
        }
    }

}

enum GamePiece : Int {
    case Nought = 0
    case Cross = 1
}

