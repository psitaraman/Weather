//
//  ImageDataSource.swift
//  Weather
//
//  Created by Praveen Sitaraman on 5/15/17.
//  Copyright © 2017 Praveen Sitaraman. All rights reserved.
//

import UIKit

final class ImageDataSource {
    
    // Properties
    
    let imageCache = NSCache<NSIndexPath, UIImage>()
    
    init() {
        
    }
    
    // MARK: - Public
    
    func imageWith(url: URL, for indexPath: IndexPath, completion: @escaping (UIImage, IndexPath) -> ()) {
        
        //first check cache if image is there
        guard let image = self.imageCache.object(forKey: self.transform(indexPath: indexPath)) else {
            // retrieve image from network if not in cache
            self.downloadImage(url: url, for: indexPath, completion: completion)
            return
        }
        
        Thread.executeOnMainThread {
            completion(image, indexPath)
        }
    }
    
    func prefetchImageWith(url: URL, for indexPath: IndexPath) {
        guard self.imageCache.object(forKey: self.transform(indexPath: indexPath)) == nil else { return }
        self.downloadImage(url: url, for: indexPath, completion: nil)
    }
    
    func clearCache() {
        self.imageCache.removeAllObjects()
    }
    
    // MARK: - Private

    private func transform(indexPath: IndexPath) -> NSIndexPath {
        return NSIndexPath(row: indexPath.row, section: indexPath.section)
    }
    
    private func transform(nsindexPath: NSIndexPath) -> IndexPath {
        return IndexPath(row: nsindexPath.row, section: nsindexPath.section)
    }
    
    private func downloadImage(url: URL, for indexPath: IndexPath, completion: ((UIImage, IndexPath) -> ())?) {
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let imageData = data  else { return }
            Thread.executeOnMainThread {
                guard let image = UIImage(data: imageData) else { return }
                // store image in cache then return it back in completion block
                self.imageCache.setObject(image, forKey: self.transform(indexPath: indexPath))
                
                completion?(image, indexPath)
            }
        }
        task.resume()
    }
}
