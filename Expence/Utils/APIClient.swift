//
//  APIClient.swift
//  Expence
//
//  Created by makinosp on 2025/03/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import MemberwiseInit

@MemberwiseInit
final actor APIClient {
    let baseUrl: String
}

extension APIClient {
    typealias HTTPResponse = (data: Data, response: HTTPURLResponse)

    enum ContentType: String {
        case json = "application/json"
    }

    enum Method: String, CustomStringConvertible {
        case get, post, patch, put, delete
        var description: String { rawValue.uppercased() }
    }
}

extension APIClient {
    /// Sends a request to the API.
    /// - Parameters:
    ///   - path: The path for the request.
    ///   - method: The HTTP method to use for the request.
    ///   - queryItems: An array of `URLQueryItem` to include in the request.
    ///   - body: The HTTP body to include in the request.
    /// - Returns: A tuple containing the data and the HTTP response.
    /// - Throws: `AppError` if an error occurs during the request.
    func request(
        path: String,
        method: Method,
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) async throws -> HTTPResponse {
        guard var urlComponents = URLComponents(string: "\(baseUrl)/\(path)") else {
            throw AppError.unknown("Invalid URL")
        }
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw AppError.unknown("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.description

        // Add HTTP body and content type if body is provided.
        if let body = body {
            request.addValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        return try await httpRequest(request)
    }
}

#if canImport(FoundationNetworking)
extension APIClient {
    private func httpRequest(_ request: URLRequest) async throws -> HTTPResponse {
        typealias Continuation = CheckedContinuation<HTTPResponse, Error>
        return try await withCheckedThrowingContinuation { (continuation: Continuation) in
            URLSession.shared.dataTask(with: request) { data, urlResponse, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let data = data, let reponse = urlResponse as? HTTPURLResponse else {
                    continuation.resume(throwing: VRCKitError.invalidResponse(String(describing: data)))
                    return
                }
                continuation.resume(returning: (data, reponse))
            }
            .resume()
        }
    }
}

#else
extension APIClient {
    private func httpRequest(_ request: URLRequest) async throws -> HTTPResponse {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw AppError.unknown(String(describing: data))
        }
        return (data, response)
    }
}
#endif
