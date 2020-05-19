//
//  URLSession+MarvelKit.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 15.05.16.
//  Copyright © 2016 cargath. All rights reserved.
//

import Combine
import Foundation

extension URLSession {

    func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Swift.Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(MarvelKit.Error(message: "No data received.", code: "-1")))
            }
        }
    }

}

public extension URLSession {

    func resourceTask<Resource>(with request: Request<Resource>, completion completionHandler: @escaping (Result<DataWrapper<DataContainer<Resource>>, Swift.Error>) -> Void) -> URLSessionTask {
        if let url = request.url {
            return dataTask(with: url) { result in
                completionHandler(result.resource())
            }
        } else {
            return dataTask(with: URL(fileURLWithPath: "")) { _, _, _ in
                completionHandler(.failure(MarvelKit.Error(message: "Failed to create URL for resource.", code: "-1")))
            }
        }
    }

}

public extension URLSession {

    // Keep the legacy method signature as a wrapper around the new Result type.
    func resourceTask<Resource>(with request: Request<Resource>, success successHandler: @escaping (DataWrapper<DataContainer<Resource>>) -> Void, error errorHandler: @escaping (Swift.Error) -> Void) -> URLSessionTask {
        return resourceTask(with: request, completion: { result in
            switch result {
                case .success(let response):
                    successHandler(response)
                case .failure(let error):
                    errorHandler(error)
            }
        })
    }

    // Same as above, but with flipped success and failure handlers, because it allows for nicer error chaining.
    func resourceTask<Resource>(with request: Request<Resource>, error errorHandler: @escaping (Swift.Error) -> Void, success successHandler: @escaping (DataWrapper<DataContainer<Resource>>) -> Void) -> URLSessionTask {
        return resourceTask(with: request, success: successHandler, error: errorHandler)
    }
    
}

@available(iOS 13.0, *)
public extension URLSession {

    func resourceTaskPublisher<Resource>(with request: Request<Resource>) -> AnyPublisher<DataWrapper<DataContainer<Resource>>, Swift.Error> {
        if let url = request.url {
            return dataTaskPublisher(for: url)
                .map { $0.data }
                .tryMap { try JSONDecoder().resource(from: $0) }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: MarvelKit.Error(message: "Failed to create URL for resource.", code: "-1"))
                .eraseToAnyPublisher()
        }
    }

}
