//
//  SearchViewModel.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 13/09/2021.
//

import UIKit
import Combine

/// Methods for managing changes within a search query item
protocol SearchQueryDelegate: AnyObject {
  /// Notifies listeners that the contents of the search queries have changed
  func listHasChanged()
  /// Notifies listeners to clear any text within a texfield
  func clearTextField()
  /// Notifies listeners that a search has began
  func searchHasBegan()
}

/// ViewModel backing the search view
final class SearchViewModel {

  // MARK: - Properties
  
  weak var delegate: SearchQueryDelegate?
  /// Handles navigation between views
  weak var coordinator: Coordinator?
  /// The current query entered in the searchField
  var currentQuery: String = ""
  /// A list of recent searches filtered by characters a user has inputted
  var filteredSearches = [SearchItem]()
  /// A list of recent searches
  @Published var recentSearches = [SearchItem]()
  /// Whether any recent searches have been mace
  @Published var recentSearchesIsEmpty: Bool = true
  
  private let apiManager: APIManager
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Initialiser
  
  init(
    apiManager: APIManager = APIManagerImpl(),
    coordinator: Coordinator? = nil
  ) {
    self.apiManager = apiManager
    self.coordinator = coordinator
    subscribeToRecentSearches()
  }
  
  // MARK: - Internal Methods
  
  /// Begins a search for media using the search query entered
  @objc func startSearch() {
    guard !currentQuery.isEmpty else { return }
    
    if let recentSearch = recentSearches.first(
      where: { $0.searchTitle.lowercased() == currentQuery.lowercased().trimmingCharacters(in: .whitespaces) }
    ) {
      navigateToGallery(with: recentSearch)
    } else {
      getGalleryPhotos()
    }
    delegate?.searchHasBegan()
  }
  
  /// Filters out recent searches that contain the characters inputted by the user
  func filterSearch() {
    filteredSearches.removeAll()
    for search in recentSearches {
      if search.searchTitle.lowercased().starts(with: currentQuery.lowercased()) {
        filteredSearches.append(search)
      }
    }
    if currentQuery.isEmpty {
      filteredSearches.removeAll()
    }
    delegate?.listHasChanged()
  }
  
  /// Navigates to the gallery view
  func navigateToGallery(with media: SearchItem) {
    self.delegate?.clearTextField()
    self.currentQuery = ""
    filteredSearches.removeAll()
    coordinator?.navigateToGallery(with: media)
  }
  
  private func getGalleryPhotos() {
    let photoAPI: AnyPublisher<GetPhotosResponse, Error>? = apiManager.retrieveSearchResults(
      from: PixabayEndpoint.searchPhotos,
      using: currentQuery
    )
    
    let videoAPI: AnyPublisher<GetVideoResponse, Error>? = apiManager.retrieveSearchResults(
      from: PixabayEndpoint.searchVideos,
      using: currentQuery
    )
    
    if let photoAPICall = photoAPI,
       let videoAPICall = videoAPI {
      photoAPICall.combineLatest(videoAPICall)
        .map { ($0.hits, $1.hits) }
        .sink { completion in
          switch completion {
          case .finished:
            print("successfully recieved gallery data back from the api")
          case .failure(let error):
            print(error)
          }
        } receiveValue: { [weak self] (photos, videos) in
          self?.handleApiResponses(for: photos, videoResponse: videos)
        }
        .store(in: &cancellables)
    }
  }
  
  // MARK: - Private Methods
  
  private func handleApiResponses(for photoResponse: [PhotoHit], videoResponse: [VideoHit]) {
        let photoList = photoResponse.map {
          GalleryPhoto(
            id: $0.id,
            thumbnailImage: $0.previewURL,
            image: $0.largeImageURL
          )
        }
        let videoList = videoResponse.map {
          GalleryVideo(
            id: $0.id,
            thumbnailImage: $0.pictureId,
            smallVideoURL: URL(string: $0.videos.small.url),
            mediumVideoURL: URL(string: $0.videos.medium.url),
            largeVideoURL: URL(string: $0.videos.large.url),
            duration: $0.duration
          )
        }
        let newSearch = SearchItem(
          searchTitle: self.currentQuery.trimmingCharacters(in: .whitespaces),
          galleryPhotos: photoList,
          galleryVideos: videoList
        )
        self.recentSearches.append(newSearch)
        self.navigateToGallery(with: newSearch)
  }
  
  private func subscribeToRecentSearches() {
    $recentSearches
      .map { $0.isEmpty }
      .assign(to: &$recentSearchesIsEmpty)
  }
}
