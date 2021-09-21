//
//  ViewController.swift
//  agora-ios-quickstart
//
//  Created by Max Cobb on 13/09/2021.
//

import UIKit
import AgoraRtcKit

class ViewController: UIViewController {

    var localView: UIView!
    var remoteView: UIView!

    // Add this linke to add the agoraKit variable
    var agoraKit: AgoraRtcEngineKit?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initializeAndJoinChannel()
     }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remoteView.frame = self.view.bounds
        localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 90, height: 160)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        agoraKit?.leaveChannel(nil)
        agoraKit?.stopPreview()
        AgoraRtcEngineKit.destroy()
    }

    func initView() {
        remoteView = UIView()
        self.view.addSubview(remoteView)
        localView = UIView()
        self.view.addSubview(localView)
    }

    func initializeAndJoinChannel() {
      // Pass in your App ID here
        agoraKit = AgoraRtcEngineKit.sharedEngine(
            withAppId: <#Agora App ID#>, delegate: self
        )
        // Video is disabled by default. You need to call enableVideo to start a video stream.
        agoraKit?.enableVideo()
        // Create a videoCanvas to render the local video
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        agoraKit?.setupLocalVideo(videoCanvas)

        // Join the channel with a token. Pass in your token and channel name here
        agoraKit?.joinChannel(
            byToken: <#Agora Temporary Token#>, channelId: "test",
            info: nil, uid: 0
        ) { (_, uid, _) in
            print("new uid is: \(uid)")
        }
    }
}

extension ViewController: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(
        _ engine: AgoraRtcEngineKit,
        didJoinedOfUid uid: UInt,
        elapsed: Int
    ) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
