enum Result<Error: Swift.Error>: Equatable {
    case success
    case failure(Error)
    
    static func == (lhs: Result<Error>, rhs: Result<Error>) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case let (.failure(lhsError), .failure(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
