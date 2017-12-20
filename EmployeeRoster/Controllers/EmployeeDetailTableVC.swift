//
//  EmployeeTableVC.swift
//  EmployeeRoster
//
//  Created by ronny abraham on 12/19/17.
//  Copyright © 2017 ronny abraham. All rights reserved.
//

import UIKit

class EmployeeDetailTableVC: UITableViewController, UITextFieldDelegate, EmployeeTypeDelegate {
    func didSelect(employeeType: EmployeeType) {
        self.employeeType = employeeType
        updateType()
    }
    
    
    

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var employeeTypeLabel: UILabel!
    
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    
    
    var employee: Employee?
    var employeeType : EmployeeType?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        updateType()
        
    }
    
    func updateType() {
        if let type = employeeType {
            
            employeeTypeLabel.text = type.description()
        } else {
            employeeTypeLabel.text = "Not Set"
        }
    }
    
    func formatDob() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: birthDatePicker.date)
        }
    
    func updateDob() {
       
        if isEditingBirthday {
            dobLabel.textColor = .black
        } else {
            dobLabel.textColor = .gray
        }
        
        dobLabel.text = formatDob()
    }
    
    let birthDatePickerIndexPath = IndexPath(row: 2, section: 0)
    
    var isEditingBirthday : Bool = false {
        didSet{
            birthDatePicker.isHidden = !isEditingBirthday
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    @IBAction func datePickerValueChanged()
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        dobLabel.text = dateFormatter.string(from: birthDatePicker.date)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == birthDatePickerIndexPath.row {
        if isEditingBirthday {
            return 216.0
        }else{
            return 0.0
            }
        }
        return 44.0
}
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == birthDatePickerIndexPath.row - 1 {
            isEditingBirthday = !isEditingBirthday
            updateDob()
            updateType()
            }
        }
    
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            dobLabel.text = dateFormatter.string(from: employee.dateOfBirth)
            dobLabel.textColor = .black
            
            employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .black
            
            employeeType = employee.employeeType
        } else {
            navigationItem.title = "New Employee"
        }
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let name = nameTextField.text {
            employee = Employee(name: name, dateOfBirth: birthDatePicker.date, employeeType: employeeType!)
            
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        employee = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectEmployeeType" {
            
        
       
        let destinationViewController = segue.destination as? EmployeeTypeTableViewController
        
        destinationViewController?.delegate = self as? EmployeeTypeDelegate
        destinationViewController?.employeeType = employeeType
    }
    }
}
