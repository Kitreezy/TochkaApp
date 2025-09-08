//
//  BottomSheetViewController.swift
//  MapFeature
//
//  Created by Artem Rodionov on 22.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import UIKit
import SwiftUI
import Core
import CoreLocation

public class BottomSheetViewController: UIViewController {
    
    // MARK: - Types
    public enum SheetState {
        case collapsed  // Горизонтальный скролл
        case expanded   // Вертикальный скролл
        
        var height: CGFloat {
            switch self {
            case .collapsed: return 220
            case .expanded: return 500
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .collapsed: return 16
            case .expanded: return 20
            }
        }
    }
    
    // MARK: - Properties
    private var currentState: SheetState = .collapsed
    
    // UI Components
    private let containerView = UIView()
    private let dragIndicator = UIView()
    private let stackView = UIStackView()
    
    // Content Views
    private var collapsedContentView: UIView?
    private var expandedContentView: UIView?
    
    // Collection and Table Views
    private var horizontalCollectionView: UICollectionView?
    private var verticalTableView: UITableView?
    
    // Constraints
    private var bottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    // Data
    public var places: [Place] = [] {
        didSet {
            updateContent()
        }
    }
    public var userLocation: CLLocationCoordinate2D?
    public var selectedPlace: Place? {
        didSet {
            updateSelection()
        }
    }
    
    // Callbacks
    public var onPlaceSelected: ((Place) -> Void)?
    public var onCreateActivity: ((Place) -> Void)?
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        createContentViews()
        showContentForState(.collapsed)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .clear
        
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = currentState.cornerRadius
        containerView.layer.cornerCurve = .continuous
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: -5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Drag indicator
        dragIndicator.backgroundColor = UIColor.systemGray3
        dragIndicator.layer.cornerRadius = 2.5
        dragIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Hierarchy
        view.addSubview(containerView)
        containerView.addSubview(dragIndicator)
        containerView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        let bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: currentState.height)
        
        self.bottomConstraint = bottomConstraint
        self.heightConstraint = heightConstraint
        
        NSLayoutConstraint.activate([
            // Container
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            heightConstraint,
            
            // Drag indicator
            dragIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            dragIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dragIndicator.widthAnchor.constraint(equalToConstant: 36),
            dragIndicator.heightAnchor.constraint(equalToConstant: 5),
            
            // Stack view
            stackView.topAnchor.constraint(equalTo: dragIndicator.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
    }
    
    private func createContentViews() {
        createCollapsedContent()
        createExpandedContent()
    }
    
    // MARK: - Collapsed Content (Horizontal Scroll)
    private func createCollapsedContent() {
        let container = UIView()
        
        // Header
        let headerView = createHeaderView(
            title: "Места поблизости",
            actionTitle: "Показать все",
            action: { [weak self] in
                self?.expandToFull()
            }
        )
        
        // Horizontal Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 120)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: "PlaceCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.horizontalCollectionView = collectionView
        
        // Layout
        container.addSubview(headerView)
        container.addSubview(collectionView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 140),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        
        collapsedContentView = container
    }
    
    // MARK: - Expanded Content (Vertical Scroll)
    private func createExpandedContent() {
        let container = UIView()
        
        // Header
        let headerView = createHeaderView(
            title: "Все места",
            actionTitle: "Свернуть",
            action: { [weak self] in
                self?.collapseToNormal()
            }
        )
        
        // Vertical Table View
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: "PlaceTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.verticalTableView = tableView
        
        // Layout
        container.addSubview(headerView)
        container.addSubview(tableView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: container.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        expandedContentView = container
    }
    
    // MARK: - Helper Methods
    private func createHeaderView(title: String, actionTitle: String, action: @escaping () -> Void) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let actionButton = UIButton(type: .system)
        actionButton.setTitle(actionTitle, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Используем современный UIAction вместо target-action
        actionButton.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        container.addSubview(titleLabel)
        container.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            actionButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    // MARK: - State Management
    private func expandToFull() {
        animateToState(.expanded)
    }
    
    private func collapseToNormal() {
        animateToState(.collapsed)
    }
    
    private func animateToState(_ newState: SheetState) {
        guard newState != currentState else { return }
        
        currentState = newState
        
        // Анимация изменения высоты и радиуса
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut]
        ) { [weak self] in
            guard let self = self else { return }
            
            self.heightConstraint?.constant = newState.height
            self.containerView.layer.cornerRadius = newState.cornerRadius
            self.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.showContentForState(newState)
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }
    }
    
    private func showContentForState(_ state: SheetState) {
        // Очищаем текущий контент
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Добавляем нужный контент
        switch state {
        case .collapsed:
            if let collapsedView = collapsedContentView {
                stackView.addArrangedSubview(collapsedView)
            }
        case .expanded:
            if let expandedView = expandedContentView {
                stackView.addArrangedSubview(expandedView)
            }
        }
    }
    
    // MARK: - Data Updates
    private func updateContent() {
        DispatchQueue.main.async { [weak self] in
            self?.horizontalCollectionView?.reloadData()
            self?.verticalTableView?.reloadData()
        }
    }
    
    private func updateSelection() {
        DispatchQueue.main.async { [weak self] in
            // Обновляем выделение в обеих view при необходимости
            self?.horizontalCollectionView?.reloadData()
            self?.verticalTableView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension BottomSheetViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(places.count, 10) // Максимум 10 в horizontal режиме
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceCell", for: indexPath) as? PlaceCollectionViewCell,
              indexPath.item < places.count else {
            return UICollectionViewCell()
        }
        
        let place = places[indexPath.item]
        cell.configure(with: place, userLocation: userLocation)
        
        // Безопасная проверка выделения
        if let selectedId = selectedPlace?.id {
            cell.isSelected = (place.id == selectedId)
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BottomSheetViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < places.count else { return }
        
        let place = places[indexPath.item]
        selectedPlace = place
        onPlaceSelected?(place)
    }
}

// MARK: - UITableViewDataSource
extension BottomSheetViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableCell", for: indexPath) as? PlaceTableViewCell,
              indexPath.row < places.count else {
            return UITableViewCell()
        }
        
        let place = places[indexPath.row]
        cell.configure(with: place, userLocation: userLocation)
        
        // Безопасная проверка выделения
        if let selectedId = selectedPlace?.id {
            cell.isSelected = (place.id == selectedId)
        } else {
            cell.isSelected = false
        }
        
        // Безопасно устанавливаем callback
        cell.onCreateActivity = { [weak self] place in
            self?.onCreateActivity?(place)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BottomSheetViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row < places.count else { return }
        
        let place = places[indexPath.row]
        selectedPlace = place
        onPlaceSelected?(place)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
