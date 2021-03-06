//
//  ICommunicationServiceDelegate.swift
//  TinkoffChat
//
//  Created by Sofia on 27/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation

protocol ICommunicationServiceDelegate: class {
    /// Browsing
    func communicationService(_ communicationService: ICommunicationService,
                              didFoundPeer peer: UserInfo)
    
    func communicationService(_ communicationService: ICommunicationService,
                              didLostPeer peer: UserInfo)
    
    func communicationService(_ communicationService: ICommunicationService,
                              didNotStartBrowsingForPeers error: Error)
    
    /// Advertising
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveInviteFromPeer peer: UserInfo,
                              invintationClosure: (Bool) -> Void)
    
    func communicationService(_ communicationService: ICommunicationService,
                              didNotStartAdvertisingForPeers error: Error)
    
    /// Messages
    func communicationService(_ communicationService: ICommunicationService,
                              didReceiveMessage message: Message,
                              from peer: UserInfo)
}
