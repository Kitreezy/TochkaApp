//
//  PlaceDetailView.swift
//  MapFeature
//
//  Created by Artem Rodionov on 18.07.2025.
//  Copyright © 2025 com.tochka.app. All rights reserved.
//

import SwiftUI
import MapKit
import Core
import DesignSystem

public struct PlaceDetailView: View {
    let places: [Place]
    let initialPlace: Place
    let userLocation: CLLocationCoordinate2D?
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var isLiked = false
    
    public init(places: [Place], initialPlace: Place, userLocation: CLLocationCoordinate2D?) {
        self.places = places
        self.initialPlace = initialPlace
        self.userLocation = userLocation
        self._currentIndex = State(initialValue: places.firstIndex(where: { $0.id == initialPlace.id }) ?? 0)
    }
    
    public init(place: Place, userLocation: CLLocationCoordinate2D?) {
        self.places = [place]
        self.initialPlace = place
        self.userLocation = userLocation
        self._currentIndex = State(initialValue: 0)
    }
    
    var currentPlace: Place {
        places[currentIndex]
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                PlaceHeaderView(place: currentPlace, userLocation: userLocation)
                PlaceInfoView(place: currentPlace, userLocation: userLocation)
                ActionButtonsView(place: currentPlace)
                Spacer()
            }
            .navigationTitle("Детали места")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isLiked.toggle() }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(isLiked ? .blue : .textPrimary)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
    }
    
    private struct PlaceHeaderView: View {
        let place: Place
        let userLocation: CLLocationCoordinate2D?
        
        var body: some View {
            ZStack(alignment: .topTrailing) {
                place.category.gradient
                    .frame(height: 200)
                    .overlay(
                        Text(place.category.emoji)
                            .font(.system(size: 60))
                    )
                if let userLocation = userLocation {
                    Text(place.distanceDisplay(from: userLocation))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                }
            }
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    
    private struct PlaceInfoView: View {
        let place: Place
        let userLocation: CLLocationCoordinate2D?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(place.name)
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)
                Text(place.description)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index < Int(place.rating) ? .orange : .gray.opacity(0.3))
                            .font(.system(size: 12))
                    }
                    Text("\(String(format: "%.1f", place.rating)) (\(place.reviewCount) reviews)")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                }
                HStack(spacing: 8) {
                    if let userLocation = userLocation {
                        InfoItem(title: walkingTimeDisplay(for: place), subtitle: "ПЕШКОМ")
                    }
                    InfoItem(title: place.priceLevel?.rawValue ?? "Бесплатно", subtitle: "ВХОД")
                    InfoItem(title: place.openingHours ?? "Уточнить", subtitle: "ЧАСЫ")
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        
        private func walkingTimeDisplay(for place: Place) -> String {
            guard let userLocation = userLocation else { return "—" }
            let distance = place.distance(from: userLocation)
            let walkingSpeed: Double = 83 // метров в минуту (5 км/ч)
            let timeInMinutes = Int(distance / walkingSpeed)
            return timeInMinutes < 60 ? "\(timeInMinutes) мин" : "\(timeInMinutes / 60)ч \(timeInMinutes % 60)м"
        }
    }
    
    private struct ActionButtonsView: View {
        let place: Place
        
        var body: some View {
            HStack(spacing: 12) {
                Button(action: { openInMaps(for: place) }) {
                    Text("Получить маршрут")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                Button(action: { }) {
                    Text("Сохранить")
                        .font(.body)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        
        private func openInMaps(for place: Place) {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            mapItem.name = place.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
    }
    
    private struct InfoItem: View {
        let title: String
        let subtitle: String
        
        var body: some View {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                Text(subtitle.uppercased())
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .tracking(0.5)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
        }
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView(place: Place.samplePlaces[0], userLocation: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050))
    }
}
