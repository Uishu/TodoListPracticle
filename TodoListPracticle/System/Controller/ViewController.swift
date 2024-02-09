//
//  ViewController.swift
//  TodoListPracticle
//
//  Created by Disha on 09/02/24.
//

import UIKit
import CoreData

struct TaskDatas {
    var taskName: String?
    var taskDiscription: String?
}

class ViewController: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnAddNote: RoundedButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - VARIABLES
    var arrToDoList = CoreHelper.Shared.GetAllUnCompletedList()
    var arrCompletedList = CoreHelper.Shared.GetAllCompletedList()
    var searchdata: [TaskData]!
    var isinsearch: String = "no"
    var segmentSelectedIndex = 0
    
    //MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.arrToDoList.count)
        self.initialDetails()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.btnAddNote.cornerRadius = self.btnAddNote.frame.size.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setData()
    }
    
    //MARK: - FUNCTIONS
    func initialDetails() {
        print(self.arrToDoList.count)
        self.setView()
        self.searchBar.delegate = self
        self.taskTableView.register(UINib(nibName: "TasksCell", bundle: nil), forCellReuseIdentifier: "TasksCell")
        self.segmentSelectedIndex == 0 ? (self.searchdata = self.arrToDoList) : (self.searchdata = self.arrCompletedList)
        self.taskTableView.estimatedRowHeight = 200
    }
    // this function is use for getthe data from Coredatabase and store it in array.
    func setData() {
        print(self.arrToDoList)
        self.arrToDoList = CoreHelper.Shared.GetAllUnCompletedList()
        self.arrCompletedList = CoreHelper.Shared.GetAllCompletedList()
    }
    
    // this function is use for hide and show the view when data is nill then show empty View and otherwise show the tableView.
    func setView() {
        if self.segmentSelectedIndex == 0 {
            self.taskTableView.isHidden = self.arrToDoList.count == 0 ? true : false
            self.bgView.isHidden = self.arrToDoList.count == 0 ? false : true
        } else {
            self.taskTableView.isHidden = self.arrCompletedList.count == 0 ? true : false
            self.bgView.isHidden = self.arrCompletedList.count == 0 ? false : true
        }
    }
    
    //MARK: - ACTIONS
    @IBAction func onSegmentController(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        self.segmentSelectedIndex = sender.selectedSegmentIndex
        self.setView()
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    @IBAction func onPlus(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - DELEGATE METHODS
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentSelectedIndex == 0 {
            return self.arrToDoList.filter({$0.isCompleted == false}).count
        }else {
            return self.arrCompletedList.filter({$0.isCompleted == true}).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath) as! TasksCell
        if self.segmentSelectedIndex == 0 {
            cell.taskNameLabel.text = self.arrToDoList[indexPath.row].taskName
            cell.taskdiscription.text = self.arrToDoList[indexPath.row].taskDiscription
        }else{
            cell.taskNameLabel.text = self.arrCompletedList[indexPath.row].taskName
            cell.taskdiscription.text = self.arrCompletedList[indexPath.row].taskDiscription
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
            
            CoreHelper.Shared.DeleteQuery(id: self.segmentSelectedIndex == 0 ? Int(self.arrToDoList[indexPath.row].id) : Int(self.arrCompletedList[indexPath.row].id))
            if self.segmentSelectedIndex == 0 {
                self.arrToDoList.remove(at: indexPath.row)
            } else {
                self.arrCompletedList.remove(at: indexPath.row)
            }
            self.taskTableView.deleteRows(at: [indexPath], with: .fade)
            self.setData()
            self.setView()
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            complete(true)
        }
        
        let completedAction = UIContextualAction(style: .normal, title: nil) { _, _, complete in
            CoreHelper.Shared.EditQuery(iscompleted: true, id: Int(self.arrToDoList[indexPath.row].id))
            self.taskTableView.deleteRows(at: [indexPath], with: .fade)
            self.setData()
            self.setView()
            DispatchQueue.main.async {
                self.taskTableView.reloadData()
            }
            complete(true)
        }
        
        // here set your image and background color
        completedAction.image = UIImage(named: "ic_complete")
        completedAction.backgroundColor = .white
        
        deleteAction.image = UIImage(named: "ic_delete")
        deleteAction.backgroundColor = .white
        
        
        let configuration = self.segmentSelectedIndex == 0 ? UISwipeActionsConfiguration(actions: [deleteAction,completedAction]) : UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

}
//MARK: - Delegate Methods of searchbar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if self.segmentSelectedIndex == 0 {
            self.arrToDoList = searchText.isEmpty ? self.arrToDoList : self.arrToDoList.filter {
                (item: TaskData) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.taskName?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
            }
            self.taskTableView.reloadData()
        }else{
            self.arrCompletedList = searchText.isEmpty ? self.arrCompletedList : self.arrCompletedList.filter {
                (item: TaskData) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.taskName?.range(of: searchText, options: .caseInsensitive, range: nil,locale: nil) != nil
            }
            self.taskTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        self.searchBar.text = ""
        self.segmentSelectedIndex == 0 ? (searchdata = self.arrToDoList) : (searchdata = self.arrCompletedList)
        searchBar.endEditing(true)
        self.taskTableView.reloadData()
    }
}

extension ViewController: AddTaskViewControllerDelegate {
    //this function is delegate function when we add the list then this function will be called passing the data of addtskViewController to Viewcontroller
    func added() {
        self.setData()
        self.setView()
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
}

//MARK: - API CALLING

