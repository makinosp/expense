//
//  AboutModel.swift
//  Expence
//
//  Created by makinosp on 2025/03/23.
//

import Foundation

struct AboutModel: Codable, Sendable {
    let version: String
    let apiVersion: String
    let phpVersion: String
    let os: String
    let driver: String
}

struct AboutUser: Codable, Sendable {
    let type: String
    let id: String
    let attributes: UserAttributes

    struct UserAttributes: Codable, Sendable {
        let createdAt: Date
        let updatedAt: Date
        let email: String
        let blocked: Bool
        let blockedCode: String
        let role: String
    }
}
