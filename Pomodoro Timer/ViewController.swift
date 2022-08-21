//
//  ViewController.swift
//  Pomodoro Timer
//
//  Created by Артем Галай on 21.08.22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9411764706, green: 0.9294117647, blue: 0.8862745098, alpha: 1)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:05"
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHierarchy()
        setConstraints()
    }

    private func setupHierarchy() {
        view.addSubview(startButton)
        view.addSubview(timerLabel)
    }

    private func setConstraints() {
        timerLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timerLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(60)
        }
    }
}

