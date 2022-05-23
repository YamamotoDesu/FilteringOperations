# FilteringOperations
<img width="300" src="https://user-images.githubusercontent.com/47273077/169836458-ef5ff0e9-50d1-4dea-bb71-9c6351cd437e.gif">

AddTaskViewController
```swift
class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegementControll: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func save() {
        
        guard let priority = Priority(rawValue:
                                        self.prioritySegementControll.selectedSegmentIndex),
              let title = self.taskTitleTextField.text else {
            return
        }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        print("task",task)
        
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
}
```
