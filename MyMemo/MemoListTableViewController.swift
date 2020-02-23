//
//  MemoListTableViewController.swift
//  MyMemo
//
//  Created by 박성영 on 11/02/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchMemo()
        tvListView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = ""
        self.view.endEditing(true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //테스트용으로 sampleMemo 사용
        return DataManager.shared.memoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
        // Configure the cell...
        let memo = DataManager.shared.memoList[indexPath.row]
        if memo.myImage?.count != nil && memo.myImage?.count != 0 {
            let thumbnail = UIImage(data: memo.myImage!.first!)
            cell.imageView?.image = thumbnail
        }
        else{
            cell.imageView?.image = nil
        }
        cell.textLabel?.text = memo.title
        cell.detailTextLabel?.text = memo.mainText
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteMemo = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.removeMemo(deleteMemo)
            DataManager.shared.memoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell , let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailMemoViewController {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }
    
}

extension MemoListTableViewController :UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DataManager.shared.searchMemo(searchText)
        tvListView.reloadData()
    }

}
