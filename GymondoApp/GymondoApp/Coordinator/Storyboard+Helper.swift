//
//  Storyboard+Helper.swift
//  GymondoApp
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit
import GymondoiOS

enum Storyboard: String {
    case Exercises

    var instance: UIStoryboard {
        let bundle = Bundle(for: ExerciseListViewController.self)
      return UIStoryboard(name: rawValue, bundle: bundle)
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
}
