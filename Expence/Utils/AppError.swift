//
//  AppError.swift
//  Expence
//
//  Created by makinosp on 2025/03/23.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case unknown(String)

    public var errorDescription: String? {
        switch self {
        case .unknown: "Unknown Error"
        }
    }

    /// Provides a localized failure reason for the error.
    public var failureReason: String? {
        switch self {
        case .unknown(let message): message
        }
    }
}
