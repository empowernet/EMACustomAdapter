//
//  EmpowerInterstitialRendererSwift.swift
//  EmpowerAdapter
//
//  Created by Sena on 25.10.2023.
//

import Foundation
import GoogleMobileAds

class EmpowerInterstitialRendererSwift: NSObject, GADMediationInterstitialAd, GADFullScreenContentDelegate {
    
    private var empowerInterstitialAd: GAMInterstitialAd?
    
    var adLoadCallback: GADMediationInterstitialAdEventDelegate?
    
    var completionHandler: GADMediationInterstitialLoadCompletionHandler!
    var adConfiguration: GADMediationInterstitialAdConfiguration!
    
    private var codes: [String] = []
    private var waterfallIndex: Int = 0
    
    func loadInterstitial() {
        let adRequest = GAMRequest()
        
        var adJSON: [String: Any] = [:]
        
        DebugManager.printLog("Loading interstitial")
        
        if let receivedParameter = adConfiguration.credentials.settings["parameter"] as? String {
            adJSON = convertToDictionary(text: receivedParameter) ?? [:]
            
            
            let empowerAdModel = EmpowerAdModel(data: adJSON)
            
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
        }
        
        GAMInterstitialAd.load(withAdManagerAdUnitID: codes[waterfallIndex], request: adRequest, completionHandler: { [self] ad, error in
            if let error = error {
              
                
                if codes.count-1 > waterfallIndex {
                    DebugManager.printLog("Waterfall interstitial failed to load interstitial ad with error: \(error.localizedDescription)")
                    waterfallIndex += 1
                    
                    self.loadInterstitial()
                } else {
                    waterfallIndex = 0
                    
                    DebugManager.printLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
                }
                
                if let handler = completionHandler {
                    adLoadCallback = handler(self, error)
                }
                
              return
            }
            
            
            empowerInterstitialAd = ad
            
            empowerInterstitialAd?.fullScreenContentDelegate = self
            
            DebugManager.printLog("Interstitial loaded for: \(codes[waterfallIndex]) for index: \(waterfallIndex)")
            
            waterfallIndex = 0
            
            if let handler = completionHandler {
                adLoadCallback = handler(self, nil)
            }
            
          })
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if codes.count-1 > waterfallIndex {
            waterfallIndex += 1
            
            self.loadInterstitial()
            
        } else {
            waterfallIndex = 0
            
            DebugManager.printLog("Failed to load interstitial ad with error: \(error.localizedDescription)")
            
            if let handler = completionHandler {
                adLoadCallback = handler(self, error)
            }
        }
    }
    
    func present(from viewController: UIViewController) {
        if empowerInterstitialAd != nil {
            empowerInterstitialAd?.present(fromRootViewController: viewController)
        } else {
            DebugManager.printLog("Interstitial is not ready.")
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
