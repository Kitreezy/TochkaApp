//
//  LocationManager.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

public class LocationManager: NSObject, ObservableObject {
    public static let shared = LocationManager()
    
    @Published public var location: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var errorMessage: String?
    
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Обновлять каждые 10 метров
        
        authorizationStatus = locationManager.authorizationStatus
        print("📍 LocationManager: Начальный статус авторизации: \(authorizationStatus.rawValue)")
    }
    
    // MARK: - Public Methods
    
    public func requestLocationPermission() {
        print("📍 LocationManager: Запрашиваем разрешение на геолокацию...")
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("❌ LocationManager: Доступ запрещен")
            errorMessage = "Для работы приложения необходимо разрешение на доступ к геолокации"
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            print("⚠️ LocationManager: Неизвестный статус авторизации")
        }
    }
    
    public func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            print("❌ LocationManager: Нет разрешения для получения геолокации")
            return
        }
        
        print("📍 LocationManager: Начинаем отслеживание геолокации...")
        locationManager.startUpdatingLocation()
    }
    
    public func stopLocationUpdates() {
        print("📍 LocationManager: Останавливаем отслеживание геолокации...")
        locationManager.stopUpdatingLocation()
    }
    
    public func getCurrentLocation() -> CLLocationCoordinate2D? {
        return location?.coordinate
    }
    
    // MARK: - Convenience Properties
    
    public var isLocationAvailable: Bool {
        location != nil
    }
    
    public var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Фильтруем слишком старые или неточные данные
        guard newLocation.timestamp.timeIntervalSinceNow > -5,
              newLocation.horizontalAccuracy < 100 else {
            return
        }
        
        print("📍 LocationManager: Новая геолокация: \(newLocation.coordinate)")
        location = newLocation
        errorMessage = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ LocationManager: Ошибка геолокации: \(error.localizedDescription)")
        errorMessage = "Не удалось получить геолокацию: \(error.localizedDescription)"
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("📍 LocationManager: Изменение статуса авторизации: \(status.rawValue)")
        
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = status
            
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("✅ LocationManager: Разрешение получено")
                self?.startLocationUpdates()
                self?.errorMessage = nil
            case .denied, .restricted:
                print("❌ LocationManager: Разрешение отклонено")
                self?.errorMessage = "Доступ к геолокации запрещен"
                self?.stopLocationUpdates()
            case .notDetermined:
                print("⏳ LocationManager: Статус не определен")
            @unknown default:
                print("⚠️ LocationManager: Неизвестный статус")
            }
        }
    }
}
