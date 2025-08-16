//
//  MemeMainMostsharedHeaderView.swift
//  Meme
//
//  Created by 제나 on 8/6/25.
//

import UIKit

final class MemeMainMostsharedHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "MemeMainMostsharedHeaderView"
    
    private var timer: Timer?
    private var upcomingFetch: String?
    private var defaultRemainingTime: TimeInterval = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.display2)),
            text: "단톡방행 밈 셔틀,\n지금 탑승하세요 🚂",
            color: .white(.white)
        )
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .pretendard(.title(.subhead1)),
            text: "지금 가장 많이 공유된 밈만 골라 실었어요",
            color: .gray(.gray4))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .customFont(
            .galmuri(.headline),
            text: "-- : -- : --",
            color: .white(.white))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            timerLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            timerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Public
    func configureHeader(upcomingFetch: String) {
        stop()
        self.upcomingFetch = upcomingFetch
        
        // upcomingFetch가 빈 문자열이거나 유효하지 않은 경우 기본 타이머 시작
        if upcomingFetch.isEmpty {
            startDefaultTimer { [weak self] remainingTime in
                DispatchQueue.main.async {
                    self?.timerLabel.attributedText = .customFont(
                        .galmuri(.headline),
                        text: remainingTime,
                        color: .white(.white))
                }
            }
        } else {
            start { [weak self] remainingTime in
                DispatchQueue.main.async {
                    self?.timerLabel.attributedText = .customFont(
                        .galmuri(.headline),
                        text: remainingTime,
                        color: .white(.white))
                }
            }
        }
    }
    
    private func startDefaultTimer(update: @escaping (String) -> Void) {
        timer?.invalidate()
        
        // 기본 시작 시간을 현재 시간으로부터 24시간 후로 설정
        let defaultStartTime = Date().addingTimeInterval(24 * 60 * 60)
        defaultRemainingTime = defaultStartTime.timeIntervalSince(Date())
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.defaultRemainingTime -= 1
            
            if self.defaultRemainingTime <= 0 {
                self.defaultRemainingTime = 0
                self.stop()
            }
            
            let formatted = self.defaultRemainingTime.format()
            update(formatted)
        }
    }
    
    private func start(update: @escaping (String) -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self,
                  let upcomingFetch = self.upcomingFetch,
                  !upcomingFetch.isEmpty
            else { return }
            
            let remaining = upcomingFetch.remainingTimeInterval()
            
            if remaining <= 0 {
                self.stop()
                return
            }
            
            let formatted = remaining.format()
            update(formatted)
        }
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
        defaultRemainingTime = 0
    }
}
