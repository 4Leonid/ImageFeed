//
//  URLSession+Extention.swift
//  ImageFeed
//
//  Created by Леонид Турко on 29.03.2023.
//

import Foundation

enum NetworkError: Error {
  case decodingError(Error)
  case httpStatusCode(Int) 
  case urlRequestError(Error)
  case urlSessionError
  case invalidRequest
}

extension URLSession {
  
  func objectTask<T: Decodable>(
    for request: URLRequest,
    completion: @escaping (Result<T, Error>) -> Void
  ) -> URLSessionTask {
    let fulfillCompletion: (Result<T, Error>) -> Void =
    { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error  in
      if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if 200 ..< 300 ~= statusCode {
          do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            fulfillCompletion(.success(result))
          } catch {
            fulfillCompletion(.failure(error))
          }
        } else {
          fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
        }
      } else if let error = error {
        fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
      } else {
        fulfillCompletion(.failure(NetworkError.urlSessionError))
      }
    }
    task.resume()
    return task
  }
  
  func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
    let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    
    let task = dataTask(with: request) { data, response, error in
      if let data = data,
         let response = response,
         let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if 200 ..< 300 ~= statusCode {
          fulfillCompletion(.success(data))
        } else {
          fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
        }
      } else if let error = error {
        fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
      } else {
        fulfillCompletion(.failure(NetworkError.urlSessionError))
      }
    }
    task.resume()
    return task
  }
}
