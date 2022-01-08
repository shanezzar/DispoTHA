//
//  NetworkModel.swift
//  DispoTHA
//
//  Created by Shanezzar Sharon on 08/01/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class NetworkModel: ObservableObject {
    
    // MARK:- variables
    static var shared = NetworkModel()
    
    @Published var gifs: [GIF] = [GIF]()
    @Published var isLoading: Bool = false
    @Published var error: String = ""
    
    private var offset = 0
    
    // MARK:- functions
    func loadMore(search: String) {
        guard !isLoading else { return }
        isLoading = true
        
        let url = search.isEmpty ? (Constants.trendingURL + "&offset=\(offset)") : (Constants.searchURL + "&offset=\(offset)&q=\(search.urlEncoded!)")
        
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                self.isLoading = false
                self.error = ""
                self.offset += 16
                
                guard let responseData = data else { return }
                guard let json = try? JSON(data: responseData) else { return }
                guard let dataArray = json["data"].array else { return }
                
                self.gifs = self.gifs + dataArray.map({ gif -> GIF in
                    let id = gif["id"].string ?? ""
                    let tld = gif["source_tld"].string ?? ""
                    let title = gif["title"].string ?? ""
                    let username = gif["username"].string ?? ""
                    let rating = gif["rating"].string ?? ""
                    let url = gif["images"].dictionary.map { images -> String in
                        let imageDict = images["downsized"]?.dictionary
                        return imageDict?["url"]?.string ?? ""
                    } ?? ""
                    
                    return GIF(id: id, tld: tld, title: title, username: username, rating: rating, url: url)
                })
                break
            case .failure(let error):
                self.isLoading = false
                self.gifs.removeAll()
                self.error = error.localizedDescription
                break
            }
        }
    }
    
    func refresh(search: String) {
        gifs.removeAll()
        isLoading = false
        offset = 0
        loadMore(search: search)
    }
    
    func fetchGIF(_ id: String, completion: @escaping (_ gif: GIF?, _ error: Error?) -> Void) {
        let url = Constants.baseURL + id + "?api_key=\(Constants.apiKey)"
        
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let responseData = data else { return }
                guard let json = try? JSON(data: responseData) else { return }
                guard let gif = json["data"].dictionary else { return }
                
                let id = gif["id"]?.string ?? ""
                let tld = gif["source_tld"]?.string ?? ""
                let title = gif["title"]?.string ?? ""
                let username = gif["username"]?.string ?? ""
                let rating = gif["rating"]?.string ?? ""
                let url = gif["images"]?.dictionary.map { images -> String in
                    let imageDict = images["downsized"]?.dictionary
                    return imageDict?["url"]?.string ?? ""
                } ?? ""

                completion(GIF(id: id, tld: tld, title: title, username: username, rating: rating, url: url), nil)
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }

}
