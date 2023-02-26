//
//  ExercisesViewController.swift
//  TimerAppHomeWork
//
//  Created by Vlad Lapchynskyi on 11.01.2023.
//

import UIKit

private enum Constant {
    static let startTimerSegueID = "startTimerSegue"
    static let exerciseTVCIdentifier = "ExerciseTableViewCell"
}

struct Exercise {
    var name: String
    var timeWorkOut: Int
    var timeToRest: Int
}

class ExercisesViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var createNewSetButton: UIButton!
    @IBOutlet weak var exerciseListTableView: UITableView!
    
    // MARK: - Properties
    
    var exercises = [Exercise]() {
        didSet {
            startButton.isHidden = exercises.isEmpty
            createNewSetButton.setTitle(exercises.isEmpty ? "New set" : "Add more", for: .normal)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseListTableView.delegate = self
        exerciseListTableView.dataSource = self
        exerciseListTableView.register(
            UINib(nibName: Constant.exerciseTVCIdentifier, bundle: nil),
            forCellReuseIdentifier: Constant.exerciseTVCIdentifier
        )
        
        startButton.isHidden = true
        startButton.setTitle("Start", for: .normal)
        
        createNewSetButton.setTitle("New set", for: .normal)
        createNewSetButton.addTarget(self, action: #selector(didTappedCreateNewSetButton), for: .touchUpInside)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constant.startTimerSegueID,
              let timerController = segue.destination as? TimerViewController
        else {
            return
        }
        
        timerController.setExercises(exercises)
    }
    
    // MARK: - Actions
    
    @objc private func didTappedCreateNewSetButton() {
        let alertController = UIAlertController(title: createNewSetButton.title(for: .normal), message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Exercise name"
            textField.tag = 1
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Exercise time (sec.)"
            textField.keyboardType = .numberPad
            textField.tag = 2
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Time to rest (sec.)"
            textField.keyboardType = .numberPad
            textField.tag = 3
        }
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] action -> Void in
            var exerciseName: String?
            var timeExercise: Int?
            var timeToRest: Int?
            
            alertController.textFields?.forEach({ textField in
                switch textField.tag {
                case 1: exerciseName = textField.text
                case 2: timeExercise = Int(textField.text ?? "")
                case 3: timeToRest = Int(textField.text ?? "")
                default: break
                }
            })
            
            if let name = exerciseName, let exerciseTime = timeExercise, let restTime = timeToRest {
                let exercise = Exercise(name: name, timeWorkOut: exerciseTime, timeToRest: restTime)
                self?.exercises.append(exercise)
                self?.exerciseListTableView.reloadData()
            }
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ExercisesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as? ExerciseTableViewCell
        else {
            return UITableViewCell()
        }
        cell.nameLabel.text = exercises[indexPath.row].name
        cell.timeLabel.text = String(exercises[indexPath.row].timeWorkOut)
        cell.restLabel.text = String(exercises[indexPath.row].timeToRest)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate

extension ExercisesViewController: UITableViewDelegate {
    
}

