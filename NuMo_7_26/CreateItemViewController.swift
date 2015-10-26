//
//  CreateItemViewController.swift
//  NuMo_7_26
//
//  Created by Kathryn Manning on 7/26/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//

import UIKit
import XLForm

class CreateItemViewController: XLFormViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
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
        case Name = "name"
        case PickerViewInline = "selectorPickerViewInline"
        case GroupSelector = "groupSelector"
        case ServingSelector = "servingSelector"
        case O6Fattys = "totalomega6"
        case DHA = "dha"
        case EPA = "epa"
        case DPA = "dpa"
        case ALA = "ala"
        case OtherO3 = "otherO3"
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
        "satfat" : 606, //
        "totalomega6" : 618, //call it 618, unless make new catchall nutrient for n-6s
        "dha" : 621,
        "epa" : 629,
        "dpa" : 631,
        "ala" : 851,
        "otherO3" : 619 //call it 619, unless make new catchall nutrient for n-3s
    ]
    
    
    
    let foodGroupDict = [
        "Dairy and Egg" : 100,
        "Spices and Herbs" : 200,
        "Baby Foods" : 300,
        "Fats and Oils" : 400,
        "Poultry" : 500,
        "Soups, Sauces, and Gravies" : 600,
        "Sausages and Luncheon Meats" : 700,
        "Breakfast Cereals" : 800,
        "Fruits and Fruit Juices" : 900,
        "Pork" : 1000,
        "Vegetables" : 1100,
        "Nuts and Seeds" : 1200,
        "Beef" : 1300,
        "Beverages" : 1400,
        "Fish" : 1500,
        "Legumes" : 1600,
        "Lamb, Veal, and Game" : 1700,
        "Baked Goods" : 1800,
        "Sweets" : 1900,
        "Grains and Pasta" : 2000,
        "Fast Foods" : 2100,
        "Meals, Entrees, and Sides" : 2200,
        "Snacks" : 2500,
        "Restaurant Foods" : 3600,
        "Supplements" : 4000,
        "Group" : 9999 //unchosen
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
        
        form = XLFormDescriptor(title: "Create Food")
        form.assignFirstResponderOnShow = true
        
        
        
        
        
        //------------Name and Info------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Item")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        
        // Name of Food
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.required = true
        section.addFormRow(row)
        
        // Food Group Choice
        row = XLFormRowDescriptor(tag: Tags.GroupSelector.rawValue, rowType:XLFormRowDescriptorTypeSelectorPickerViewInline, title:"Food Group")
        row.selectorOptions = ["Dairy and Egg", "Spices and Herbs", "Baby Foods", "Fats and Oils", "Poultry", "Soups, Sauces, and Gravies", "Sausages and Luncheon Meats", "Breakfast Cereals", "Fruits and Fruit Juices",
            "Pork", "Vegetables", "Nuts and Seeds", "Beef", "Beverages", "Fish", "Legumes", "Lamb, Veal, and Game", "Baked Goods", "Sweets", "Grains and Pasta",
            "Fast Foods", "Meals, Entrees, and Sides", "Snacks", "Restaurant Foods", "Supplements"]
        row.value = "Dairy and Egg"
        row.required = true
        section.addFormRow(row)

        
        // --------- Inline Selectors
        section = XLFormSectionDescriptor.formSectionWithTitle("Serving")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.ServingSelector.rawValue, rowType:XLFormRowDescriptorTypeSelectorPickerViewInline, title:"Description")
        row.selectorOptions = ["Serving", "Bottle", "Box", "Can", "Container", "Cube", "Cup", "Each", "Fluid Ounce",
        "Gallon", "Gram", "Individual", "Jar", "Liter", "Milligram", "Ounce", "Package", "Piece", "Pint", "Pound",
        "Scoop", "Slice", "Stick", "Tablespoon", "Tablet", "Teaspoon", "Quart", "Pouch"]
        row.value = "Serving"
        row.required = true
        section.addFormRow(row)
        
        
        
        
        
        
        //------------MACROS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Nutrient Values")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calories
        row = XLFormRowDescriptor(tag: Tags.Calories.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calories (kcal)")
        //row.value = self.nRDAs![208]!
        section.addFormRow(row)
        
        // Fat
        row = XLFormRowDescriptor(tag: Tags.Fat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fat (g)")
        //row.value = self.nRDAs![204]!
        section.addFormRow(row)
        
        // Sat Fat
        row = XLFormRowDescriptor(tag: Tags.SatFat.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Saturated Fat (g)")
        //row.value = self.nRDAs![606]!
        section.addFormRow(row)
        
        // Protein
        row = XLFormRowDescriptor(tag: Tags.Protein.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Protein (g)")
        //row.value = self.nRDAs![203]!
        section.addFormRow(row)
        
        // Carbohydrate
        row = XLFormRowDescriptor(tag: Tags.Carbohydrate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Carbohydrate (g)")
        //row.value = self.nRDAs![205]!
        section.addFormRow(row)
        
        // Fiber
        row = XLFormRowDescriptor(tag: Tags.Fiber.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Fiber (g)")
        //row.value = self.nRDAs![291]!
        section.addFormRow(row)
        
        // Sugar
        row = XLFormRowDescriptor(tag: Tags.Sugar.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sugar (g)")
        //row.value = self.nRDAs![269]!
        section.addFormRow(row)
        
        // Cholesterol
        row = XLFormRowDescriptor(tag: Tags.Cholesterol.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Cholesterol (mg)")
        //row.value = self.nRDAs![601]!
        section.addFormRow(row)
        

        
        
        
        
        
        
        
        //------------VITAMINS------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Vitamins")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // C
        row = XLFormRowDescriptor(tag: Tags.VitaminC.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin C (mg)")
        //row.value = self.nRDAs![401]!
        section.addFormRow(row)
        
        // A
        row = XLFormRowDescriptor(tag: Tags.VitaminA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin A (IU)")
        //row.value = self.nRDAs![318]!
        section.addFormRow(row)
        
        // D
        row = XLFormRowDescriptor(tag: Tags.VitaminD.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin D (IU)")
        //row.value = self.nRDAs![324]!
        section.addFormRow(row)
        
        // E
        row = XLFormRowDescriptor(tag: Tags.VitaminE.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin E (IU)")
        //row.value = self.nRDAs![323]!
        section.addFormRow(row)
        
        // B12
        row = XLFormRowDescriptor(tag: Tags.VitaminB12.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Vitamin B12 (mcg)")
        //row.value = self.nRDAs![418]!
        section.addFormRow(row)
        
        // Folate
        row = XLFormRowDescriptor(tag: Tags.Folate.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Folate (mcg)")
        //row.value = self.nRDAs![417]!
        section.addFormRow(row)
        
        
        
        
        
        //------------Minerals------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Minerals")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Calcium
        row = XLFormRowDescriptor(tag: Tags.Calcium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Calcium (mg)")
        //row.value = self.nRDAs![301]!
        section.addFormRow(row)
        
        // Phos
        row = XLFormRowDescriptor(tag: Tags.Phosphorus.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Phosphorus (mg)")
        //row.value = self.nRDAs![305]!
        section.addFormRow(row)
        
        // Pota
        row = XLFormRowDescriptor(tag: Tags.Potassium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Potassium (mg)")
        //row.value = self.nRDAs![306]!
        section.addFormRow(row)
        
        // Sod
        row = XLFormRowDescriptor(tag: Tags.Sodium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Sodium (mg)")
        //row.value = self.nRDAs![307]!
        section.addFormRow(row)
        
        // Magnesium
        row = XLFormRowDescriptor(tag: Tags.Magnesium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Magnesium (mg)")
        //row.value = self.nRDAs![304]!
        section.addFormRow(row)
        
        // Iron
        row = XLFormRowDescriptor(tag: Tags.Iron.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Iron (mg)")
        //row.value = self.nRDAs![303]!
        section.addFormRow(row)
        
        // Zinc
        row = XLFormRowDescriptor(tag: Tags.Zinc.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Zinc (mg)")
        //row.value = self.nRDAs![309]!
        section.addFormRow(row)
        
        // Selenium
        row = XLFormRowDescriptor(tag: Tags.Selenium.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Selenium (mcg)")
        //row.value = self.nRDAs![317]!
        section.addFormRow(row)
        
        // Copper
        row = XLFormRowDescriptor(tag: Tags.Copper.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Copper (mg)")
        //row.value = self.nRDAs![312]!
        section.addFormRow(row)
        
        // Manganese
        row = XLFormRowDescriptor(tag: Tags.Manganese.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Manganese (mg)")
        //row.value = self.nRDAs![315]!
        section.addFormRow(row)
        
        
        
        
        //------------Fatty Acids------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Fatty Acids")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        // DHA
        row = XLFormRowDescriptor(tag: Tags.DHA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "DHA (mg)")
        //row.value = self.nRDAs![301]!
        section.addFormRow(row)
        
        // EPA
        row = XLFormRowDescriptor(tag: Tags.EPA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "EPA (mg)")
        //row.value = self.nRDAs![305]!
        section.addFormRow(row)
        
        // DPA
        row = XLFormRowDescriptor(tag: Tags.DPA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "DPA (mg)")
        //row.value = self.nRDAs![301]!
        section.addFormRow(row)
        
        // ALA
        row = XLFormRowDescriptor(tag: Tags.ALA.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "ALA (mg)")
        //row.value = self.nRDAs![305]!
        section.addFormRow(row)
        
        // other O3
        row = XLFormRowDescriptor(tag: Tags.OtherO3.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Other Omega-3 (mg)")
        //row.value = self.nRDAs![306]!
        section.addFormRow(row)
        
        // total 06
        row = XLFormRowDescriptor(tag: Tags.O6Fattys.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Total Omega-6 (mg)")
        //row.value = self.nRDAs![307]!
        section.addFormRow(row)
        
        
        
        
        //------------Other------------//
        
        section = XLFormSectionDescriptor.formSectionWithTitle("Other")
        //section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        // Caffeine
        row = XLFormRowDescriptor(tag: Tags.Caffeine.rawValue, rowType: XLFormRowDescriptorTypeDecimal, title: "Caffeine (g)")
        //row.value = self.nRDAs![262]!
        section.addFormRow(row)

        
        
        
        
        
        
        
        
        
        self.form = form
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        var button1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
//        var button2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshPressed:")
//        
//        var arrayOfButtons = [button1,button2]
//        self.navigationItem.rightBarButtonItems = arrayOfButtons
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "savePressed:")
        
    
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    
    
    
    
    
    
    func savePressed(button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        
        
        //------use food group chosen and name to make food table item-----//
        
        //get group chosen
        var grpNumber : Int
        
        if let foodGrp = form.formRowWithTag(Tags.GroupSelector.rawValue)!.value as? String {
            //look up actual food group number
            grpNumber = foodGroupDict[foodGrp]!
            print(grpNumber)
        } else {grpNumber = 0}
        
        var name : String
        
        if let nameChosen = form.formRowWithTag(Tags.Name.rawValue)!.value as? String {
            name = nameChosen
            print(name)
        } else {name = "na"}
        
        
        
        //tuple of the (food group number, name chosen)
        let groupAndName = (grpNumber, name)
        
        print(groupAndName)
        
 
        
        //-----use serving chosen for weight table entry-----//
        
        //get serving chosen
        var servingDesc : String
        
        if let foodServing = form.formRowWithTag(Tags.ServingSelector.rawValue)!.value as? String {
          servingDesc = foodServing
        } else {servingDesc = "na"}
        
        
        

        
        
        
        //--------Get the Nutrient Values-------//
        
        var nutrientAmounts = [Int:Double]()
        

        if let calories = form.formRowWithTag(Tags.Calories.rawValue)!.value as? Double {
            let string = Tags.Calories.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = calories
        }
        
        if let fat = form.formRowWithTag(Tags.Fat.rawValue)!.value as? Double {
            let string = Tags.Fat.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = fat
        }
        
        if let satfat = form.formRowWithTag(Tags.SatFat.rawValue)!.value as? Double {
            let string = Tags.SatFat.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = satfat
        }
        
        if let protein = form.formRowWithTag(Tags.Protein.rawValue)!.value as? Double {
            let string = Tags.Protein.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = protein
        }
        
        if let carbo = form.formRowWithTag(Tags.Carbohydrate.rawValue)!.value as? Double {
            let string = Tags.Carbohydrate.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = carbo
        }
        
        if let fiber = form.formRowWithTag(Tags.Fiber.rawValue)!.value as? Double {
            let string = Tags.Fiber.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = fiber
        }
        
        if let sugar = form.formRowWithTag(Tags.Sugar.rawValue)!.value as? Double {
            let string = Tags.Sugar.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = sugar
        }
        
        if let cholest = form.formRowWithTag(Tags.Cholesterol.rawValue)!.value as? Double {
            let string = Tags.Cholesterol.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = cholest
        }
        
        
        
        
        if let vitc = form.formRowWithTag(Tags.VitaminC.rawValue)!.value as? Double {
            let string = Tags.VitaminC.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = vitc
        }
        
        if let vita = form.formRowWithTag(Tags.VitaminA.rawValue)!.value as? Double {
            let string = Tags.VitaminA.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = vita
        }
        
        if let vitd = form.formRowWithTag(Tags.VitaminD.rawValue)!.value as? Double {
            let string = Tags.VitaminD.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = vitd
        }
        
        if let vite = form.formRowWithTag(Tags.VitaminE.rawValue)!.value as? Double {
            let string = Tags.VitaminE.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = vite
        }
        
        if let vitb12 = form.formRowWithTag(Tags.VitaminB12.rawValue)!.value as? Double {
            let string = Tags.VitaminB12.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = vitb12
        }
        
        if let folate = form.formRowWithTag(Tags.Folate.rawValue)!.value as? Double {
            let string = Tags.Folate.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = folate
        }
        
        
        
        
        if let calcium = form.formRowWithTag(Tags.Calcium.rawValue)!.value as? Double {
            let string = Tags.Calcium.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = calcium
        }
        
        if let phos = form.formRowWithTag(Tags.Phosphorus.rawValue)!.value as? Double {
            let string = Tags.Phosphorus.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = phos
        }
        
        if let potass = form.formRowWithTag(Tags.Potassium.rawValue)!.value as? Double {
            let string = Tags.Potassium.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = potass
        }
        
        if let sodium = form.formRowWithTag(Tags.Sodium.rawValue)!.value as? Double {
            let string = Tags.Sodium.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = sodium
        }
        
        if let magnes = form.formRowWithTag(Tags.Magnesium.rawValue)!.value as? Double {
            let string = Tags.Magnesium.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = magnes
        }
        
        if let iron = form.formRowWithTag(Tags.Iron.rawValue)!.value as? Double {
            let string = Tags.Iron.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = iron
        }
        
        if let zinc = form.formRowWithTag(Tags.Zinc.rawValue)!.value as? Double {
            let string = Tags.Zinc.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = zinc
        }
        
        if let selen = form.formRowWithTag(Tags.Selenium.rawValue)!.value as? Double {
            let string = Tags.Selenium.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = selen
        }
        
        if let copp = form.formRowWithTag(Tags.Copper.rawValue)!.value as? Double {
            let string = Tags.Copper.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = copp
        }
        
        if let mangan = form.formRowWithTag(Tags.Manganese.rawValue)!.value as? Double {
            let string = Tags.Manganese.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = mangan
        }
        
        
        
        if let dha = form.formRowWithTag(Tags.DHA.rawValue)!.value as? Double {
            let string = Tags.DHA.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = dha / 1000.0
        }
        
        if let epa = form.formRowWithTag(Tags.EPA.rawValue)!.value as? Double {
            let string = Tags.EPA.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = epa / 1000.0
        }
        
        if let dpa = form.formRowWithTag(Tags.DPA.rawValue)!.value as? Double {
            let string = Tags.DPA.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = dpa / 1000.0
        }
        
        if let ala = form.formRowWithTag(Tags.ALA.rawValue)!.value as? Double {
            let string = Tags.ALA.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = ala / 1000.0
        }
        
        if let othero3 = form.formRowWithTag(Tags.OtherO3.rawValue)!.value as? Double {
            let string = Tags.OtherO3.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = othero3 / 1000.0
        }
        
        if let totalo6 = form.formRowWithTag(Tags.O6Fattys.rawValue)!.value as? Double {
            let string = Tags.O6Fattys.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = totalo6 / 1000.0
        }
        
        
        
        
        
        
        if let caffeine = form.formRowWithTag(Tags.Caffeine.rawValue)!.value as? Double {
            let string = Tags.Caffeine.rawValue
            let id = nutrientIdDict[string]!
            nutrientAmounts[id] = caffeine
        }
        
        

       
        print(nutrientAmounts)
        
        
        //use model manager to create the food item in the food table
        let theNewFoodsId = ModelManager.instance.createFoodEntry(groupAndName, serving: servingDesc, nutrients: nutrientAmounts)
        
        ModelManager.instance.aFoodWasAdded(theNewFoodsId)
        
        
        
        
        
//        //results are now in a dict [Int : Double] (nutrientId: daily rec value)
//        //now need to send results dict to model manager to update the values in the db
//        //let arr = ModelManager.instance.updateRDAs(results)
//        //println(arr)
//        
//        
//        
//        
//        //go back.
        //navigationController?.popViewControllerAnimated(true)
//        
          let alertView = UIAlertView(title: "Message", message: "The foods Id is \(theNewFoodsId)", delegate: self, cancelButtonTitle: "OK")
          alertView.show()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

}
