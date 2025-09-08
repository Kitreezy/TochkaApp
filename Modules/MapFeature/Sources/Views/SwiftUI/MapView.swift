import SwiftUI
import MapKit
import Core
import DesignSystem

public struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var showLocationPermissionAlert = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Карта на весь экран
            mapView
            
            // Overlay элементы
            overlayContent
            
        }

        .onAppear {
            viewModel.requestLocationPermission()
        }
        .alert("Разрешение на геолокацию", isPresented: $showLocationPermissionAlert) {
            Button("Настройки") { openAppSettings() }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Для работы карты необходимо разрешение на доступ к геолокации. Откройте настройки и предоставьте разрешение.")
        }
        .onChange(of: viewModel.locationAuthorizationStatus) { status in
            if status == .denied || status == .restricted {
                showLocationPermissionAlert = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.showPlaceDetail) {
            if let selectedPlace = viewModel.selectedPlace {
                PlaceDetailView(
                    places: viewModel.places,
                    initialPlace: selectedPlace,
                    userLocation: viewModel.userLocation
                )
            }
        }
    }
    
    // MARK: - Map View
    private var mapView: some View {
        Map(
            coordinateRegion: $viewModel.mapRegion,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .none,
            annotationItems: viewModel.places
        ) { place in
            MapAnnotation(coordinate: place.coordinate) {
                PlaceMapMarker(
                    place: place,
                    isSelected: viewModel.selectedPlace?.id == place.id
                ) {
                    viewModel.selectPlace(place)
                }
            }
        }
        .onTapGesture {
            viewModel.selectedPlace = nil
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Overlay Content
    private var overlayContent: some View {
        VStack(spacing: 0) {
            // Верхние элементы
            topControls
            
            Spacer()
            
            // Нижние элементы
            bottomElements
        }
    }
    
    // MARK: - Top Controls
    private var topControls: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                MapSearchBarView(
                    searchText: $viewModel.searchText,
                    onFilterTap: viewModel.toggleFilterSheet
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            HStack {
        
                MapTypeToggle(mapType: $viewModel.mapType)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            
            HStack {
                Spacer()
                
                MapControlsView(
                    onLocationTap: {
                        if viewModel.isLocationAvailable {
                            viewModel.centerOnUserLocation()
                        } else {
                            viewModel.requestLocationPermission()
                        }
                    },
                    onZoomIn: viewModel.zoomIn,
                    onZoomOut: viewModel.zoomOut
                )
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Bottom Elements
    private var bottomElements: some View {
//        VStack(spacing: 0) {
        ZStack {
            
            // Category filter
            CategoryFilterView(
                selectedCategory: $viewModel.selectedCategory,
                onCategoryChanged: { category in
                    print("Выбрана категория: \(category.displayName)")
                }
            )
            .padding(.bottom, 16)
            
            // Bottom sheet
            PlaceBottomSheet(
                places: viewModel.places,
                userLocation: viewModel.userLocation,
                selectedPlace: $viewModel.selectedPlace,
                selectedCategory: $viewModel.selectedCategory,
                isLoading: viewModel.isLoading,
                onPlaceSelected: { place in
                    viewModel.selectPlace(place)
                },
                onCreateActivity: { place in
                    viewModel.createActivityAtPlace(place)
                },
                onCategoryChanged: { category in
                    // ИСПОЛЬЗОВАТЬ метод viewModel
                    viewModel.selectCategory(category)
                },
                onShowPlaceDetail: { place in
                    viewModel.showPlaceDetails(place)
                }
            )
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text("Поиск мест...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Helper Methods
    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Map Marker
struct PlaceMapMarker: View {
    let place: Place
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(place.category.gradient)
                        .frame(width: isSelected ? 36 : 28, height: isSelected ? 36 : 28)
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: isSelected ? 6 : 3,
                            x: 0,
                            y: isSelected ? 3 : 2
                        )
                    
                    Text(place.category.emoji)
                        .font(.system(size: isSelected ? 16 : 12))
                    
                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 40, height: 40)
                    }
                }
                
                Triangle()
                    .fill(place.category.gradient)
                    .frame(width: 8, height: 6)
                    .offset(y: -1)
                    .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
