protocol NaoResponse: Decodable { }

extension Nao {
    enum Response {
        struct Simple: NaoResponse {
            let code: Int
        }
    }
}
