//
//  CacheManagerTests.swift
//  TakeHomeProjectTests
//
//  Created by Michael Willer on 15/09/2021.
//

import Foundation
import Combine
import XCTest
@testable import TakeHomeProject

final class CacheManagerTests: XCTestCase {
  
  var mockSession: StubURLSession!
  var cacheManager: CacheManager!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    mockSession = StubURLSession()
    cacheManager = CacheManager(session: mockSession)
    cancellables = Set<AnyCancellable>()
  }
  
  override func tearDown() {
    mockSession = nil
    cacheManager = nil
    cancellables = nil
  }
  
  func testManagerCachesAnImageWhenItHasNotYetBeenCached() {
    // Expect cache to not have image associated with the url stored
    let url = URL(string: "https://mockurl.org")!
    XCTAssertNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
    
    // When retrieving an image for the first time
    let expectation = self.expectation(description: "caching")
    cacheManager.downloadImage(from: url)
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    // Expect for the image to be cached with the given url as its key
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(mockSession.returnedCachedImage, false)
    XCTAssertNotNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
  }
  
  func testManagerReturnsCachedImageWhenGivenTheKeyForStoredImage() {
    // Add an Image along with a key to the cache
    let url = URL(string: "https://mockurl.org")!
    guard let image = UIImage(systemName: "video") else {
      XCTFail("Invalid image given")
      return
    }
    let cache = cacheManager.imageCache
    cache.setObject(image, forKey: url.absoluteString as NSString)
    
    // Expect for the image to be cached
    XCTAssertNotNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
    
    // When retrieving an image from the manager
    let expectation = self.expectation(description: "retrieving from cache")
    cacheManager.downloadImage(from: url)
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    // Expect for the image to be retrieved from cache
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(mockSession.returnedCachedImage, true)
  }
  
  func testCachedObjectReturnedFromManagerMatchesObjectCached() {
    // Add an Image along with a key to the cache
    let url = URL(string: "https://mockurl.org")!
    guard let image = UIImage(systemName: "video") else {
      XCTFail("Invalid image given")
      return
    }
    let cache = cacheManager.imageCache
    cache.setObject(image, forKey: url.absoluteString as NSString)
    
    // Expect for the image to be cached
    XCTAssertNotNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
    
    // When retrieving an image from the manager
    let expectation = self.expectation(description: "retrieving from cache")
    var cachedImageReturned: UIImage?
    cacheManager.downloadImage(from: url)
      .sink(receiveCompletion: { _ in
        expectation.fulfill()
      }, receiveValue: { returnedImage in
        cachedImageReturned = returnedImage
      })
      .store(in: &cancellables)
    
    // Expect for the image to be retrieved from cache
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(mockSession.returnedCachedImage, true)
    
    // And expect the image to match the original imaged cached
    XCTAssertEqual(image, cachedImageReturned)
  }
  
  func testCacheIsClearedWhenMemoryWarningIsRecieved() {
    // Add multiple objects to be cached
    let urlArray = Array(0...999).map( { URL(string: String($0))! })
    let image = UIImage()
    let cache = cacheManager.imageCache
    for url in urlArray {
      cache.setObject(image, forKey: url.absoluteString as NSString)
      
      // Expect all the objects to be cached
      XCTAssertNotNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
    }
    
    // When a memory warning is recieved
    let expectation = self.expectation(description: "posting notification")
    let notification = NotificationCenter.default
    NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
      .receive(on: DispatchQueue.main)
      .sink { _ in
        expectation.fulfill()
      }
      .store(in: &cancellables)
    notification.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    
    // Expect the cache to be cleared
    waitForExpectations(timeout: 5, handler: nil)
    for url in urlArray {
      XCTAssertNil(cacheManager.imageCache.object(forKey: url.absoluteString as NSString))
    }
  }
}
