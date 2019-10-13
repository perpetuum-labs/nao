struct Validator<T> {
    let closure: (T) throws -> Void
}

struct ValidationError: Swift.Error {
    let message: String
    var errorDescription: String? { return message }
    static var unknown = { return ValidationError(message: TextContent.Error.Validation.unknown) } ()
}

func validate(_ condition: @autoclosure () -> Bool, errorMessage messageExpression: @autoclosure () -> String) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}

func validate<T>(_ value: T, using validator: Validator<T>) throws {
    try validator.closure(value)
}

extension Validator where T == String {
    static var ipAddress: Validator {
        return Validator { string in
            try validate(string.isValidIP(), errorMessage: TextContent.Error.Validation.ipFormat)
        }
    }
    
    static var portNumber: Validator {
        return Validator { string in
            try validate(UInt16(string) != nil, errorMessage: TextContent.Error.Validation.portFormat)
        }
    }
}
