//
//  URLSession+MarvelKit.swift
//  MarvelKit
//
//  Created by Carsten Könemann on 15.05.16.
//  Copyright © 2016 cargath. All rights reserved.
//

import Combine
import Foundation

public extension URLSession {

    func resourceTask<Resource>(with request: Request<Resource>, completion completionHandler: @escaping (Result<DataWrapper<DataContainer<Resource>>, Swift.Error>) -> Void) -> URLSessionTask {

        guard let url = request.url else {
            return dataTask(with: URL(fileURLWithPath: "")) { _, _, _ in
                completionHandler(.failure(MarvelKit.Error(message: "Failed to create URL for resource", code: "-1")))
            }
        }

        return dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(error ?? MarvelKit.Error(message: "Unknown", code: "-1")))
                return
            }
            do {
                completionHandler(.success(try JSONDecoder().resource(from: data)))
            } catch {
                completionHandler(.failure(error))
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

        guard let url = request.url else {
            return Publishers
                .Fail(error: MarvelKit.Error(message: "Failed to create URL for resource", code: "-1"))
                .eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { try JSONDecoder().resource(from: $0) }
            .eraseToAnyPublisher()
    }

}
