//
//  MenuVC.swift
//  SplitViews
//
//  Created by Radi on 3/2/17.
//  Copyright © 2017 Oryx. All rights reserved.
//

import UIKit

protocol ItemSelectionDelegate: class {
    func itemSelected(newItem: Item)
}

class MenuVC: UIViewController {
    
    @IBOutlet weak var tvMenu: UITableView!
    
    weak var delegate: ItemSelectionDelegate?
    
    var items : [Item] = [
        Item(id: 12,
             title: "Item 1",
             image: "https://www.researchgate.net/file.PostFileLoader.html?id=51928848d11b8b2a6900003e&assetKey=AS%3A272115322818562%401441888756635"),
        Item(id: 13,
             title: "Item 2",
             image: "https://s-media-cache-ak0.pinimg.com/originals/4a/2a/be/4a2abedc51ffcf2876a9ebce1feacefa.png")
    ]
    
    var selectedItem : Item?
    
    func getItemFor(row: Int) -> Item {
        return self.items[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvMenu.dataSource = self
        self.tvMenu.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension MenuVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = self.delegate as? DetailsVC {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
        
        let row = indexPath.row
        let item = self.getItemFor(row: row)
        self.delegate?.itemSelected(newItem: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MenuVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ItemCell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "ItemCell")
        }
        
        let item = getItemFor(row: indexPath.row)
        cell!.textLabel?.text = item.title
        return cell!
    }
}


