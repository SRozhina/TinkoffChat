//
//  PixabayAvatarNetworkService.swift
//  TinkoffChat
//
//  Created by Sofia on 22/11/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class PixabayAvatarNetworkService: IAvatarNetworkService {
    let baseURL = "https://pixabay.com/api/"
    let apiKey = "10769642-77b83f11e474afa137e87ba7a"
    private let session: URLSession
    weak var delegate: AvatarNetworkServiceDelegate?
    private var imageURL: URL?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getImagesURLs(completion: @escaping ([URL]) -> Void) {
        guard let url = makeURLWith(imageKind: "kitten") else { return }
        let request = URLRequest(url: url)
        
        getDataFromRequest(request) { data in
            guard let result = try? JSONDecoder().decode(PixabayResult.self, from: data) else {
                self.delegate?.showError(with: "Could not parse data")
                return
            }
            let imageURLs = result.hits.compactMap { URL(string: $0.webformatURL) }
            
            DispatchQueue.main.async {
                completion(imageURLs)
            }
        }
    }
    
    func getImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        imageURL = url
        let request = URLRequest(url: url)
        
        getDataFromRequest(request) { data in
            guard let image = UIImage(data: data) else {
                self.delegate?.showError(with: "Could not make image from data")
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func makeURLWith(imageKind: String) -> URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        let keyQueryItems = URLQueryItem(name: "key", value: apiKey)
        let descriptionQueryItem = URLQueryItem(name: "q", value: imageKind)
        let prettyQueryItem = URLQueryItem(name: "pretty", value: "true")
        let batchSizeQueryItem = URLQueryItem(name: "per_page", value: "200")
        components.queryItems = [keyQueryItems, descriptionQueryItem, prettyQueryItem, batchSizeQueryItem]
        return components.url
    }
    
    private func getDataFromRequest(_ request: URLRequest, completion: @escaping (Data) -> Void) {
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                self.delegate?.showError(with: error.localizedDescription)
                return
            }
            guard let data = data else {
                self.delegate?.showError(with: "No data with current request")
                return
            }
            completion(data)
        }
        task.resume()
    }
}
