//
//  CategoryFilterViewController.swift
//  MapFeature
//
//  Created by Artem Rodionov on 22.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import UIKit
import Core

public class CategoryFilterViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView?
    private var selectedCategory: PlaceCategory = .all
    private let categories = PlaceCategory.allCases
    
    // Callbacks
    public var onCategoryChanged: ((PlaceCategory) -> Void)?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .clear
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SimpleCategoryFilterCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        self.collectionView = collectionView
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    // MARK: - Public Methods
    public func selectCategory(_ category: PlaceCategory) {
        guard category != selectedCategory,
              let collectionView = self.collectionView else {
            return
        }
        
        let oldIndex = categories.firstIndex(of: selectedCategory)
        selectedCategory = category
        let newIndex = categories.firstIndex(of: selectedCategory)
        
        var indexPaths: [IndexPath] = []
        if let oldIndex = oldIndex {
            indexPaths.append(IndexPath(item: oldIndex, section: 0))
        }
        if let newIndex = newIndex {
            indexPaths.append(IndexPath(item: newIndex, section: 0))
        }
        
        // Безопасно перезагружаем только нужные ячейки
        guard !indexPaths.isEmpty else { return }
        collectionView.reloadItems(at: indexPaths)
        
        // Безопасно скроллим к выбранной категории
        if let newIndex = newIndex, newIndex < categories.count {
            let indexPath = IndexPath(item: newIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    public func getCurrentSelectedCategory() -> PlaceCategory {
        return selectedCategory
    }
    
    public func getAllCategories() -> [PlaceCategory] {
        return categories
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryFilterViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? SimpleCategoryFilterCell,
              indexPath.item < categories.count else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        let isSelected = (category == selectedCategory)
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryFilterViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < categories.count else { return }
        
        let category = categories[indexPath.item]
        selectCategory(category)
        onCategoryChanged?(category)
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - SimpleCategoryFilterCell
class SimpleCategoryFilterCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container setup
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerCurve = .continuous
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Labels setup
        emojiLabel.font = .systemFont(ofSize: 14)
        emojiLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        
        // Stack view setup
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with category: PlaceCategory, isSelected: Bool) {
        // Безопасно очищаем предыдущие arranged subviews
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Добавляем emoji если не "all"
        if category != .all {
            emojiLabel.text = category.emoji
            stackView.addArrangedSubview(emojiLabel)
        }
        
        // Добавляем title
        titleLabel.text = category.displayName
        stackView.addArrangedSubview(titleLabel)
        
        // Обновляем внешний вид
        updateAppearance(isSelected: isSelected)
    }
    
    private func updateAppearance(isSelected: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self = self else { return }
                
                if isSelected {
                    self.containerView.backgroundColor = UIColor.systemBlue
                    self.titleLabel.textColor = .white
                    self.containerView.layer.shadowColor = UIColor.systemBlue.cgColor
                    self.containerView.layer.shadowOpacity = 0.3
                    self.containerView.layer.shadowRadius = 6
                    self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
                } else {
                    self.containerView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.8)
                    self.titleLabel.textColor = .secondaryLabel
                    self.containerView.layer.shadowOpacity = 0
                }
            }
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Безопасно очищаем arranged subviews
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Сбрасываем тени
        containerView.layer.shadowOpacity = 0
        
        // Очищаем текст
        emojiLabel.text = nil
        titleLabel.text = nil
    }
}
