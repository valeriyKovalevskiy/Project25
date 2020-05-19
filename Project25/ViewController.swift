//
//  ViewController.swift
//  Project25
//
//  Created by Valeriy Kovalevskiy on 5/18/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController {
    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie share"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    func startHosting(action: UIAlertAction) {
        guard let session = mcSession else { return }
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "project25", discoveryInfo: nil, session: session)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let session = mcSession else { return }
        
        let mcBrowser = MCBrowserViewController(serviceType: "project25", session: session)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let session = mcSession else { return }
        
        if session.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                }
                catch {
                    let ac = UIAlertController(title: "send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ok", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected: \(peerID.displayName)")
            
        case .connecting:
            print("connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("notConnected: \(peerID.displayName)")
            
        @unknown default:
            print("unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
}
