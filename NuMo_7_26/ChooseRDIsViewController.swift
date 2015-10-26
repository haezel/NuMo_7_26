//
//  ChooseRDIsViewController.swift
//  testXLform
//
//  Created by Kathryn Manning on 8/3/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//


import UIKit
import XLForm

class ChooseRDIsViewController : XLFormViewController {
    
    var nRDAs : Dictionary<Int, (Double)>?
    
    
    //use this to refresh to default values
    let defaultRDAs = [
        203 : 35.0,         //Protein
        204 : 65.0,         //Fat
        205 : 300.0,        //Carb
        208 : 2000.0,       //Calories
        262 : 400.0,        //Caffeine
        269 : 30.0,         //Sugars, total
        291 : 25.0,         //Fiber, total
        301 : 1000.0,       //Calcium
        303 : 18.0,         //Iron
        304 : 400.0,        //Magnesium
        305 : 1000.0,       //Phosph
        306 : 3500.0,       //Potass
        307 : 2400.0,       //Sodium
        309 : 15.0,         //Zinc
        312 : 2.0,          //Copper
        315 : 2.0,          //Manganese
        317 : 70.0,         //Selenium
        318 : 5000.0,       //Vit A
        323 : 15.0,         //Vit E
        417 : 400.0,        //Fol
        418 : 2.4,          //VitB12
        601 : 300.0,        //Cholesterol
        606 : 20.0,         //Sat Fat
        401 : 60.0,         //Vit C
        324 : 400.0         //Vit D
    ]
    
    
    private enum Tags : String {
        case Calories = "calories"
        case Protein = "protein"
        case Carbohydrate = "carbohydrate"
        case Fat = "fat"
        case Caffeine = "caffeine"
        case Sugar = "sugar"
        case Fiber = "fiber"
        case Calcium = "calcium"
        case Iron = "iron"
        case Magnesium = "magnesium"
        case Phosphorus = "phosphorus"
        case Potassium = "potassium"
        case Sodium = "sodium"
        case Zinc = "zinc"
        case Copper = "copper"
        case Selenium = "selenium"
        case VitaminA = "vitamina"
        case VitaminC = "vitaminc"
        case VitaminD = "vitamind"
        case VitaminE = "vitamine"
        case VitaminB12 = "vitaminb12"
        case Folate = "folate"
        case Manganese = "manganese"
        case Cholesterol = "cholesterol" //
        case SatFat = "satfat" //
    }
    
    let nutrientIdDict = [
        "calories" : 208,
        "protein" : 203,
        "carbohydrate" : 205,
        "fat" : 204,
        "caffeine" : 262,
        "sugar" : 269,
        "fiber" : 291,
        "calcium" : 301,
        "iron" : 303,
        "magnesium" : 304,
        "phosphorus" : 305,
        "potassium" : 306,
        "sodium" : 307,
        "zinc" : 309,
        "copper" : 312,
        "selenium" : 317,
        "vitamina" : 318,
        "vitaminc" : 401,
        "vitamind" : 324,
        "vitamine" : 323,
        "vitaminb12" : 418,
        "folate" : 417,
        "manganese" : 315,
        "cholesterol" : 601, //
        "satfat" : 606 //
    ]
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
        self.nRDAs = ModelManager.instance.getAllNutrientRDAs()
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
        
