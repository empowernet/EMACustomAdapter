//
//  EmpowerBannerRenderer.swift
//  EmpowerAdapter
//
//  Created by Sena on 18.10.2023.
//

import Foundation
import GoogleMobileAds
 
class EmpowerBannerRendererSwift: NSObject, GADMediationBannerAd, GADBannerViewDelegate {
    
    
    private var empowerAdView: GAMBannerView?
    private var adLoadCallback: GADMediationBannerAdEventDelegate?
    
    var completionHandler: GADMediationBannerLoadCompletionHandler!
    var adConfiguration: GADMediationBannerAdConfiguration!
    
    
    private var codes: [String] = []
    private var waterfallIndex: Int = 0
    
    var view: UIView {
       return
        empowerAdView ?? UIView()
     }

     required override init() {
       super.init()
         
         DebugManager.printLog("Initializing Empower Custom Adapter")
     }

    
    func loadBanner() {
        let request = GAMRequest()
        
        var adJSON: [String: Any] = [:]
        
        DebugManager.printLog("Loading banner")
        
        if let receivedParameter = adConfiguration.credentials.settings["parameter"] as? String {
            adJSON = convertToDictionary(text: receivedParameter) ?? [:]
            
            
            let empowerAdModel = EmpowerAdModel(data: adJSON, adSize: adConfiguration.adSize)
            
            
            if codes.isEmpty {
                if empowerAdModel.hasOptimized {
                    if let size = adJSON["optimize"] as? Int {
                        for index in stride(from: size, through: 1, by: -1) {
                            print("AdUnits: \(empowerAdModel.code)_FP\(index)")
                            
                            codes.append("\(empowerAdModel.code)_FP\(index)")
                        }
                        codes.append(empowerAdModel.code)
                    }
                } else {
                    codes.append(empowerAdModel.code)
                }
            }
            
            empowerAdView = GAMBannerView(adSize: self.adConfiguration.adSize)
            empowerAdView!.rootViewController = self.adConfiguration.topViewController
            empowerAdView!.delegate = self
            
            empowerAdView!.adUnitID = codes[waterfallIndex]
            
            empowerAdView!.load(request)
            
        }
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        DebugManager.printLog("Empower bannerViewDidReceiveAd")
        
        waterfallIndex = 0
        
        if let handler = completionHandler {
            adLoadCallback = handler(self, nil)
        }

    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        DebugManager.printLog("Fail to load ad : \(error.localizedDescription)")
        
        if codes.count-1 > waterfallIndex {
            DebugManager.printLog("Failed to load ad for ad unit: \(codes[waterfallIndex]) for index: \(waterfallIndex) trying another ad unit")
            
            waterfallIndex += 1
            
            self.loadBanner()
            
            return
        }
        
        waterfallIndex = 0
        
        if let handler = completionHandler {
            adLoadCallback = handler(nil, error)
        }
    }
    
    func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
