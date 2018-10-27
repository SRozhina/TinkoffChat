//
//  MultipeerConnectionService.swift
//  TinkoffChat
//
//  Created by Sofia on 24/10/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicationService: NSObject, ICommunicationService {
    weak var delegate: ICommunicationServiceDelegate?
    var online: Bool = false {
        didSet {
            if online {
                startServices()
            } else {
                stopServices()
            }
        }
    }
    
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let discoveryInfo = ["userName": "Sonechka"]
    private var advertiser: MCNearbyServiceAdvertiser
    private var browser: MCNearbyServiceBrowser
    private var session: MCSession
    private let serviceType = "tinkoff-chat"

    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .optional)
        super.init()
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
    }
    
    func send(_ message: Message, to peer: Peer) {
        guard let messageData = getDataFrom(message) else { return }
        if let toPeer = session.connectedPeers.first(where: { $0.displayName == peer.name }) {
            try? session.send(messageData, toPeers: [toPeer], with: .reliable)
        }
    }
    
    private func startServices() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    private func stopServices() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    private func getDataFrom(_ message: Message) -> Data? {
        let data = try? JSONEncoder().encode(message)
        return data
    }
    
    private func getMessageFrom(_ data: Data) -> Message? {
        let message = try? JSONDecoder().decode(Message.self, from: data)
        return message
    }
}

extension MultipeerCommunicationService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("I'm going to accept invite from \(peerID.displayName)")
        let peer = Peer(name: peerID.displayName)
        delegate?.communicationService(self, didReceiveInviteFromPeer: peer) { accept in
            invitationHandler(accept, session)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.delegate?.communicationService(self, didNotStartAdvertisingForPeers: error)
        }
    }
}

extension MultipeerCommunicationService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?) {
        print("I'm going to send invite to \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("\(peerID.displayName) was lost")
        let peer = Peer(name: peerID.displayName)
        DispatchQueue.main.async {
            self.delegate?.communicationService(self, didLostPeer: peer)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.delegate?.communicationService(self, didNotStartBrowsingForPeers: error)
        }
    }
}

extension MultipeerCommunicationService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let baseString = "Change state with \(peerID.displayName) to"
        switch state {
        case .connected:
            print("\(baseString) connected")
            let peer = Peer(name: peerID.displayName)
            DispatchQueue.main.async {
                self.delegate?.communicationService(self, didFoundPeer: peer)
            }
        case .connecting:
            print("\(baseString) connecting")
        case .notConnected:
            print("\(baseString) not connected")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = getMessageFrom(data) else { return }
        print("Received message \(message.text) from \(peerID.displayName)")
        let peer = Peer(name: peerID.displayName)
        DispatchQueue.main.async {
            self.delegate?.communicationService(self, didReceiveMessage: message, from: peer)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Received stream \(streamName) from \(peerID.displayName)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Will receive resource \(resourceName) from \(peerID.displayName)")
    }

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        print("Received resource \(resourceName) from \(peerID.displayName)")

    }
}
