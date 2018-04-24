//
//  RNZendesk.swift
//  RNZendesk
//
//  Created by David Chavez on 24.04.18.
//  Copyright © 2018 David Chavez. All rights reserved.
//

import UIKit
import Foundation
import ZendeskSDK
import ZendeskCoreSDK

@objc(RNZendesk)
class RNZendesk: RCTEventEmitter {

    override open static func requiresMainQueueSetup() -> Bool {
        return false;
    }
    
    @objc(constantsToExport)
    override func constantsToExport() -> [AnyHashable: Any] {
        return [:]
    }
    
    @objc(supportedEvents)
    override func supportedEvents() -> [String] {
        return []
    }
    
    
    // MARK: - Public API

    @objc(initialize:)
    func initialize(config: [String: Any]) {
        guard
            let appId = config["appId"] as? String,
            let clientId = config["clientId"] as? String,
            let zendeskUrl = config["zendeskUrl"] as? String else { return }
        
        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Support.initialize(withZendesk: Zendesk.instance)
    }
    
    @objc(identifyJWT:)
    func identifyJWT(token: String) {
        let identity = Identity.createJwt(token: token)
        
        Zendesk.initialize(appId: appId, clientId: clientId, zendeskUrl: zendeskUrl)
        Zendesk.instance?.setIdentity(identity)
    }
    
    @objc(showHelpCenter:)
    func showHelpCenter(with options: [String: Any]) {
        DispatchQueue.main.async {
            let hcConfig = HelpCenterUiConfiguration()
            hcConfig.hideContactSupport = (options["hideContactSupport"] as? Bool) ?? false
            let helpCenter = HelpCenterUi.buildHelpCenterOverview(withConfigs: [hcConfig])
            UIApplication.shared.keyWindow.window?.rootViewController?.navigationController?.pushViewController(helpCenter, animated: true)
        }
    }
}
