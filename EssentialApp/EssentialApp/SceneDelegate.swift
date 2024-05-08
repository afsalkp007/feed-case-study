//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Afsal on 26/04/2024.
//

import Combine
import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  private var remoteURL: URL { URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")! }
  
  private lazy var httpClient: HTTPClient = {
    URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
  }()

  private lazy var store: FeedStore & FeedImageDataStore = {
    try! CoreDataFeedStore(
      storeURL: NSPersistentContainer
      .defaultDirectoryURL()
      .appendingPathComponent("feed-store.sqlite"))
  }()
    
  private lazy var localFeedLoader: LocalFeedLoader = {
    LocalFeedLoader(store: store, currentDate: Date.init)
  }()

  convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
    self.init()
    self.httpClient = httpClient
    self.store = store
  }

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    configureWindow()
  }
   
  func configureWindow() {
    window?.rootViewController = UINavigationController(
      rootViewController: FeedUIComposer.feedComposedWith(
      feedLoader: makeRemoteFeedLaoderWithLocalFallback,
      imageLoader: makeLocalImageLoaderWithRemoteFallback))
    
    window?.makeKeyAndVisible()
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    localFeedLoader.validateCache { _ in }
  }
  
  private func makeRemoteFeedLaoderWithLocalFallback() -> AnyPublisher<[FeedImage], Error> {
    return httpClient
      .getPublisher(url: remoteURL)
      .tryMap(FeedItemsMapper.map)
      .caching(to: localFeedLoader)
      .fallback(to: localFeedLoader.loadPublisher)
  }
  
  private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
    let localImageLoader = LocalFeedImageDataLoader(store: store)
    
    return localImageLoader
      .loadImageDataPublisher(from: url)
      .fallback(to: { [httpClient] in
        httpClient
          .getPublisher(url: url)
          .tryMap(FeedImageDataMapper.map)
          .caching(to: localImageLoader, using: url)
      })
  }
}
