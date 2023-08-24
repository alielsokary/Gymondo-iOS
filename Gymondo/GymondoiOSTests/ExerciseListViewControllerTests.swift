//
//  ExerciseListViewControllerTests.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest
import UIKit

final class ExerciseListViewController: UIViewController {
    private var viewModel: ExerciseListViewControllerTests.ViewModelSpy?
    
    convenience init(viewModel: ExerciseListViewControllerTests.ViewModelSpy) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.load()
    }
    
}

final class ExerciseListViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadExerciseList() {
        let viewModel = ViewModelSpy()
        _ = ExerciseListViewController(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsExerciseList() {
        let viewModel = ViewModelSpy()
        let sut = ExerciseListViewController(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModel.loadCallCount, 1)
    }
    
    // MARK: - Helpers
    
    class ViewModelSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
