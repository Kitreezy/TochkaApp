import Foundation
import Combine
import MapKit
import CoreLocation
import SwiftUI
import Core

@MainActor
public class MapViewModel: BaseViewModel {
    // MARK: - Published Properties
    
    // Карта и локация
    @Published public var mapRegion = MKCoordinateRegion(
        center: .rostovOnDon,
        latitudinalMeters: 10000,
        longitudinalMeters: 10000
    )
    @Published public var mapType: MKMapType = .standard
    @Published public var userLocation: CLLocationCoordinate2D?
    
    // Поиск и фильтрация
    @Published public var searchText = ""
    @Published public var selectedCategory: PlaceCategory = .all
    @Published public var places: [Place] = []
    @Published public var selectedPlace: Place?
    
    // UI состояния
    @Published public var showFilterSheet = false
    @Published public var showPlaceDetail = false
    @Published public var isSearching = false
    
    // MARK: - Private Properties
    private let locationManager = LocationManager.shared
    private let placesService = PlacesService.shared
    private var searchDebounceTimer: Timer?
    
    public override init() {
        super.init()
        setupBindings()
        setupInitialState()
    }
    
    // MARK: - Setup Methods
    
    private func setupBindings() {
        // Подписываемся на изменения локации пользователя
        locationManager.$location
            .compactMap { $0?.coordinate }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.handleLocationUpdate(location)
            }
            .store(in: &cancellables)
        
        // Подписываемся на изменения мест от сервиса
        placesService.$places
            .receive(on: DispatchQueue.main)
            .sink { [weak self] places in
                self?.handlePlacesUpdate(places)
            }
            .store(in: &cancellables)
        
        // Подписываемся на состояние загрузки
        placesService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // Подписываемся на ошибки от сервиса
        placesService.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(TochkaError.networkError(error))
            }
            .store(in: &cancellables)
        
        // ИЗМЕНИТЬ: отдельная подписка на поиск с debounce
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearchTextChange(query)
            }
            .store(in: &cancellables)
        
        // ДОБАВИТЬ: отдельная подписка на категорию БЕЗ debounce
        $selectedCategory
            .removeDuplicates()
            .sink { [weak self] category in
                self?.handleCategoryChangeImmediate(category)
            }
            .store(in: &cancellables)
    }
    
    private func setupInitialState() {
        print("🗺️ MapViewModel: Инициализация...")
        
        // Запрашиваем разрешение на геолокацию
        requestLocationPermission()
        
        // Загружаем начальные места
        loadNearbyPlaces()
    }
    
    // MARK: - Public Methods
    
    public func requestLocationPermission() {
        print("📍 MapViewModel: Запрашиваем разрешение на геолокацию...")
        locationManager.requestLocationPermission()
    }
    
    public func centerOnUserLocation() {
        guard let userLocation = userLocation else {
            showError(TochkaError.invalidData)
            return
        }
        
        print("📍 MapViewModel: Центрируем карту на пользователе")
        
        withAnimation(.easeInOut(duration: 1.0)) {
            mapRegion = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 5000,
                longitudinalMeters: 5000
            )
        }
    }
    
    public func zoomIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            mapRegion.span.latitudeDelta *= 0.7
            mapRegion.span.longitudeDelta *= 0.7
        }
    }
    
    public func zoomOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            mapRegion.span.latitudeDelta *= 1.3
            mapRegion.span.longitudeDelta *= 1.3
        }
    }
    
    public func selectPlace(_ place: Place) {
        print("🏢 MapViewModel: Выбрано место: \(place.name)")
        selectedPlace = place
        
        // Центрируем карту на выбранном месте
        withAnimation(.easeInOut(duration: 0.8)) {
            mapRegion.center = place.coordinate
        }
    }
    
    public func showPlaceDetails(_ place: Place) {
        selectedPlace = place
        showPlaceDetail = true
    }
    
    public func createActivityAtPlace(_ place: Place) {
        print("🎯 MapViewModel: Создание активности в месте: \(place.name)")
        // TODO: Навигация к экрану создания активности
        selectedPlace = place
        // Здесь будет переход к ActivityFeature
    }
    
    public func toggleFilterSheet() {
        showFilterSheet.toggle()
    }
    
    public func searchPlaces(query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            loadNearbyPlaces()
            return
        }
        
        let searchLocation = userLocation ?? .rostovOnDon
        isSearching = true
        
        placesService.searchPlaces(
            query: query,
            category: selectedCategory,
            around: searchLocation
        )
    }
    
    public func loadNearbyPlaces() {
        let location = userLocation ?? .rostovOnDon
        print("🔍 MapViewModel: Загружаем места рядом с \(location)")
        
        placesService.getPlacesNearby(
            location: location,
            category: selectedCategory
        )
    }
    
    // MARK: - Private Event Handlers
    
    private func handleCategoryChangeImmediate(_ category: PlaceCategory) {
        print("🏷️ MapViewModel: Мгновенное изменение категории: \(category.displayName)")
        
        // Немедленно обновляем места без debounce
        if searchText.isEmpty {
            loadNearbyPlaces()
        } else {
            searchPlaces(query: searchText)
        }
    }
    
    private func handleLocationUpdate(_ location: CLLocationCoordinate2D) {
        print("📍 MapViewModel: Обновление геолокации: \(location)")
        userLocation = location
        
        // Центрируем карту на пользователе при первом получении локации
        if mapRegion.center.latitude == CLLocationCoordinate2D.rostovOnDon.latitude {
            withAnimation(.easeInOut(duration: 1.5)) {
                mapRegion = MKCoordinateRegion(
                    center: location,
                    latitudinalMeters: 10000,
                    longitudinalMeters: 10000
                )
            }
        }
        
        // Перезагружаем места для новой локации
        loadNearbyPlaces()
    }
    
    private func handlePlacesUpdate(_ newPlaces: [Place]) {
        print("🏢 MapViewModel: Обновление мест: \(newPlaces.count)")
        
        let limitedPlaces = Array(newPlaces.prefix(50))
        places = limitedPlaces
        
        isSearching = false
    }
    
    private func handleSearchTextChange(_ query: String) {
        print("🔍 MapViewModel: Поиск: '\(query)'")
        
        if query.isEmpty {
            loadNearbyPlaces()
        } else {
            searchPlaces(query: query)
        }
    }
    
    private func handleCategoryChange(_ category: PlaceCategory) {
        print("🏷️ MapViewModel: Изменение категории: \(category.displayName)")
        
        if searchText.isEmpty {
            loadNearbyPlaces()
        } else {
            searchPlaces(query: searchText)
        }
    }
    
    public func selectCategory(_ category: PlaceCategory) {
        print("🏷️ MapViewModel: Выбрана категория через UI: \(category.displayName)")
        
        selectedCategory = category
    }
    
    // MARK: - Computed Properties
    
    public var isLocationAvailable: Bool {
        locationManager.isLocationAvailable
    }
    
    public var locationAuthorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    public var placesCount: Int {
        places.count
    }
}

// MARK: - Error Handling Extension
extension MapViewModel {
    private func showError(_ error: TochkaError) {
        errorMessage = error.localizedDescription
        print("❌ MapViewModel: Ошибка - \(error.localizedDescription)")
    }
}



