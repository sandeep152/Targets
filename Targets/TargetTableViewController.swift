//
//  TargetTableViewController.swift
//  Targets
//
//  Created by Sandeep Chowdhury on 19/12/2017.
//  Copyright © 2017 Sandeep Chowdhury. All rights reserved.
//

import UIKit

class TargetTableViewController: UITableViewController {

    //MARK: Properties
    
    var Targets = [Target]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load sample data
        loadSampleTargets()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return Targets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TargetTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TargetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TargetTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let target = Targets[indexPath.row]
        
        cell.nameLabel.text = target.name
        cell.photoImageView.image = target.photo
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Actions
    @IBAction func unwindToTargetList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as?
            TargetViewController,
            let targetvariable = sourceViewController.targetvariable {
            //Add a new target
            let newIndexPath = IndexPath(row: Targets.count, section: 0)
            Targets.append(targetvariable)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleTargets(){
    let photo1 = UIImage(named: "sampleTarget1")
    let photo2 = UIImage(named: "sampleTarget2")
        
        guard let sampletarget1 = Target(name: "Coursework deadline", photo: photo1) else {fatalError("Couldn't load sample target 1")}
        guard let sampletarget2 = Target(name: "Gym", photo: photo2) else {fatalError("Couldn't load sample target 2")}
        
    Targets += [sampletarget1, sampletarget2]
    }
}