//
//  ImagesTableViewController.swift
//  Scroll
//
//  Created by Radi on 3/6/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController  {

    private let imageUrls : [String] = [
        "https://www.w3schools.com/css/trolltunga.jpg",
        "http://www.shunvmall.com/data/out/114/47159008-image.png",
        "http://hookedoneverything.com/wp-content/uploads/2015/04/panama-featured-iamge1-810x539.jpg"
    ]
    
    private var selectedImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.imageUrls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell",
                                                 for: indexPath)
        if let title = cell.viewWithTag(1) as? UILabel {
            title.text = "Image \(indexPath.row)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedImage = self.imageUrls[indexPath.row]
        //Perform selection
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showImage", sender: self)
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showImage" {
            if let destinationVC = segue.destination as? ViewController {
                if self.selectedImage != nil {
                    destinationVC.imageUrl = URL(string: self.selectedImage!)
                }
            }
        }
    }

}

extension ImagesTableViewController : UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
