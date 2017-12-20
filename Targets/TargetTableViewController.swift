//
//  TargetTableViewController.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 19/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
// REMINDER: ; are not needed after every line and {} are being and end statements

import UIKit
import os.log

class TargetTableViewController: UITableViewController {

    //MARK: Properties
    
    var targets = [Target]()
    var daysRemainingofTarget: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load saved targets or sample data if no targets to load
        if let savedTargets = loadTargets(){
        targets += savedTargets
        } else {
        //Load sample data
        loadSampleTargets()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up date formatter
        let dateFormatter = DateFormatter()
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TargetTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TargetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TargetTableViewCell.")
        }
        
        // Fetches the appropriate target for the data source layout.
        let target = targets[indexPath.row]
        
        cell.nameLabel.text = target.name
        cell.descLabel.text = target.desc
        cell.dueDateLabel.text = ("Due: \(target.dueDate)")
        cell.photoImageView.image = target.photo
        cell.dueDateLabel.text = target.dueDate
        
        //Calculate remaining number of days
        let dateString = cell.dueDateLabel.text
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateFromString = dateFormatter.date(from: dateString!)
        let days = Calendar.current.dateComponents([.day], from: dateFromString!, to: Date()).day

        //Mutate the number of remaining days displayed
        let daysDisplay = Int(abs(days!))
        if daysDisplay > 99 {
            cell.daysRemainLabel.text = ("99+")
            cell.daysRemainLabel.textColor = .blue
        } else if daysDisplay < 1 {
            cell.daysRemainLabel.text = ("0")
            cell.daysRemainLabel.textColor = .red
        } else {
        cell.daysRemainLabel.text = ("\(daysDisplay)")
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            targets.remove(at: indexPath.row)
            saveTargets()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
            
        case "AddItem":
            os_log("Adding a new target.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
                guard let targetDetailViewController = segue.destination as? TargetViewController else {
                fatalError("Unexpected segue destination: \(segue.destination)")
            }
            
                guard let selectedTargetCell = sender as? TargetTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
                guard let indexPath = tableView.indexPath(for: selectedTargetCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedTarget = targets[indexPath.row]
                targetDetailViewController.targetvariable = selectedTarget
                
                default:
                    fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
            }
        }


    //MARK: Actions
    @IBAction func unwindToTargetList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? TargetViewController,
            let targetvariable = sourceViewController.targetvariable {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update existing target
                targets[selectedIndexPath.row] = targetvariable
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
            //Add a new target
            let newIndexPath = IndexPath(row: targets.count, section: 0)
            targets.append(targetvariable)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
            saveTargets()
    }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleTargets(){
    let photo1 = UIImage(named: "sampleTarget1")
    let photo2 = UIImage(named: "sampleTarget2")
        
        guard let sampletarget1 = Target(name: "Coursework deadline", desc: "Include 5 references", dueDate: "07-12-2018", photo: photo1) else {fatalError("Couldn't load sample target 1")}
        guard let sampletarget2 = Target(name: "Gym", desc: "LEG DAY!", dueDate: "02-02-2018", photo: photo2) else {fatalError("Couldn't load sample target 2")}
        
    targets += [sampletarget1, sampletarget2]
    }
    
    //Save targets method
   private func saveTargets(){
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(targets, toFile: Target.ArchiveURL.path)
    if isSuccessfulSave {
        os_log("Targets saved.", log: OSLog.default, type: .debug)
    } else {
        os_log("Failed to save targets.", log: OSLog.default, type: .error)
    }
    }
    
    //Load targets method
    private func loadTargets() -> [Target]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Target.ArchiveURL.path) as? [Target]
    }
}
