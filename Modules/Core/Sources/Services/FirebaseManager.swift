//
// FirebaseManager.swift
// Core
//

import Foundation
import FirebaseCore

public class FirebaseManager {
    public static let shared = FirebaseManager()
    
    private init() {}
    
    public func configure() {
        guard FirebaseApp.app() == nil else {
            print("Firebase уже инициализирован")
            return
        }
        
        FirebaseApp.configure()
        print("🔥 Firebase инициализирован из Core модуля")
    }
}
