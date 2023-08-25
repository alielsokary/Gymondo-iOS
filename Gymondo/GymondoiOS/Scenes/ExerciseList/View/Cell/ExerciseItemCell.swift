//
//  ExerciseItemCell.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit

class ExerciseItemCell: UITableViewCell {

    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    func setupUI() {
        exerciseImageView.layer.cornerRadius = 8.0
        exerciseImageView.clipsToBounds = true

        exerciseImageView.layer.borderWidth = 1.0
        exerciseImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
