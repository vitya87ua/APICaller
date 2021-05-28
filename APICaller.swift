//
//  APICaller.swift
//  Networking GET POST JSON
//
//  Created by Віктор Бережницький on 28.05.2021.
//

import UIKit

class APICallers {
    static let shared = APICallers()
    private init() {}
    
    private let url = URL(string: "https://...")!
    private let token = "S3JNZ1kaG9HQ3h2NHYK..."
    private let HTTPHeader = "X-API-Token"
    
    
    public func makeRequest(url: URL?, token: String, HTTPHeader: String) -> URLRequest? {
        
        if let url = url {
            var request = URLRequest(url: url)
            request.addValue(token, forHTTPHeaderField: HTTPHeader)
            return request
        }
        
        return nil
    }
    
    
    // Main Function
    public func getJSON<T: Decodable>(urlRequest: URLRequest, type: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                guard let jsonData = data else { return }
                
                do {
                    let json = try JSONDecoder().decode([T].self, from: jsonData)
                    completion(.success(json))
                    
                } catch {
                    completion(.failure(error))
                }
                
            } else {
                completion(.failure(error!))
            }
        }.resume()
    }
    
    
    public func getAllElementsSimple(urlRequest: URLRequest) {
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let jsonData = data, error == nil else { return }
            
            do {
                let stations = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                print(stations)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil, data != nil {
                
                guard let image = UIImage(data: data!) else {
                    completionHandler(UIImage(named: "Standart Image")!)
                    return
                }
                completionHandler(image)
                
            } else {
                completionHandler(UIImage(named: "Standart Image")!)
            }
        }.resume()
    }
    
}
