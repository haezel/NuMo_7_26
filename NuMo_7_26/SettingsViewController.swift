//
//  SettingsViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import XLForm

class SettingsViewController: XLFormViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    private enum Tags : String {
        case RealExample = "RealExamples"
        case TextFieldAndTextView = "TextFieldAndTextView"
        case Selectors = "Selectors"
        case Othes = "Others"
        case Dates = "Dates"
        case Predicates = "BasicPredicates"
        case BlogExample = "BlogPredicates"
        case Multivalued = "Multivalued"
        case MultivaluedOnlyReorder = "MultivaluedOnlyReorder"
        case MultivaluedOnlyInsert = "MultivaluedOnlyInsert"
        case MultivaluedOnlyDelete = "MultivaluedOnlyDelete"
        case Validations = "Validations"
        case UICusomization = "Customization"
        case Custom = "Custom"
        case AccessoryView = "Accessory View"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    
    // MARK: Helpers
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row: XLFormRowDescriptor
        
        form = XLFormDescriptor()
        
//        section = XLFormSectionDescriptor.formSectionWithTitle("profile")
//        form.addFormSection(section)
//        
//        // TextFieldAndTextView
//        row = XLFormRowDescriptor(tag: Tags.TextFieldAndTextView.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "About Me")
//        row.action.viewControllerClass = InputsTextViewController.self
//        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Nutrients")
        //section.footerTitle = "ExamplesFormViewController.swift, Select an option to view another example"
        form.addFormSection(section)
        
        
        // TextFieldAndTextView
        row = XLFormRowDescriptor(tag: Tags.TextFieldAndTextView.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Recommended Daily Intakes")
        row.action.viewControllerClass = ChooseRDIsViewController.self
        section.addFormRow(row)
//
//        // TextFieldAndTextView
//        row = XLFormRowDescriptor(tag: Tags.TextFieldAndTextView.rawValue, rowType: XLFormRowDescriptorTypeButton, title: "Set RDIs")
//        row.action.viewControllerClass = ChooseRDIsViewController.self
//        section.addFormRow(row)
        
        
        
        self.form = form
    }
}