        form = XLFormDescriptor(title: "RDIs")
        form.assignFirstResponderOnShow = false
        
        
        
        
        
        
        //------------MACROS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Macronutrients")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calories
        row = XLFormRowDescriptor(tag: Tags.Calories.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calories (kcal)")
        row.value = self.nRDAs![208]!
        section.addFormRow(row)
        
        // Fat
        row = XLFormRowDescriptor(tag: Tags.Fat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fat (g)")
        row.value = self.nRDAs![204]!
        section.addFormRow(row)
        
        // Protein
        row = XLFormRowDescriptor(tag: Tags.Protein.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Protein (g)")
        row.value = self.nRDAs![203]!
        section.addFormRow(row)
        
        // Carbohydrate
        row = XLFormRowDescriptor(tag: Tags.Carbohydrate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Carbohydrate (g)")
        row.value = self.nRDAs![205]!
        section.addFormRow(row)
        
        
        
        
        
        
        
        //------------VITAMINS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Vitamins")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // C
        row = XLFormRowDescriptor(tag: Tags.VitaminC.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin C (mg)")
        row.value = self.nRDAs![401]!
        section.addFormRow(row)
        
        // A
        row = XLFormRowDescriptor(tag: Tags.VitaminA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin A (IU)")
        row.value = self.nRDAs![318]!
        section.addFormRow(row)
        
        // D
        row = XLFormRowDescriptor(tag: Tags.VitaminD.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin D (IU)")
        row.value = self.nRDAs![324]!
        section.addFormRow(row)
        
        // E
        row = XLFormRowDescriptor(tag: Tags.VitaminE.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin E (IU)")
        row.value = self.nRDAs![323]!
        section.addFormRow(row)
        
        // B12
        row = XLFormRowDescriptor(tag: Tags.VitaminB12.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin B12 (mcg)")
        row.value = self.nRDAs![418]!
        section.addFormRow(row)
        
        // Folate
        row = XLFormRowDescriptor(tag: Tags.Folate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Folate (mcg)")
        row.value = self.nRDAs![417]!
        section.addFormRow(row)
        
        
        
        
        
        //------------Minerals------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Minerals")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calcium
        row = XLFormRowDescriptor(tag: Tags.Calcium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calcium (mg)")
        row.value = self.nRDAs![301]!
        section.addFormRow(row)
        
        // Phos
        row = XLFormRowDescriptor(tag: Tags.Phosphorus.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Phosphorus (mg)")
        row.value = self.nRDAs![305]!
        section.addFormRow(row)
        
        // Pota
        row = XLFormRowDescriptor(tag: Tags.Potassium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Potassium (mg)")
        row.value = self.nRDAs![306]!
        section.addFormRow(row)
        
        // Sod
        row = XLFormRowDescriptor(tag: Tags.Sodium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sodium (mg)")
        row.value = self.nRDAs![307]!
        section.addFormRow(row)
        
        // Magnesium
        row = XLFormRowDescriptor(tag: Tags.Magnesium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Magnesium (mg)")
        row.value = self.nRDAs![304]!
        section.addFormRow(row)
        
        // Iron
        row = XLFormRowDescriptor(tag: Tags.Iron.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Iron (mg)")
        row.value = self.nRDAs![303]!
        section.addFormRow(row)

        // Zinc
        row = XLFormRowDescriptor(tag: Tags.Zinc.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Zinc (mg)")
        row.value = self.nRDAs![309]!
        section.addFormRow(row)
        
        // Selenium
        row = XLFormRowDescriptor(tag: Tags.Selenium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Selenium (mcg)")
        row.value = self.nRDAs![317]!
        section.addFormRow(row)
        
        // Copper
        row = XLFormRowDescriptor(tag: Tags.Copper.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Copper (mg)")
        row.value = self.nRDAs![312]!
        section.addFormRow(row)
        
        // Manganese
        row = XLFormRowDescriptor(tag: Tags.Manganese.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Manganese (mg)")
        row.value = self.nRDAs![315]!
        section.addFormRow(row)
        
        
        
        //------------Other------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Other")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Fiber
        row = XLFormRowDescriptor(tag: Tags.Fiber.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fiber (g)")
        row.value = self.nRDAs![291]!
        section.addFormRow(row)
        
        // Caffeine
        row = XLFormRowDescriptor(tag: Tags.Caffeine.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Caffeine (g)")
        row.value = self.nRDAs![262]!
        section.addFormRow(row)
        
        // Sugar
        row = XLFormRowDescriptor(tag: Tags.Sugar.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sugar (g)")
        row.value = self.nRDAs![269]!
        section.addFormRow(row)
        
        // Cholesterol
        row = XLFormRowDescriptor(tag: Tags.Cholesterol.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Cholesterol (mg)")
        row.value = self.nRDAs![601]!
        section.addFormRow(row)
        
        // Sat Fat
        row = XLFormRowDescriptor(tag: Tags.SatFat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Saturated Fat (g)")
        row.value = self.nRDAs![606]!
        section.addFormRow(row)
        
        

        
        
        
        

        
        self.form = form
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let button1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
        let button2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshPressed:")
        
        let arrayOfButtons = [button1,button2]

        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
        
        self.navigationItem.rightBarButtonItems = arrayOfButtons
    }
    
    
    
    
    
    
    
    
    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        
        
        
        //--------Get the Values!--------//
        
        var results = [Int:Double]()
        
        if let calories = form.formRowWithTag(Tags.Calories.rawValue)!.value as? Double {
            let string = Tags.Calories.rawValue
            let id = nutrientIdDict[string]!
            results[id] = calories
        }
        
        if let protein = form.formRowWithTag(Tags.Protein.rawValue)!.value as? Double {
            let string = Tags.Protein.rawValue
            let id = nutrientIdDict[string]!
            results[id] = protein
        }
        
        if let carb = form.formRowWithTag(Tags.Carbohydrate.rawValue)!.value as? Double {
            let string = Tags.Carbohydrate.rawValue
            let id = nutrientIdDict[string]!
            results[id] = carb
        }
        
        if let fat = form.formRowWithTag(Tags.Fat.rawValue)!.value as? Double {
            let string = Tags.Fat.rawValue
            let id = nutrientIdDict[string]!
            results[id] = fat
        }
        
        if let caffeine = form.formRowWithTag(Tags.Caffeine.rawValue)!.value as? Double {
            let string = Tags.Caffeine.rawValue
            let id = nutrientIdDict[string]!
            results[id] = caffeine
        }
        
        if let sugar = form.formRowWithTag(Tags.Sugar.rawValue)!.value as? Double {
            let string = Tags.Sugar.rawValue
            let id = nutrientIdDict[string]!
            results[id] = sugar
        }
        
        if let fiber = form.formRowWithTag(Tags.Fiber.rawValue)!.value as? Double {
            let string = Tags.Fiber.rawValue
            let id = nutrientIdDict[string]!
            results[id] = fiber
        }
        
        if let calcium = form.formRowWithTag(Tags.Calcium.rawValue)!.value as? Double {
            let string = Tags.Calcium.rawValue
            let id = nutrientIdDict[string]!
            results[id] = calcium
        }
        
        if let iron = form.formRowWithTag(Tags.Iron.rawValue)!.value as? Double {
            let string = Tags.Iron.rawValue
            let id = nutrientIdDict[string]!
            results[id] = iron
        }
        
        if let mag = form.formRowWithTag(Tags.Magnesium.rawValue)!.value as? Double {
            let string = Tags.Magnesium.rawValue
            let id = nutrientIdDict[string]!
            results[id] = mag
        }
        
        if let phos = form.formRowWithTag(Tags.Phosphorus.rawValue)!.value as? Double {
            let string = Tags.Phosphorus.rawValue
            let id = nutrientIdDict[string]!
            results[id] = phos
        }
        
        if let pot = form.formRowWithTag(Tags.Potassium.rawValue)!.value as? Double {
            let string = Tags.Potassium.rawValue
            let id = nutrientIdDict[string]!
            results[id] = pot
        }
        
        if let sod = form.formRowWithTag(Tags.Sodium.rawValue)!.value as? Double {
            let string = Tags.Sodium.rawValue
            let id = nutrientIdDict[string]!
            results[id] = sod
        }
        
        if let zinc = form.formRowWithTag(Tags.Zinc.rawValue)!.value as? Double {
            let string = Tags.Zinc.rawValue
            let id = nutrientIdDict[string]!
            results[id] = zinc
        }
        
        if let copp = form.formRowWithTag(Tags.Copper.rawValue)!.value as? Double {
            let string = Tags.Copper.rawValue
            let id = nutrientIdDict[string]!
            results[id] = copp
        }
        
        if let vita = form.formRowWithTag(Tags.VitaminA.rawValue)!.value as? Double {
            let string = Tags.VitaminA.rawValue
            let id = nutrientIdDict[string]!
            results[id] = vita
        }
        
        if let vitc = form.formRowWithTag(Tags.VitaminC.rawValue)!.value as? Double {
            let string = Tags.VitaminC.rawValue
            let id = nutrientIdDict[string]!
            results[id] = vitc
        }
        
        if let vitd = form.formRowWithTag(Tags.VitaminD.rawValue)!.value as? Double {
            let string = Tags.VitaminD.rawValue
            let id = nutrientIdDict[string]!
            results[id] = vitd
        }
        
        if let vite = form.formRowWithTag(Tags.VitaminE.rawValue)!.value as? Double {
            let string = Tags.VitaminE.rawValue
            let id = nutrientIdDict[string]!
            results[id] = vite
        }
        
        if let vitb12 = form.formRowWithTag(Tags.VitaminB12.rawValue)!.value as? Double {
            let string = Tags.VitaminB12.rawValue
            let id = nutrientIdDict[string]!
            results[id] = vitb12
        }
        
        if let fol = form.formRowWithTag(Tags.Folate.rawValue)!.value as? Double {
            let string = Tags.Folate.rawValue
            let id = nutrientIdDict[string]!
            results[id] = fol
        }
        
        if let mang = form.formRowWithTag(Tags.Manganese.rawValue)!.value as? Double {
            let string = Tags.Manganese.rawValue
            let id = nutrientIdDict[string]!
            results[id] = mang
        }
        
        if let chol = form.formRowWithTag(Tags.Cholesterol.rawValue)!.value as? Double {
            let string = Tags.Cholesterol.rawValue
            let id = nutrientIdDict[string]!
            results[id] = chol
        }
        
        if let sat = form.formRowWithTag(Tags.SatFat.rawValue)!.value as? Double {
            let string = Tags.SatFat.rawValue
            let id = nutrientIdDict[string]!
            results[id] = sat
        }
        
        
        
        
        
        print(results)
        //results are now in a dict [Int : Double] (nutrientId: daily rec value)
        //now need to send results dict to model manager to update the values in the db
        let arr = ModelManager.instance.updateRDAs(results)
        print(arr)
        
        
        
        
        //go back.
        navigationController?.popViewControllerAnimated(true)
        
        //let alertView = UIAlertView(title: "Valid Form", message: "No errors found", delegate: self, cancelButtonTitle: "OK")
        //alertView.show()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func refreshPressed(button : UIBarButtonItem) {
        print("refresh values")
        
        // reload form with default RDI values...
        self.defaultForm()
    }
    
    func defaultForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "RDIs")
        form.assignFirstResponderOnShow = false
        
        
        
        
        
        
        //------------MACROS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Macronutrients")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calories
        row = XLFormRowDescriptor(tag: Tags.Calories.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calories (kcal)")
        row.value = self.defaultRDAs[208]!
        section.addFormRow(row)
        
        // Fat
        row = XLFormRowDescriptor(tag: Tags.Fat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fat (g)")
        row.value = self.defaultRDAs[204]!
        section.addFormRow(row)
        
        // Protein
        row = XLFormRowDescriptor(tag: Tags.Protein.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Protein (g)")
        row.value = self.defaultRDAs[203]!
        section.addFormRow(row)
        
        // Carbohydrate
        row = XLFormRowDescriptor(tag: Tags.Carbohydrate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Carbohydrate (g)")
        row.value = self.defaultRDAs[205]!
        section.addFormRow(row)
        
        
        
        
        
        
        
        //------------VITAMINS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Vitamins")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // C
        row = XLFormRowDescriptor(tag: Tags.VitaminC.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin C (mg)")
        row.value = self.defaultRDAs[401]!
        section.addFormRow(row)
        
        // A
        row = XLFormRowDescriptor(tag: Tags.VitaminA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin A (IU)")
        row.value = self.defaultRDAs[318]!
        section.addFormRow(row)
        
        // D
        row = XLFormRowDescriptor(tag: Tags.VitaminD.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin D (IU)")
        row.value = self.defaultRDAs[324]!
        section.addFormRow(row)
        
        // E
        row = XLFormRowDescriptor(tag: Tags.VitaminE.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin E (IU)")
        row.value = self.defaultRDAs[323]!
        section.addFormRow(row)
        
        // B12
        row = XLFormRowDescriptor(tag: Tags.VitaminB12.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin B12 (mcg)")
        row.value = self.defaultRDAs[418]!
        section.addFormRow(row)
        
        // Folate
        row = XLFormRowDescriptor(tag: Tags.Folate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Folate (mcg)")
        row.value = self.defaultRDAs[417]!
        section.addFormRow(row)
        
        
        
        
        
        //------------Minerals------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Minerals")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calcium
        row = XLFormRowDescriptor(tag: Tags.Calcium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calcium (mg)")
        row.value = self.defaultRDAs[301]!
        section.addFormRow(row)
        
        // Phos
        row = XLFormRowDescriptor(tag: Tags.Phosphorus.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Phosphorus (mg)")
        row.value = self.defaultRDAs[305]!
        section.addFormRow(row)
        
        // Pota
        row = XLFormRowDescriptor(tag: Tags.Potassium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Potassium (mg)")
        row.value = self.defaultRDAs[306]!
        section.addFormRow(row)
        
        // Sod
        row = XLFormRowDescriptor(tag: Tags.Sodium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sodium (mg)")
        row.value = self.defaultRDAs[307]!
        section.addFormRow(row)
        
        // Magnesium
        row = XLFormRowDescriptor(tag: Tags.Magnesium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Magnesium (mg)")
        row.value = self.defaultRDAs[304]!
        section.addFormRow(row)
        
        // Iron
        row = XLFormRowDescriptor(tag: Tags.Iron.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Iron (mg)")
        row.value = self.defaultRDAs[303]!
        section.addFormRow(row)
        
        // Zinc
        row = XLFormRowDescriptor(tag: Tags.Zinc.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Zinc (mg)")
        row.value = self.defaultRDAs[309]!
        section.addFormRow(row)
        
        // Selenium
        row = XLFormRowDescriptor(tag: Tags.Selenium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Selenium (mcg)")
        row.value = self.defaultRDAs[317]!
        section.addFormRow(row)
        
        // Copper
        row = XLFormRowDescriptor(tag: Tags.Copper.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Copper (mg)")
        row.value = self.defaultRDAs[312]!
        section.addFormRow(row)
        
        // Manganese
        row = XLFormRowDescriptor(tag: Tags.Manganese.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Manganese (mg)")
        row.value = self.defaultRDAs[315]!
        section.addFormRow(row)
        
        
        
        //------------Other------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Other")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Fiber
        row = XLFormRowDescriptor(tag: Tags.Fiber.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fiber (g)")
        row.value = self.defaultRDAs[291]!
        section.addFormRow(row)
        
        // Caffeine
        row = XLFormRowDescriptor(tag: Tags.Caffeine.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Caffeine (g)")
        row.value = self.defaultRDAs[262]!
        section.addFormRow(row)
        
        // Sugar
        row = XLFormRowDescriptor(tag: Tags.Sugar.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sugar (g)")
        row.value = self.defaultRDAs[269]!
        section.addFormRow(row)
        
        // Cholesterol
        row = XLFormRowDescriptor(tag: Tags.Cholesterol.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Cholesterol (mg)")
        row.value = self.defaultRDAs[601]!
        section.addFormRow(row)
        
        // Sat Fat
        row = XLFormRowDescriptor(tag: Tags.SatFat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Saturated Fat (g)")
        row.value = self.defaultRDAs[606]!
        section.addFormRow(row)
        
        
        
        
        
        
        
        
        
        self.form = form
        
    }
}
