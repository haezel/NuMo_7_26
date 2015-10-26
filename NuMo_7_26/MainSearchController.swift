//
//  FirstViewController.swift
//  CustyTabPractice
//
//  Created by Kathryn Manning on 6/18/15.
//  Copyright (c) 2015 kathrynmanning. All rights reserved.
//


import UIKit

var allFoods = [Food]()

class MainSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var filteredFoods = [Food]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    
    var identifier : String = "Cell"
    
    var searchController : UISearchController?
    var searchResultsController : UITableViewController?
    
    override func viewDidLoad() {
        
        print("*****VIEW DID LOAD******")
        super.viewDidLoad()
        
        self.title = "Search Item"
        
        //menu button function (and swipe)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let backItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        // A table for search results and its controller.
        let resultsTableView = UITableView(frame: self.tableView.frame)
        self.searchResultsController = UITableViewController()
        self.searchResultsController?.tableView = resultsTableView
        self.searchResultsController?.tableView.dataSource = self
        self.searchResultsController?.tableView.delegate = self
        
        // Register cell class for the identifier.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        
        self.searchResultsController?.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.identifier)
        
        self.searchController = UISearchController(searchResultsController: self.searchResultsController!)
        self.searchController?.searchResultsUpdater = self
        self.searchController?.delegate = self
        self.searchController?.searchBar.sizeToFit() // bar size
        self.tableView.tableHeaderView = self.searchController?.searchBar
        
        
        self.definesPresentationContext = true
        
        //get rid of 1 cell space at top and bottom of tableview - not best solution
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //deselect any selected rows
        if self.tableView.indexPathForSelectedRow != nil {
            let indexPath = self.tableView.indexPathForSelectedRow
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
        if self.searchResultsController?.tableView.indexPathForSelectedRow != nil {
            let indexPath = self.searchResultsController?.tableView.indexPathForSelectedRow
            self.searchResultsController?.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("memory warning!")
    }
    //-------Table View Methods-------//
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchResultsController?.tableView {
            let results = self.filteredFoods
            if results.count != 0
            {
                return results.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            return allFoods.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier)! as UITableViewCell
        
        var text: String?
        if tableView == self.searchResultsController?.tableView {
            let results = self.filteredFoods
            if results.count != 0
            {
                text = self.filteredFoods[indexPath.row].desc
            }
        } else {
            text = allFoods[indexPath.row].desc
        }
        
        cell.textLabel!.text = text
        cell.textLabel!.font = UIFont(name: "AvenirNextCondensed-Regular", size: 18.0)
        cell.backgroundColor = UIColor.colorFromCode(0xDBE6EC)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ToDetailSegue", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDetailSegue"
        {
            let destinationVC = segue.destinationViewController as! PickAmountViewController
            
            //sender is the filtered results table
            if sender as? UITableView == self.searchResultsController?.tableView {
                
                let indexPath = (sender as? UITableView)!.indexPathForSelectedRow!
                let chosenItemId = self.filteredFoods[indexPath.row]
                destinationVC.foodItem = chosenItemId
            }
            else //sender is the original table
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let chosenItem = allFoods[indexPath.row]
                destinationVC.foodItem = chosenItem
            }
            
        }
    }
    
    //--------UISearchResultsUpdating methods--------//
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if self.searchController?.searchBar.text!.lengthOfBytesUsingEncoding(NSUTF32StringEncoding) > 0 {
            
            let searchBarText = self.searchController!.searchBar.text
            
            self.filterContentForSearchText(searchBarText!)
            
            // Reload a table with results.
            self.searchResultsController?.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchBarText : String) {
        self.filteredFoods = allFoods.filter({(food : Food) -> Bool in
            let stringMatch = food.desc.rangeOfString(searchBarText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            
            //let stringMatch = food.desc.uppercaseString.rangeOfString(searchBarText.uppercaseString)
            return (stringMatch != nil)
        })
    }
    
    //--------UISearchControllerDelegate methods--------//
    
    func didDismissSearchController(searchController: UISearchController) {
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            //self.hideSearchBar()
            }, completion: nil)
    }
    
    
}
