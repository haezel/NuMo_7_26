//
//  InputsTextViewController.swift
//  testXLform
//
//  Created by Kathryn Manning on 8/3/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import XLForm

class InputsTextViewController : XLFormViewController {
    
    
    private enum Tags : String {
        case Name = "name"
        case Email = "email"
        case Twitter = "twitter"
        case Number = "number"
        case Integer = "integer"
        case Decimal = "decimal"
        case Password = "password"
        case Phone = "phone"
        case Url = "url"
        case TextView = "textView"
        case Notes = "notes"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Text Fields")
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSectionWithTitle("TextField Types")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.required = false
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.Email.rawValue, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        self.form = form
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
    }
    
    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        let alertView = UIAlertView(title: "Valid Form", message: "No errors found", delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
}
