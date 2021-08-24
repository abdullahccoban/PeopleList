//
//  ViewModel.swift
//  ScorpCase
//
//  Created by Abdullah Coban on 24.08.2021.
//

import Foundation

protocol ViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    func person(indexPath: Int) -> Person?
    func fetchPersonData()
    
}

protocol ViewModelDelegate: AnyObject {
    func reloadData()
    
    
}

final class ViewModel {
    
    var people = [Person]()
    weak var delegate: ViewModelDelegate?
    
    private func FetchPeople() {
        DataSource.fetch(next: nil) { [self] FetchResponse, FetchError in
            people = FetchResponse?.people ?? []
            self.delegate?.reloadData()
        }
    }
}

extension ViewModel: ViewModelProtocol {
    func fetchPersonData() {
        FetchPeople()
    }
    
    func person(indexPath: Int) -> Person? {
        people[safe: indexPath]
    }
    
    var numberOfItems: Int {
        people.count
    }
    
    
}
