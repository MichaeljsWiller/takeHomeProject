//
//  SearchItem.swift
//  TakeHomeProject
//
//  Created by Michael Willer on 14/09/2021.
//

import Foundation

/// Represents a search and the gallery items which resulted from it 
final class SearchItem {
  /// The query that has been searched
  let searchTitle: String
  /// a list of photos recieved from the search
  let galleryPhotos: [GalleryPhoto]
  /// A list of videos recieved from the search
  let galleryVideos: [GalleryVideo]
  
  init(
    searchTitle: String,
    galleryPhotos: [GalleryPhoto],
    galleryVideos: [GalleryVideo]
  ) {
    self.searchTitle = searchTitle
    self.galleryPhotos = galleryPhotos
    self.galleryVideos = galleryVideos
  }
}


