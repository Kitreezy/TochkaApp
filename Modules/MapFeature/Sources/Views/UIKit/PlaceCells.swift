//
//  PlaceCells.swift
//  MapFeature
//
//  Created by Artem Rodionov on 22.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import UIKit
import Core
import CoreLocation

// MARK: - PlaceCollectionViewCell (для horizontal режима)
class PlaceCollectionViewCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let distanceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let metaStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.cornerCurve = .continuous
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Icon container
        iconContainerView.layer.cornerRadius = 8
        iconContainerView.layer.cornerCurve = .continuous
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Emoji
        emojiLabel.font = .systemFont(ofSize: 24)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(emojiLabel)
        
        // Title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Distance
        distanceLabel.font = .systemFont(ofSize: 11, weight: .medium)
        distanceLabel.textColor = .systemBlue
        
        // Rating
        ratingLabel.font = .systemFont(ofSize: 11)
        ratingLabel.textColor = .systemOrange
        
        // Meta stack
        metaStackView.axis = .horizontal
        metaStackView.spacing = 8
        metaStackView.translatesAutoresizingMaskIntoConstraints = false
        metaStackView.addArrangedSubview(distanceLabel)
        metaStackView.addArrangedSubview(ratingLabel)
        
        // Add subviews
        [iconContainerView, titleLabel, descriptionLabel, metaStackView].forEach {
            containerView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Icon container
            iconContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconContainerView.widthAnchor.constraint(equalToConstant: 40),
            iconContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            // Emoji
            emojiLabel.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            // Meta stack
            metaStackView.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 8),
            metaStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            metaStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12),
            metaStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with place: Place, userLocation: CLLocationCoordinate2D?) {
        // Безопасно очищаем предыдущие gradient слои
        cleanupGradientLayers()
        
        // Создаем новый gradient layer
        setupGradientBackground(for: place.category)
        
        // Устанавливаем контент
        emojiLabel.text = place.category.emoji
        titleLabel.text = place.name
        descriptionLabel.text = place.description
        ratingLabel.text = place.ratingDisplay
        
        // Безопасно показываем расстояние
        if let userLocation = userLocation {
            distanceLabel.text = place.distanceDisplay(from: userLocation)
            distanceLabel.isHidden = false
        } else {
            distanceLabel.text = ""
            distanceLabel.isHidden = true
        }
    }
    
    private func cleanupGradientLayers() {
        // Безопасно удаляем только gradient слои
        if let sublayers = iconContainerView.layer.sublayers {
            sublayers.forEach { layer in
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func setupGradientBackground(for category: PlaceCategory) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gradientLayer.cornerRadius = 8
        gradientLayer.colors = getGradientColors(for: category)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        iconContainerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getGradientColors(for category: PlaceCategory) -> [CGColor] {
        switch category {
        case .all:
            return [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        case .food:
            return [UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor]
        case .culture:
            return [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]
        case .nature:
            return [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor]
        case .shopping:
            return [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
        case .entertainment:
            return [UIColor.systemBlue.cgColor, UIColor.systemCyan.cgColor]
        case .accommodation:
            return [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        case .transport:
            return [UIColor.systemGray.cgColor, UIColor.black.cgColor]
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Безопасно очищаем gradient слои
        cleanupGradientLayers()
        
        // Сбрасываем текстовые значения
        emojiLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""
        ratingLabel.text = ""
        distanceLabel.text = ""
        
        // Сбрасываем selection состояние
        updateSelectionAppearance(isSelected: false)
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance(isSelected: isSelected)
        }
    }
    
    private func updateSelectionAppearance(isSelected: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            if isSelected {
                self.containerView.layer.borderColor = UIColor.systemBlue.cgColor
                self.containerView.layer.borderWidth = 2
                self.containerView.layer.shadowColor = UIColor.systemBlue.cgColor
                self.containerView.layer.shadowOpacity = 0.2
                self.containerView.layer.shadowRadius = 8
                self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            } else {
                self.containerView.layer.borderColor = UIColor.systemGray5.cgColor
                self.containerView.layer.borderWidth = 1
                self.containerView.layer.shadowOpacity = 0
            }
        }
    }
}

// MARK: - PlaceTableViewCell (для vertical режима)
class PlaceTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let metaStackView = UIStackView()
    private let distanceLabel = UILabel()
    private let ratingLabel = UILabel()
    private let priceLabel = UILabel()
    private let buttonStackView = UIStackView()
    private let detailButton = UIButton(type: .system)
    private let activityButton = UIButton(type: .system)
    
    // Callback for activity creation
    var onCreateActivity: ((Place) -> Void)?
    private var place: Place?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.cornerCurve = .continuous
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Icon container
        iconContainerView.layer.cornerRadius = 8
        iconContainerView.layer.cornerCurve = .continuous
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Emoji
        emojiLabel.font = .systemFont(ofSize: 24)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(emojiLabel)
        
        // Title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Meta labels
        distanceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        distanceLabel.textColor = .systemBlue
        
        ratingLabel.font = .systemFont(ofSize: 12)
        ratingLabel.textColor = .systemOrange
        
        priceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceLabel.textColor = .systemGreen
        
        // Meta stack
        metaStackView.axis = .horizontal
        metaStackView.spacing = 12
        metaStackView.translatesAutoresizingMaskIntoConstraints = false
        [distanceLabel, ratingLabel, priceLabel].forEach { metaStackView.addArrangedSubview($0) }
        
        // Buttons
        detailButton.setTitle("Подробнее", for: .normal)
        detailButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        detailButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        detailButton.layer.cornerRadius = 8
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        
        activityButton.setTitle("Активность", for: .normal)
        activityButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        activityButton.backgroundColor = .systemGreen
        activityButton.setTitleColor(.white, for: .normal)
        activityButton.layer.cornerRadius = 8
        activityButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Используем современный UIAction вместо target-action
        activityButton.addAction(UIAction { [weak self] _ in
            self?.handleActivityButtonTap()
        }, for: .touchUpInside)
        
        // Button stack
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 8
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.addArrangedSubview(detailButton)
        buttonStackView.addArrangedSubview(activityButton)
        
        // Add subviews
        [iconContainerView, titleLabel, descriptionLabel, metaStackView, buttonStackView].forEach {
            containerView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Icon container
            iconContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconContainerView.widthAnchor.constraint(equalToConstant: 50),
            iconContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            // Emoji
            emojiLabel.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Meta stack
            metaStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            metaStackView.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 12),
            
            // Button stack
            buttonStackView.topAnchor.constraint(equalTo: metaStackView.bottomAnchor, constant: 12),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with place: Place, userLocation: CLLocationCoordinate2D?) {
        self.place = place
        
        // Безопасно очищаем предыдущие gradient слои
        cleanupGradientLayers()
        
        // Создаем новый gradient layer (размер больше чем в collection cell)
        setupGradientBackground(for: place.category)
        
        // Устанавливаем контент
        emojiLabel.text = place.category.emoji
        titleLabel.text = place.name
        descriptionLabel.text = place.description
        ratingLabel.text = place.ratingDisplay
        
        // Безопасно показываем расстояние
        if let userLocation = userLocation {
            distanceLabel.text = place.distanceDisplay(from: userLocation)
            distanceLabel.isHidden = false
        } else {
            distanceLabel.text = ""
            distanceLabel.isHidden = true
        }
        
        // Безопасно показываем цену
        if let priceLevel = place.priceLevel {
            priceLabel.text = priceLevel.rawValue
            priceLabel.isHidden = false
        } else {
            priceLabel.text = ""
            priceLabel.isHidden = true
        }
    }
    
    private func cleanupGradientLayers() {
        // Безопасно удаляем только gradient слои
        if let sublayers = iconContainerView.layer.sublayers {
            sublayers.forEach { layer in
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func setupGradientBackground(for category: PlaceCategory) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        gradientLayer.cornerRadius = 8
        gradientLayer.colors = getGradientColors(for: category)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        iconContainerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func getGradientColors(for category: PlaceCategory) -> [CGColor] {
        switch category {
        case .all:
            return [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        case .food:
            return [UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor]
        case .culture:
            return [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]
        case .nature:
            return [UIColor.systemGreen.cgColor, UIColor.systemTeal.cgColor]
        case .shopping:
            return [UIColor.systemPink.cgColor, UIColor.systemPurple.cgColor]
        case .entertainment:
            return [UIColor.systemBlue.cgColor, UIColor.systemCyan.cgColor]
        case .accommodation:
            return [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        case .transport:
            return [UIColor.systemGray.cgColor, UIColor.black.cgColor]
        }
    }
    
    private func handleActivityButtonTap() {
        if let place = place {
            onCreateActivity?(place)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Безопасно очищаем gradient слои
        cleanupGradientLayers()
        
        // Сбрасываем все значения
        emojiLabel.text = ""
        titleLabel.text = ""
        descriptionLabel.text = ""
        ratingLabel.text = ""
        distanceLabel.text = ""
        priceLabel.text = ""
        
        // Очищаем ссылки
        place = nil
        onCreateActivity = nil
        
        // Сбрасываем selection состояние
        updateSelectionAppearance(isSelected: false)
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance(isSelected: isSelected)
        }
    }
    
    private func updateSelectionAppearance(isSelected: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            
            if isSelected {
                self.containerView.layer.borderColor = UIColor.systemBlue.cgColor
                self.containerView.layer.borderWidth = 2
                self.containerView.layer.shadowColor = UIColor.systemBlue.cgColor
                self.containerView.layer.shadowOpacity = 0.2
                self.containerView.layer.shadowRadius = 8
                self.containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            } else {
                self.containerView.layer.borderColor = UIColor.systemGray6.cgColor
                self.containerView.layer.borderWidth = 1
                self.containerView.layer.shadowOpacity = 0
            }
        }
    }
}
