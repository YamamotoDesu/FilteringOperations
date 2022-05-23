//
//  TaskListViewController.swift
//  GoodList
//
//  Created by 山本響 on 2022/05/22.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var prioritySegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

//    private var tasks = Variable<[Task]>([])
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCelll", for: indexPath)
        cell.textLabel?.text = self.filteredTasks[indexPath.row].title
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
        let addTVC = navC.viewControllers.first as? AddTaskViewController else {
            fatalError("Controller not found")
        }
        
        addTVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                //self.tasks.value.append(task)
                
                let priority = Priority(rawValue:
                                            self.prioritySegment.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                
                self.filterTasks(by: priority)
                
                self.tasks.accept(existingTasks)
                
            }).disposed(by: disposeBag)
    }
    
    @IBAction func priorityValueChanged(segmentedControll: UISegmentedControl) {
        
        let priority = Priority(rawValue: segmentedControll.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            updateTableView()
        } else {
            
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
}
