//
//  NetworkService.swift
//  YSMovie
//
//  Created by ystrack on 07/01/24.
//

import Foundation

protocol NetworkServiceProtocol {
    func sendRequest<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkService: NetworkServiceProtocol {
    /// Send a network request using Swift URLSession DataTask.
    /// - Parameters:
    ///   - endpoint: Endpoint to be called.
    ///   - completion: Async func called when network request finishes.
    public func sendRequest<T>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable {
        let request = self.createURLRequest(endpoint: endpoint)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data else {
                completion(.failure(.unknown))
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.unableToParse))
                return
            }
            
            completion(.success(decodedResponse))
        }.resume()
    }
    
    /// Create the URLRequest object using received Endpoint information.
    /// - Parameter endpoint: Endpoint data.
    /// - Returns: URLRequest.
    private func createURLRequest(endpoint: Endpoint) -> URLRequest {
        var url = endpoint.baseURL.appending(path: endpoint.path)
        var queryItems: [URLQueryItem] = []
        
        endpoint.parameters?.forEach({ key, value in
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        })
        url.append(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            let encodedBody = try? JSONEncoder().encode(body)
            request.httpBody = encodedBody
        }
        
        return request
    }
}
