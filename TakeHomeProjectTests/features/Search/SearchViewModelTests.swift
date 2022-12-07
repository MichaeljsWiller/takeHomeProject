//
//  SearchViewModelTests.swift
//  TakeHomeProjectTests
//
//  Created by Michael Willer on 05/12/2022.
//

import Foundation
import Combine
import XCTest
@testable import TakeHomeProject

final class SearchViewModelTests: XCTestCase {
  private var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    cancellables = .init()
  }
  
  override func tearDown() {
    cancellables.removeAll()
    super.tearDown()
  }
}

// MARK: - Start Search

extension SearchViewModelTests {
  
  func test_GivenStartSearch_WhenCalledWithEmptyQuery_ThenCoordinatorIsNotCalled() throws {
    // Given
    let (sut, coordinator) = makeSUT()
    let stubCoordinator = try XCTUnwrap(coordinator as? StubCoordinator)
    sut.currentQuery = ""
    
    // When
    sut.startSearch()
    
    // Then
    XCTAssertEqual(stubCoordinator.navigateToGalleryCallCount, 0)
  }
  
  func test_GivenStartSearch_WhenCalledWithExistingRecentSearch_ThenCoordinatorIsCalled() throws {
    // Given
    let (sut, coordinator) = makeSUT()
    let stubCoordinator = try XCTUnwrap(coordinator as? StubCoordinator)
    let recentSearch = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.currentQuery = recentSearch.searchTitle
    sut.recentSearches.append(recentSearch)
    
    // When
    sut.startSearch()
    
    // Then
    XCTAssertEqual(stubCoordinator.navigateToGalleryCallCount, 1)
  }
  
  func test_GivenStartSearch_WhenCalledWithNewSearch_ThenNetworkCallIsMade_AndQueryAddedToRecentSearches() throws {
    // Given
    let apiManager = StubPixabayAPIMAnager()
    let (sut, coordinator) = makeSUT(apiManager: apiManager)
    let stubCoordinator = try XCTUnwrap(coordinator as? StubCoordinator)
    let recentSearch = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    let newSearchQuery = "MockQuery"
    sut.currentQuery = newSearchQuery
    sut.recentSearches.append(recentSearch)
    apiManager.simulatedPhotoResult = .success(GetPhotosResponse(hits: []))
    apiManager.simulatedVideoResult = .success(GetVideoResponse(hits: []))
    
    // When
    sut.startSearch()
    let expectation = expectation(description: "API call made")
    
    sut.$recentSearches
      .sink { _ in
        expectation.fulfill()
      }
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 3)
    
    // Then
    XCTAssertEqual(sut.recentSearches[1].searchTitle, newSearchQuery)
    XCTAssertEqual(stubCoordinator.navigateToGalleryCallCount, 1)
    XCTAssertEqual(stubCoordinator.navigateToGallerySearchItem?.searchTitle, newSearchQuery)
  }
}

// MARK: - Filter Search

extension SearchViewModelTests {
  
  func test_GivenFilterSearch_WhenCalled_ThenPreviousFilteredSearchesAreCleared() {
    // Given
    let sut = makeSUT().0
    sut.filteredSearches = [.init(searchTitle: "MockSearch", galleryPhotos: [], galleryVideos: [])]
    
    // When
    sut.filterSearch()
    
    // Then
    XCTAssertTrue(sut.filteredSearches.isEmpty)
  }
  
  func test_GivenFilterSearch_WhenCalledWithCurrentQueryContainingLetterFromRecentSearch_ThenRecentSearchIsAppendedToFilteredSearch() {
    // Given
    let sut = makeSUT().0
    let recentSearch = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.recentSearches.append(recentSearch)
    
    // When
    sut.currentQuery = "mo"
    sut.filterSearch()
    
    // Then
    XCTAssertEqual(sut.filteredSearches[0].searchTitle, recentSearch.searchTitle)
  }
  
  func test_GivenFilterSearch_WhenCalledWithCurrentQueryNotContainingLetterFromRecentSearch_ThenFilteredSearchIsEmpty() {
    // Given
    let sut = makeSUT().0
    let recentSearch = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.recentSearches.append(recentSearch)
    
    // When
    sut.currentQuery = "se"
    sut.filterSearch()
    
    // Then
    XCTAssertTrue(sut.filteredSearches.isEmpty)
  }
  
  func test_GivenFilterSearch_WhenCurrentQueryIsEmpty_ThenFilteredSearchIsEmpty() {
    // Given
    let sut = makeSUT().0
    let recentSearch = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.recentSearches.append(recentSearch)
    
    // When
    sut.currentQuery = "mo"
    sut.currentQuery = ""
    sut.filterSearch()
    
    // Then
    XCTAssertTrue(sut.filteredSearches.isEmpty)
  }
}

// MARK: - Navigate To Gallery

extension SearchViewModelTests {
  
  func test_GivenNavigateToGallery_WhenCalled_ThenCurrentQueryIsCleared() {
    // Given
    let sut = makeSUT().0
    sut.currentQuery = "mockQuery"
    
    // When
    sut.navigateToGallery(with: SearchItem(searchTitle: "", galleryPhotos: [], galleryVideos: []))
    
    // Then
    XCTAssertTrue(sut.currentQuery.isEmpty)
  }
  
  func test_GivenNavigateToGallery_WhenCalled_ThenFilteredSearchesIsCleared() {
    // Given
    let sut = makeSUT().0
    let searchItem = SearchItem(searchTitle: "", galleryPhotos: [], galleryVideos: [])
    sut.filteredSearches.append(searchItem)
    
    // When
    sut.navigateToGallery(with: searchItem)
    
    // Then
    XCTAssertTrue(sut.filteredSearches.isEmpty)
  }

  func test_GivenNavigateToGallery_WhenCalled_ThenCoordinatorIsCalled() throws {
    // Given
    let (sut, coordinator) = makeSUT()
    let stubCoordinator = try XCTUnwrap(coordinator as? StubCoordinator)
    let searchItem = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.filteredSearches.append(searchItem)
    
    // When
    sut.navigateToGallery(with: searchItem)
    
    // Then
    XCTAssertEqual(stubCoordinator.navigateToGalleryCallCount, 1)
  }
  
  func test_GivenNavigateToGallery_WhenCalled_ThenCoordinatorIsCalledWithCorrectMedia() throws {
    // Given
    let (sut, coordinator) = makeSUT()
    let stubCoordinator = try XCTUnwrap(coordinator as? StubCoordinator)
    let searchItem = SearchItem(searchTitle: "mockSearch", galleryPhotos: [], galleryVideos: [])
    sut.filteredSearches.append(searchItem)
    
    // When
    sut.navigateToGallery(with: searchItem)
    
    // Then
    XCTAssertEqual(stubCoordinator.navigateToGallerySearchItem?.searchTitle, searchItem.searchTitle)
  }
}

// MARK: - Make SUT

private extension SearchViewModelTests {
  func makeSUT(
    apiManager: APIManager = StubPixabayAPIMAnager(),
    coordinator: Coordinator = StubCoordinator()
  ) -> (SearchViewModel, Coordinator) {
    let sut = SearchViewModel(
      apiManager: apiManager,
      coordinator: coordinator
      )
    return (sut, coordinator)
  }
}
