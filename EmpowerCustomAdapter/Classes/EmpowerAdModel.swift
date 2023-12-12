//
//  EmpowerAdModel.swift
//  EmpowerAdapter
//
//  Created by Sena on 18.10.2023.
//

import Foundation
import GoogleMobileAds

class EmpowerAdModel {
    var code: String = ""
    var adSize: GADAdSize = GADAdSizeBanner
    var optimize: Int? = nil
    var rtb: [RTB]? = nil
    var multipleSize: Bool = false
    var overflow: Bool = true
    var adSizes: [GADAdSize] = []
    
    var hasOptimized: Bool = false
    
    init(data: [String: Any], adSize: GADAdSize? = nil) {
        if let value = data["code"] as? String {
            code = value
        }
        
        if adSize != nil {
            self.adSize = adSize!
        }
        
        
        adSizes.append(self.adSize)
        
        if let value = data["multipleSize"] as? Bool {
            multipleSize = value
        }
        
        if let value = data["overflow"] as? Bool {
            overflow = value
        }
        
        
        if overflow {
            adSizes.append(GADAdSizeFluid)
        }
        
        if let value = data["optimize"] as? Bool {
            hasOptimized = value
        }
        
        if hasOptimized {
            if let value = data["optimize"] as? Int {
                optimize = value
            }
        }
        
        if let value = data["rtb"] as? [[String: Any]] {
            for rtbItem in value {
                self.rtb?.append(RTB(data: rtbItem))
            }
        }
    }
    
    private func getAdSize(for size: String) -> CGSize {
        switch size {
        case "320x50":
            return CGSize(width: 320, height: 50)
        case "320x100":
            return CGSize(width: 320, height: 100)
        case "300x250":
            return CGSize(width: 300, height: 250)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        }
    }
}
