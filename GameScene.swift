//
//  GameScene.swift
//  quickAdd Shared
//
//  Created by Gokce Durusoy on 22.01.2025.
//

import SpriteKit


class GameScene: SKScene {
    //Define the UI elements:
    var startButton: SKLabelNode!
    var stopButton: SKLabelNode!
    var numberLabel: SKLabelNode!
    var isGameRunning = false
    var numberSum = 0
    var currentStreak = 0
    
    var difficultyButton: SKLabelNode!
    var leaderboardButton: SKLabelNode!
    
    struct LeaderboardEntry {
        let date: String
        let streak: Int
        let difficulty: String
    }

    
    func setDifficulty(_ level: String) {
        difficulty = level
        difficultyButton.text = "Difficulty: \(level.capitalized)"
    }
    
    var leaderboard: [LeaderboardEntry] = []
    
    func updateLeaderboard(difficulty: String, streak: Int) {
        let currentDate = getCurrentDate()

        // Check if there’s already an entry for this difficulty
        if let index = leaderboard.firstIndex(where: { $0.difficulty == difficulty }) {
            if streak > leaderboard[index].streak {
                leaderboard[index] = LeaderboardEntry(date: currentDate, streak: currentStreak, difficulty: difficulty)
            }
        } else {
            // Add a new entry if none exists for this difficulty
            leaderboard.append(LeaderboardEntry(date: currentDate, streak: streak, difficulty: difficulty))
        }
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func createLeaderboardHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        headerView.backgroundColor = UIColor.systemGray6

        let dateLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 80, height: 40))
        dateLabel.text = "Date"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 14)
        dateLabel.textAlignment = .left

        let streakLabel = UILabel(frame: CGRect(x: 90, y: 0, width: 80, height: 40))
        streakLabel.text = "Streak"
        streakLabel.font = UIFont.boldSystemFont(ofSize: 14)
        streakLabel.textAlignment = .center

        let difficultyLabel = UILabel(frame: CGRect(x: 180, y: 0, width: 80, height: 40))
        difficultyLabel.text = "Difficulty"
        difficultyLabel.font = UIFont.boldSystemFont(ofSize: 14)
        difficultyLabel.textAlignment = .right

        headerView.addSubview(dateLabel)
        headerView.addSubview(streakLabel)
        headerView.addSubview(difficultyLabel)

        return headerView
    }
    
    func showLeaderboard() {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Create a container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 240))

        // Add the header view
        let headerView = createLeaderboardHeaderView()
        containerView.addSubview(headerView)

        // Create the table view
        let tableView = UITableView(frame: CGRect(x: 0, y: 40, width: 270, height: 200))
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LeaderboardCell")
        containerView.addSubview(tableView)

        // Add the container to the alert
        alertController.view.addSubview(containerView)
        alertController.view.heightAnchor.constraint(equalToConstant: 320).isActive = true

        // Add a Close button
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(closeAction)

        // Present the alert
        if let viewController = self.view?.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: {
                tableView.reloadData()
            })
        }
    }


    //Add the buttons and number display
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        // Start Button
        startButton = SKLabelNode(text: "Start")
        startButton.fontSize = 50
        startButton.fontColor = .systemGreen
        startButton.position = CGPoint(x: -100, y: -350)
        startButton.fontName = "Copperplate-Bold"
        addChild(startButton)
        
        // Stop Button
        stopButton = SKLabelNode(text: "Stop")
        stopButton.fontSize = 50
        stopButton.fontColor = .red
        stopButton.fontName = "Copperplate-Bold"
        stopButton.position = CGPoint(x: 100, y: -350)
        addChild(stopButton)
        
        // Number Label
        numberLabel = SKLabelNode(fontNamed: "Arial")
        numberLabel.fontSize = 60
        numberLabel.fontColor = .black
        numberLabel.position = CGPoint(x: 0, y: 0)
        numberLabel.isHidden = true
        addChild(numberLabel)
        
        // Initialize the difficulty button
        difficultyButton = SKLabelNode(text: "Difficulty: Hard")
        difficultyButton.name = "difficultyButton"
        difficultyButton.fontSize = 30
        difficultyButton.fontColor = .black
        difficultyButton.fontName = "Copperplate-Bold"
        difficultyButton.position = CGPoint(x: 0, y: 250)
        addChild(difficultyButton)
        
        leaderboardButton = SKLabelNode(text: "Leaderboard")
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.fontSize = 40
        leaderboardButton.fontColor = .blue
        leaderboardButton.position = CGPoint(x: 0, y: 150)
        addChild(leaderboardButton)
    }
    
    var difficulty: String = "hard"
    var displayDuration: TimeInterval {
        switch difficulty {
        case "easy":
            return 5.0
        case "medium":
            return 3.0
        default: // "hard"
            return 2.0
        }
    }

    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    //Start button functionality
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let tappedNode = atPoint(location)
            
            if tappedNode.name == "leaderboardButton" {
                showLeaderboard()
            }
            else if tappedNode.name == "difficultyButton" {
                NotificationCenter.default.post(name: NSNotification.Name("ShowDifficultyPopup"), object: nil)
            }
            else if startButton.contains(location) && !isGameRunning {
                    startGame()
        }
            else if stopButton.contains(location) && isGameRunning {
                    stopGame()
        }
    }

    
    func startGame() {
        isGameRunning = true
        currentStreak = 0
        numberSum = 0
        numberLabel.isHidden = false
        generateNumber()
    }
    
    func generateNumber() {
        guard isGameRunning else { return }
        
        // Generate a random number between 11 and 99
        let randomNumber = Int.random(in: 11...99)
        currentStreak += 1
        numberSum += randomNumber
        numberLabel.text = "\(randomNumber)"
        
        // Show a new number after 2 seconds
        run(SKAction.sequence([
            SKAction.wait(forDuration: displayDuration),
            SKAction.run { [weak self] in
                self?.generateNumber()
            }
        ]))
    }
    
    func stopGame() {
        isGameRunning = false
        numberLabel.isHidden = true
        showSumPopup()
    }
    
    func showSumPopup() {
        let alert = UIAlertController(title: "Enter Sum", message: "What is the sum of the numbers?", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.placeholder = "Enter your answer"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] action in
            guard let input = alert.textFields?.first?.text, let userSum = Int(input) else { return }
            self?.checkSum(userSum)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func checkSum(_ userSum: Int) {
        if userSum == numberSum {
            updateLeaderboard(difficulty: difficulty, streak: currentStreak)
            showCelebration()
        } else {
            showTryAgain()
        }
    }
    
    func showCelebration() {
        startButton.isHidden = true
        stopButton.isHidden = true
        difficultyButton.isHidden = true
        leaderboardButton.isHidden = true

        let celebrationLabel = SKLabelNode(text: "Correct!")
        celebrationLabel.fontSize = 60
        celebrationLabel.fontColor = .green
        celebrationLabel.position = CGPoint(x: 0, y: 0)
        addChild(celebrationLabel)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        celebrationLabel.run(SKAction.repeat(sequence, count: 3)) {
            celebrationLabel.removeFromParent()
            self.resetGame()
        }
    }
    
    func showTryAgain() {
        startButton.isHidden = true
        stopButton.isHidden = true
        difficultyButton.isHidden = true
        leaderboardButton.isHidden = true

        let tryAgainLabel = SKLabelNode(text: "Please try again")
        tryAgainLabel.fontSize = 60
        tryAgainLabel.fontColor = .red
        tryAgainLabel.position = CGPoint(x: 0, y: 0)
        addChild(tryAgainLabel)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run {
                tryAgainLabel.removeFromParent()
                self.resetGame()
            }
        ]))
    }
    
    func resetGame() {
        isGameRunning = false
        numberSum = 0
        numberLabel.isHidden = true
        numberLabel.text = ""
        startButton.isHidden = false
        stopButton.isHidden = false
        difficultyButton.isHidden = false
        leaderboardButton.isHidden = false
    }









}

extension GameScene: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath)
        let entry = leaderboard[indexPath.row]

        // Create a formatted string for the cell
        let dateString = String(format: "%-10@", entry.date)
        let streakString = String(format: "%-10d", entry.streak)
        let difficultyString = String(format: "%-10@", entry.difficulty.capitalized)

        cell.textLabel?.text = "\(dateString) \(streakString) \(difficultyString)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
}


