//
//  ErrorModel.swift
//  Expence
//
//  Created by makinosp on 2025/03/23.
//

struct Error: Codable, Sendable {
    let message: String
    let exception: String
}
