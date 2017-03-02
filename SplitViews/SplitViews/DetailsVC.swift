//
//  DetailsVC.swift
//  SplitViews
//
//  Created by Radi on 3/2/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var ivItem: UIImageView!
    
    var selectedItem : Item! {
        didSet {
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateUI() -> Void {
        self.ivItem?.downloadedFrom(link: self.selectedItem.imageUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DetailsVC: ItemSelectionDelegate {
    func itemSelected(newItem: Item) {
        self.selectedItem = newItem
    }
}

extension UIImageView {
    func downloadedFrom(url: URL,
                        contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    
    func downloadedFrom(link: String,
                        contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
