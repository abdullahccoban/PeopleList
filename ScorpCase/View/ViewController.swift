//
//  ViewController.swift
//  ScorpCase
//
//  Created by Abdullah Coban on 23.08.2021.
//

import UIKit

class ViewController: UIViewController {

    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = ViewModel()
        viewModel.fetchPersonData()
        tableView.dataSource = self
        setupTableView()
    }
    
    func setupTableView() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshPersonData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Person Data ...")
    }
    
    @objc private func refreshPersonData(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        viewModel.fetchPersonData()
        self.refreshControl.endRefreshing()
    }
        
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfItems == 0 {
            tableView.setEmptyView(title: "", message: "No one here :)")
        } else {
            tableView.restore()
        }
        
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell
        let person: Person
        
        person = viewModel.person(indexPath: indexPath.row)!
        
        cell?.textLabel?.text = person.fullName + " (\(person.id))"
        
        return cell!
    }
    
    
}

extension ViewController: ViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    
}

