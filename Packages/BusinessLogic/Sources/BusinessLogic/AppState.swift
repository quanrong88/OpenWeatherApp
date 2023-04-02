//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation
import DataAccess

public class AppState {
    public var unit: DataAccess.Unit = .standard
    public var q: String = ""
    public var lat: Double = 0
    public var lon: Double = 0
    
    public static let shared = AppState()
    
    public init() {}
    
    public func clear() {
        q = ""
        unit = .standard
        lat = 0
        lon = 0
    }
}
