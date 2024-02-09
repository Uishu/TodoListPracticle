//
//  AddTaskViewController.swift
//  TodoListPracticle
//
//  Created by Disha on 09/02/24.
//

import UIKit
import IQKeyboardManagerSwift
import Toaster

protocol AddTaskViewControllerDelegate {
    func added()
}

class AddTaskViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var viewTxtName: UIView!
    @IBOutlet weak var taskDescription: CustomTextView!
    @IBOutlet weak var viewDiscription: UIView!
    @IBOutlet weak var btnAddTarget: UIButton!
    @IBOutlet weak var loader: UIView!
    
    //MARK: - VARIABLES
    var delegate: AddTaskViewControllerDelegate?
    
    //MARK: - METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewTxtName.layer.cornerRadius = 8
        self.viewTxtName.layer.borderColor = UIColor.systemOrange.cgColor
        self.viewTxtName.layer.borderWidth = 2
        
        self.viewDiscription.layer.cornerRadius = 8
        self.viewDiscription.layer.borderColor = UIColor.systemOrange.cgColor
        self.viewDiscription.layer.borderWidth = 2
        
        self.btnAddTarget.layer.cornerRadius = self.btnAddTarget.frame.size.height/2
    }
    //MARK: - FUNCTIONS
    
    //MARK: - ACTIONS
    @IBAction func onClickAdd(_ sender: UIButton) {
        guard let name = self.taskNameTextField.text, !name.isEmpty else {
            return Toast(text: "Please Enter Task Name").show()
        }
        guard let discription = self.taskDescription.text, !discription.isEmpty else{
            return Toast(text: "Please Enter Discription").show()
        }
        self.loader.isHidden = false
        let totalCount = CoreHelper.Shared.GetAllData()
        print(totalCount.count)
        let newId = totalCount.count + 1
        CoreHelper.Shared.SetDataQuery(id: newId, taskName: taskNameTextField.text, taskDiscription: taskDescription.text, iscompleted: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loader.isHidden = true
            self.navigationController?.popViewController(animated: true)
            self.delegate?.added()
        }
    }
    
    @IBAction func clickBakcBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - DELEGATE METHODS

//MARK: - API CALLING
