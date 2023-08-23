//
//  GymondoAPIEndToEndTests.swift
//  GymondoAPIEndToEndTests
//
//  Created by Ali Elsokary on 24/08/2023.
//

import XCTest
import Combine
@testable import Gymondo

final class GymondoAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETExercisesResult_matchesAPIData() {
        let apiService: ExerciseService = ExerciseServiceImpl()

        let exp = expectation(description: "Wait for completion")

        _ = apiService.dispatch(ExercisesRouter.GetExercises())
            .sink { completion in
                switch completion {
                case .finished:
                    exp.fulfill()

                case let .failure(error):
                    XCTFail("Expected successful data result, got \(error) instead")
                }
        } receiveValue: { value in
            value.results?.enumerated().forEach({ exerciseItem in
                XCTAssertEqual(exerciseItem.element.id, self.id(at: exerciseItem.offset))
                XCTAssertEqual(exerciseItem.element.name, self.name(at: exerciseItem.offset))
            })
        }
        wait(for: [exp], timeout: 5.0)
    }

    // MARK: - Helpers

    private func id(at index: Int) -> Int {
        return [345,
                2078,
                1731,
                1728,
                1734,
                1737,
                1316,
                2083,
                1311,
                2145,
                1061,
                1312,
                2056,
                2055,
                174,
                1906,
                1457,
                1888,
                1706,
                1830][index]
    }

    private func name(at index: Int) -> String? {
        return [
            "2 Handed Kettlebell Swing",
            "3D lunge warmup",
            "4-count burpees",
            "4-Hitung burpe",
            "4-tel burpees",
            "4-العد burpees",
            "Abdominal",
            "Abdominales",
            "Abdominales",
            "Abdominales sovieticas",
            "Abdominal Stabilization",
            "Abdominaux",
            "Abduktion im Stand",
            "Abduktion im Stand",
            "Abduktoren-Maschine",
            "Abwechselnde Bizepscurls",
            "Accroupi",
            "Achternek rekken",
            "Achterwaartse arm cirkels",
            "Achterwaartse schouder draaiing"
        ][index]
    }
}
