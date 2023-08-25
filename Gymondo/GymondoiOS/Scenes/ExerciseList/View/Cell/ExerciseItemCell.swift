//
//  ExerciseItemCell.swift
//  GymondoiOS
//
//  Created by Ali Elsokary on 25/08/2023.
//

import UIKit
import Kingfisher
import Gymondo

class ExerciseItemCell: UITableViewCell {

    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!

    var viewModel: ExerciseItemViewModel! {
        didSet {
            exerciseNameLabel.text = viewModel.name
            exerciseImageView.kf.setImage(with: URL(string: (viewModel.imageItem?.image).unwrapped), placeholder: UIImage(named: "logo"))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        self.selectionStyle = .none
        exerciseImageView.layer.cornerRadius = 8.0
        exerciseImageView.clipsToBounds = true

        exerciseImageView.layer.borderWidth = 1.0
        exerciseImageView.layer.borderColor = UIColor.lightGray.cgColor
    }
}
