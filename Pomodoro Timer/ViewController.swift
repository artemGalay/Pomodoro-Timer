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
        button.tintColor = .systemPink
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:05"
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textColor = .systemPink
        label.textAlignment = .center
        return label
    }()

    private lazy var timer = Timer()
    private lazy var isWorkTime = true
    private lazy var isStarted = false
    private lazy var time = 5

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

    @objc private func startButtonTapped() {

        if !isStarted {
            startTimer()
            isStarted = true
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            timer.invalidate()
            isStarted = false
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {

        if time == 0 && isWorkTime {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.textColor = .systemGreen
            startButton.tintColor = .systemGreen
            timer.invalidate()
            time = 3
            isWorkTime = false
            isStarted = false
            timerLabel.text = "00:03"
        } else if time == 0 && !isWorkTime {
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
            time = 5
            isWorkTime = true
            isStarted = false
            timerLabel.text = "00:05"
            timerLabel.textColor = .systemPink
            startButton.tintColor = .systemPink
        } else {
            time -= 1
            timerLabel.text = formatTime()
        }
    }

    private func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
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

