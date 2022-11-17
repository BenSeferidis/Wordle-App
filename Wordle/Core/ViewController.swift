//
//  ViewController.swift
//  Wordle
//
//  Created by Ben Seferidis on 17/11/22.
//

import UIKit

//UI
//Keyboard
//Game Board
//Orange/Green
class ViewController: UIViewController {
    
    //MARK: -- Properties
    
    let answers =  ["abuse","adult","agent","anger","apple","award","basis","beach","birth","block","blame",
                    "blood", "board","brain","bread","break","brown","buyer","cause","chain","chair","chest",
                    "chief", "child","china","claim","class","clock","coach","coast","court","cover","cream",
                    "crime", "cross","crowd","crown","cycle","dance","death","depth","doubt","draft","drama",
                    "dream", "dress","drink","drive","earth","enemy","entry","error","event","faith","field",
                    "fight", "floor","focus","force","front","fruit","glass","grass","green","daddy","eagle",
                    "early", "faces","heart","royal","trash","label","labor","oasis","packs","sober","sodas",
                    "vacay", "yacht","plain","plane","wired","wings","width","white","virus","urban","twist",
                    "tulip", "torch","youth","yours","walls","steal","split","rumor","roses","pulse","prove",
                    "power", "pants","pilot","other","olive","older","nurse","needs","mixed","maybe","lover",
                    "loser", "lobby","level","kitty","kilos","karts","jeans","issue","input","igloo","ideal",
                    "humor", "house","honey","group","grape","grade","funky","front","fries","fresh","exist"
     ]
    var answer = ""
    private var guesses: [[Character?]]  = Array(
        repeating: Array(repeating: nil, count: 5),
        count: 6
    )
    
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    
    //MARK: -- Life Cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        answer = answers.randomElement() ?? "after"
        view.backgroundColor = .darkGray
        addChildren()
    }
    
    private func addChildren(){
        addChild(keyboardVC)
        keyboardVC.didMove(toParent: self)
        keyboardVC.deleagate = self
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
        
        addChild(boardVC)
        boardVC.didMove(toParent: self)
        boardVC.datasource = self
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
        
        addConstraints()
    }
        
        func addConstraints(){
            NSLayoutConstraint.activate([
                boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                boardVC.view.topAnchor.constraint(equalTo:
                                                    view.safeAreaLayoutGuide.topAnchor),
                boardVC.view.bottomAnchor.constraint(equalTo:
                                                    keyboardVC.view.topAnchor),
                boardVC.view.heightAnchor.constraint(equalTo:
                                                        view.heightAnchor, multiplier: 0.6),
                
                
                keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                keyboardVC .view.bottomAnchor.constraint(equalTo:
                                                            view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
        
    }


    //MARK: -- Extensions
extension ViewController : KeyboardViewControllerDelegate{
    func keyboardViewController(_ vc: KeyboardViewController,didTapKey letter : Character){
//        print(letter)
        
        // update guesses
        var stop = false
        for i in 0..<guesses.count{
            for j in 0..<guesses[i].count{
                if guesses[i][j] == nil{
                    guesses[i][j] = letter
                    stop = true
                    break
                }
            }
            if stop {
                break
            }
        }
        boardVC.reloadData()
    }
}
extension ViewController : BoardViewControllerDataSource{
    var currentGuesses: [[Character?]]{
        return guesses
    }
    func boxColor(at indexPath: IndexPath) -> UIColor?{
        let rowIndex = indexPath.section
        
        let count = guesses[rowIndex ].compactMap({ $0 }).count
        guard count == 5 else {
            return nil
        }
        
        let indexAnswer = Array(answer)
        
        guard let letter = guesses[indexPath.section][indexPath.row],indexAnswer.contains(letter) else{
            return nil
        }
      
        if indexAnswer[indexPath.row] == letter{
            return .systemGreen
        }
        return .systemOrange
    }
}


