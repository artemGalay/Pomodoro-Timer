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
        label.text = "25:00"
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textColor = .systemPink
        label.textAlignment = .center
        return label
    }()

    private lazy var timer = Timer()
    private lazy var time = 1500
    private lazy var isWorkTime = true
    private lazy var isStarted = false
    private lazy var isAnimationStarted = false

    private lazy var backProgressLayer = CAShapeLayer()
    private lazy var frontProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        drawBackLayer()
        drawFrontLayer()
        setupHierarchy()
        setConstraints()
    }

    //MARK: - Setup

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

    //MARK: - Action

    @objc private func startButtonTapped() {

        if !isStarted {
            startTimer()
            isStarted = true
            startResumeAnimation()
            startButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            pauseAnimation()
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
            resetAnimation()
            drawFrontLayer()
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timerLabel.textColor = .systemGreen
            startButton.tintColor = .systemGreen
            frontProgressLayer.strokeColor = UIColor.systemGreen.cgColor
            timer.invalidate()
            time = 300
            isWorkTime = false
            isStarted = false
            timerLabel.text = "10:00"
        } else if time == 0 && !isWorkTime {
            resetAnimation()
            drawFrontLayer()
            startButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            timer.invalidate()
            time = 1500
            isWorkTime = true
            isStarted = false
            timerLabel.text = "25:00"
            timerLabel.textColor = .systemPink
            startButton.tintColor = .systemPink
            frontProgressLayer.strokeColor = UIColor.systemPink.cgColor
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

    //MARK: - BackProgressLayer

    private func drawBackLayer() {

        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)

        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle

        backProgressLayer.path = UIBezierPath(arcCenter: center, radius: 170, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
        backProgressLayer.strokeColor = UIColor.white.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }

    //MARK: - FrontProgressLayer

    private func drawFrontLayer() {

        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)

        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle

        frontProgressLayer.path = UIBezierPath(arcCenter: center, radius: 170, startAngle: startAngle, endAngle: endAngle, clockwise: false).cgPath
        frontProgressLayer.strokeColor = UIColor.systemPink.cgColor
        frontProgressLayer.fillColor = UIColor.clear.cgColor
        frontProgressLayer.strokeEnd = 1
        frontProgressLayer.lineCap = CAShapeLayerLineCap.round
        frontProgressLayer.lineWidth = 15
        view.layer.addSublayer(frontProgressLayer)
    }

    //MARK: - Animation

    private func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }

    private func startAnimation() {
        resetAnimation()
        frontProgressLayer.strokeEnd = 0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        frontProgressLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func resetAnimation() {
        isAnimationStarted = false
        frontProgressLayer.speed = 1.0
        frontProgressLayer.timeOffset = 0.0
        frontProgressLayer.beginTime = 0.0
        frontProgressLayer.strokeEnd = 1
    }

    private func pauseAnimation() {
        let pausedTime = frontProgressLayer.convertTime(CACurrentMediaTime(), from: nil)
        frontProgressLayer.speed = 0.0
        frontProgressLayer.timeOffset = pausedTime
    }

    private func resumeAnimation() {
        let pausedTime = frontProgressLayer.timeOffset
        frontProgressLayer.speed = 1.0
        frontProgressLayer.timeOffset = 0.0
        frontProgressLayer.beginTime = 0.0
        let timeSincePaused = frontProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        frontProgressLayer.beginTime = timeSincePaused
    }

    private func stopAnimation() {
        frontProgressLayer.speed = 1.0
        frontProgressLayer.timeOffset = 0.0
        frontProgressLayer.beginTime = 0.0
        frontProgressLayer.strokeEnd = 0.0
        frontProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
}
