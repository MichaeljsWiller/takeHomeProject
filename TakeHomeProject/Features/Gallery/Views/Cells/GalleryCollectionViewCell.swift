//
//  GalleryCollectionViewCell.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import UIKit
import Combine

/// Custom collection view cell for displaying gallery items
final class GalleryCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  /// The reusable identifier for the cell
  static let identifier = "PhotoGalleryCell"
  
  private var waterMarkImageView: UIImageView!
  private var videoDurationLabel: UILabel!
  private var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    return imageView
  }()
  private var cancellable = Set<AnyCancellable>()
  
  // MARK: - Initialiser
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - View Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.anchor(
      top: contentView.topAnchor,
      bottom: contentView.bottomAnchor,
      leading: contentView.leadingAnchor,
      trailing: contentView.trailingAnchor
    )
    waterMarkImageView.anchor(
      top: imageView.topAnchor,
      paddingTop: 10,
      leading: imageView.leadingAnchor,
      paddingLeft: 10,
      width: 20,
      height: 20)
    
    videoDurationLabel.anchor(
      bottom: imageView.bottomAnchor,
      paddingBottom: 10,
      trailing: imageView.trailingAnchor,
      paddingRight: 10)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  // MARK: - Setup
  
  private func setupViews() {
    waterMarkImageView = UIImageView()
    waterMarkImageView.alpha = 0.7
    waterMarkImageView.tintColor = .white
    imageView.addSubview(waterMarkImageView)
    
    videoDurationLabel = UILabel()
    videoDurationLabel.textColor = .white
    videoDurationLabel.alpha = 0.7
    videoDurationLabel.font = .systemFont(ofSize: 15)
    imageView.addSubview(videoDurationLabel)
  }
  
  // MARK: - Internal Methods
  
  /// Populates the cell with content
  /// - Parameters:
  ///   - imageURL: The url for the image to appear in the cell
  ///   - duration: The duration of the video the cell represents 
  func populateCell(with imageURL: URL, duration: String? = nil) {
    CacheManager.shared.downloadImage(from: imageURL)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        
        case .finished:
          print("success")
        case .failure(let error):
          print(error)
        }
      }, receiveValue:  { [weak self] image in
        self?.imageView.image = image
      })
      .store(in: &cancellable)
    if let duration = duration {
      videoDurationLabel.text = duration
      waterMarkImageView.image = UIImage(systemName: "video")
    }
  }
}
