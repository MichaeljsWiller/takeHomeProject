//
//  SelectedVideoView.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 15/09/2021.
//

import AVKit

/// A view displaying a video for playback
final class SelectedVideoView: UIViewController {
  
  // MARK: - Properties
  
  /// The view model backing this view
  var viewModel: SelectedGalleryItemViewModel?
  
  private var videoPlayer: AVPlayer!
  private var videoPlayerController: AVPlayerViewController!
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    layoutViews()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    videoPlayer.play()
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    guard let viewModel = viewModel else { return }
    videoPlayer = AVPlayer(url: viewModel.galleryItemURL)
    videoPlayerController = AVPlayerViewController()
    videoPlayerController.player = videoPlayer
    view.addSubview(videoPlayerController.view)
    addChild(videoPlayerController)
  }
  
  private func layoutViews() {
    videoPlayerController.view.anchor(
      top: view.topAnchor,
      bottom: view.bottomAnchor,
      leading: view.leadingAnchor,
      trailing: view.trailingAnchor
    )
  }
}
