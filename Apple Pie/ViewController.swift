import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var treeImageView: UIImageView!
    
    var words = ["patriot", "assignment", "redirect", "solution", "navigate", "source"]
    let incorrectAllowed = 7
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }

    private var currentGame: Game!
    
    func newRound() {
        if !words.isEmpty {
            let newWord = words.removeFirst()
            currentGame = Game(word: newWord, incorrectRemaining: incorrectAllowed, guessedLetters: [])
            enableLetterButtons(true)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
    }
    
    private func updateGameState() {
        if currentGame.incorrectRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    private func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Times Won: \(totalWins), Times Lost: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectRemaining)")
    }
}
