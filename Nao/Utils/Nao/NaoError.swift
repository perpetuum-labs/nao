enum NaoError: Swift.Error {
    case notConnected
    case invalidStatusCode(Int, message: String)
    case decodingError(String)
}
