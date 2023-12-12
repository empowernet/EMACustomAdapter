//
//  EmpowerMediationAdapter.swift
//  EmpowerAdapter
//
//  Created by Sena on 18.10.2023.
//

import Foundation
import GoogleMobileAds

@objc class EmpowerMediationAdapterSwift: NSObject, GADMediationAdapter {
    
    fileprivate var bannerAd: EmpowerBannerRendererSwift?  = nil
    
    required override init() {
       super.init()
        
        print("EmpowerMediationAdapterSwift init")
     }
    
    
    static func setUpWith(
        _ configuration: GADMediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
      ) {
        // This is where you will initialize the SDK that this custom event is built
        // for. Upon finishing the SDK initialization, call the completion handler
        // with success.
          
          DebugManager.printLog("Initialize Empower Custom Mediation Adapter")
        
          

        completionHandler(nil)
      }
    
    static func adapterVersion() -> GADVersionNumber {
        return GADVersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 0)
    }
    
    static func adSDKVersion() -> GADVersionNumber {
        return GADVersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 0)
    }
    
    static func networkExtrasClass() -> GADAdNetworkExtras.Type? {
        return nil
    }
    
    func loadBanner(for adConfiguration: GADMediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        
        bannerAd = EmpowerBannerRendererSwift()
        bannerAd!.adConfiguration = adConfiguration
        bannerAd!.completionHandler = completionHandler
        
        bannerAd!.loadBanner()
    }
    
    func loadInterstitial(for adConfiguration: GADMediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        
        let empowerInterstitialRenderer = EmpowerInterstitialRendererSwift()
        empowerInterstitialRenderer.adConfiguration = adConfiguration
        empowerInterstitialRenderer.completionHandler = completionHandler
        
        empowerInterstitialRenderer.loadInterstitial()
        
    }
    
    func loadRewardedAd(for adConfiguration: GADMediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        
        let empowerRewardedRenderer = EmpowerRewardedRendererSwift()
        empowerRewardedRenderer.adConfiguration = adConfiguration
        empowerRewardedRenderer.completionHandler = completionHandler
        
        empowerRewardedRenderer.loadRewarded()
    }
    
    

}
