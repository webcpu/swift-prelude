//
//  Result.swift
//  swift-prelude
//
//  Created by Liang on 28/10/2024.
//


extension Result {
//    public static func >>= <NewSuccess>(lhs: Result<Success, Failure>, rhs: @escaping (Success) async -> Result<NewSuccess, Failure>) async -> Result<NewSuccess, Failure> {
//        await lhs.flatMap(rhs)
//    }
    public func flatMap<NewSuccess>(_ transform: (Success) async -> Result<NewSuccess, Failure>) async -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let success):
            return await transform(success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
}
