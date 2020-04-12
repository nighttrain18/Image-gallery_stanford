//
//  ImageGallery.swift
//  Image-gallery_stanford
//
//  Created by Олег Черных on 22/03/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation

protocol GalleryPresenterObserver: class {
    func notify(with: [GalleryPresenter.Event])
}

class GalleryPresenter {
    enum Event {
        case galleryFetched
        case imageAdded(byIndex: Int)
        case imagesDeleted(byIndices: [Int])
        case imageMoved(firstIndex: Int, secondIndex: Int)
        case galleryNameUpdated
    }
    
    private unowned var storage = AppContext.galleryStorage
    var galleryId: Int!
    private(set) var gallery: Gallery!
    private var observers = [GalleryPresenterObserver]()
    
    func subscribe(_ observer: GalleryPresenterObserver) {
        if observers.firstIndex(where: { $0 === observer }) == nil {
            observers.append(observer)
        }
    }
    
    func unsubscribe(_ observer: GalleryPresenterObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }
    
    func notifyAll(with events: [Event]) {
        observers.forEach { $0.notify(with: events) }
    }
    
    func fetchGallery() {
        storage.getGallery(byId: galleryId) { gallery in
            if let gallery = gallery {
                self.gallery = gallery
                notifyAll(with: [.galleryFetched])
            }
        }
    }
}