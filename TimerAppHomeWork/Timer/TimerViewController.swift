//
//  TimerViewController.swift
//  TimerAppHomeWork
//
//  Created by Vlad Lapchynskyi on 11.01.2023.
//

import UIKit

private enum Constant {
    static let restColor = UIColor(named: "RestColor")
    static let workoutColor = UIColor(named: "WorkoutColor")
    static let finishColor = UIColor(named: "FinishColor")
}

class TimerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var timeCircleContainer: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Properties
    
    private var exercises: [Exercise] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        toolBar.setItems([closeBarButtonItem], animated: true)
        toolBar.tintColor = .black

        timeCircleContainer.layer.borderWidth = 4
        timeCircleContainer.layer.cornerRadius = timeCircleContainer.frame.width / 2
        
        startTimer(at: currentExerciseIndex, isRest: false)
    }
    
    // MARK: - Internal Methods
    
    func setExercises(_ exercises: [Exercise]) {
        self.exercises = exercises
    }
    
    // MARK: - Private Methods
    
    private var currentExerciseIndex = 0
    private var invalidationDate: Date?
    private var isResting = false
    
    private func startTimer(at index: Int, isRest: Bool) {
        guard index < exercises.count else {
            finishWorkout()
            return
        }
        
        let exercise = exercises[index]
        let currentDate = (invalidationDate ?? Date()).addingTimeInterval(1)
        
        let timeInterval = TimeInterval(isRest ? exercise.timeToRest : exercise.timeWorkOut)
        let invalidationDate = currentDate.addingTimeInterval(timeInterval)
        timeLabel.text = getTimeString(from: currentDate, to: invalidationDate)
        
        let color = isRest ? Constant.restColor : Constant.workoutColor
        timeCircleContainer.layer.borderColor = color?.cgColor
        backgroundContainer.backgroundColor = color?.withAlphaComponent(0.1)
        statusLabel.textColor = color
        statusLabel.text = isRest ? "Rest time" : exercise.name
        
        self.invalidationDate = invalidationDate
        self.isResting = isRest
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self, let invalidationDate = self.invalidationDate else {
                return
            }
            
            let currentDate = Date()
            self.timeLabel.text = self.getTimeString(from: currentDate, to: invalidationDate)
                
            if currentDate >= invalidationDate {
                timer.invalidate()
                
                self.currentExerciseIndex += self.isResting ? 1 : 0
                self.startTimer(at: self.currentExerciseIndex, isRest: !self.isResting)
            }
        }
    }
    
    private func finishWorkout() {
        let color = Constant.finishColor
        timeCircleContainer.layer.borderColor = color?.cgColor
        backgroundContainer.backgroundColor = color?.withAlphaComponent(0.1)
        
        timeLabel.text = "You did it!😎"
        statusLabel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.didTapCloseButton()
        }
    }
    
    private func getTimeString(from date1: Date, to date2: Date) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date1, to: date2)
        
        var timeString = ""
        if let hour = components.hour, hour != 0 {
            timeString = String(format: "%02d", hour) + ":"
        }
        if let minute = components.minute {
            timeString += String(format: "%02d", minute) + ":"
        }
        if let second = components.second {
            timeString += String(format: "%02d", second)
        }
        return timeString
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}
