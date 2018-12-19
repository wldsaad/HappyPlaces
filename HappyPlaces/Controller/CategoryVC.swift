//
//  ViewController.swift
//  HappyPlaces
//
//  Created by Waleed Saad on 12/1/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    //VARIABLES
    private var categories = DataService.instance.getCategories()
    @IBOutlet var bottomTableLayout: UIView!
    @IBOutlet weak var distanceText: UITextField!
    private var distance:Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        distance = (distanceText.text! as NSString).doubleValue
    }
    
    //INCREASE/DECREASE DISATANCE
    @IBAction func stepperAction(_ sender: UIStepper) {
        distance = sender.value
        distanceText.text = String(format: "%.0f", distance)
    }
}

//EXTENSIONS
//TABLEVIEW DELEGATE EXTENSION
extension CategoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryTitle = categories[indexPath.row].categoryTitle
        let place = PlaceModel(title: categoryTitle, distance: distance)
        performSegue(withIdentifier: "mapForPlacesSegue", sender: place)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let placesVC = segue.destination as? PlacesVC {
            placesVC.updatePlaceParameters(place: sender as! PlaceModel)
        }
    }
}
//TABLEVIEW DATASOURCE
extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            let category = categories[indexPath.row]
            cell.updateView(category: category)
            cell.selectionStyle = .none
            return cell
        }
        return CategoryCell()
    }
}
