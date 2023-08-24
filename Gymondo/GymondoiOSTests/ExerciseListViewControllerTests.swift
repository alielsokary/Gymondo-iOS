//
//  ExerciseListViewControllerTests.swift
//  GymondoiOSTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest

final class ExerciseListViewController {
    init(viewModel: ExerciseListViewControllerTests.ViewModelSpy) {
        
    }
    
}

final class ExerciseListViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadExerciseList() {
        let viewModel = ViewModelSpy()
        _ = ExerciseListViewController(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class ViewModelSpy {
        private(set) var loadCallCount: Int = 0
    }
}
