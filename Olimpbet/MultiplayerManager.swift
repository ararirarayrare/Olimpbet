//
//  MultiplayerManager.swift
//  Olimpbet
//
//  Created by mac on 07.11.2022.
//

import Foundation
import MultipeerConnectivity
import Combine

protocol MultiplayerGameDataDelegate: AnyObject {
    func didReceive(_ gameData: GameData)
}

class MultiplayerManager: NSObject, Coordinating {
    
    var coordinator: Coordinator?
    
    weak var delegate: MultiplayerGameDataDelegate?
    
    @Published
    private(set) var state: MCSessionState = .notConnected
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
        
    let id: MCPeerID
    
    private lazy var session: MCSession = {
        let session = MCSession(peer: id,
                                securityIdentity: nil,
                                encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    private lazy var advertiserAssistant = MCAdvertiserAssistant(serviceType: "ba-td",
                                                                 discoveryInfo: nil,
                                                                 session: session)
    
    private var browser: MCBrowserViewController?
        
    init(displayName: String, coordinator: Coordinator?) {
        self.id = MCPeerID(displayName: displayName)
        self.coordinator = coordinator
    }
    
    func startHosting() {
        advertiserAssistant.start()
    }
    
    func joinSession() {
        let browser = MCBrowserViewController(serviceType: "ba-td", session: session)
        browser.delegate = self
        browser.minimumNumberOfPeers = 2
        browser.maximumNumberOfPeers = 3
        self.browser = browser
        
        coordinator?.eventOccured(.mcBrowser(browser))
    }
     
    func send(_ gameData: GameData) {
        guard let data = try? JSONEncoder().encode(gameData) else {
            return
        }
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }

    func gameOver(playersScore: [String : Int]) {
        coordinator?.eventOccured(.gameOver(playersScore))
    }
    
    func stopAdvertising() {
        advertiserAssistant.stop()
    }
}

extension MultiplayerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        DispatchQueue.main.async { [weak self] in
            if let browser = self?.browser, state == .connected {
                self?.browserViewControllerDidFinish(browser)
            }
            
            self?.state = state
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameData = try? JSONDecoder().decode(GameData.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didReceive(gameData)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

extension MultiplayerManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
}


enum GameData: Codable {
    case score(Int, String)
}
