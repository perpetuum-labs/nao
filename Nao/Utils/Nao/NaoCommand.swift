import UIKit

protocol NaoCommand: URLRequestConvertible {
    var name: String { get }
    var color: UIColor { get }
}

extension NaoCommand {
    var color: UIColor {
        return .purple
    }
}

protocol NaoPostureCommand: NaoCommand {
    var speed: Float { get }
}

extension NaoPostureCommand {
    var speed: Float { return 1.0 }
}

protocol NaoSpeechCommand: NaoCommand {
    var text: String { get }
}

protocol NaoMoveCommand: NaoCommand {
    var xValue: Float { get }
    var yValue: Float { get }
    var tValue: Float { get }
}

extension NaoMoveCommand {
    var pathComponents: [String: String] { return ["moveTo": "true", "x": xValue.description, "y": yValue.description, "t": tValue.description] }
}

//[ "moveTo": "true", "x": x.description, "y": y.description, "t": theta.description ]

extension Nao {
    enum Command {
        struct ValidateConnection: NaoCommand {
            var name: String { return "" }
        }
        
        struct GoLeft: NaoMoveCommand {
            var xValue: Float = 0.0
            var yValue: Float = 0.1
            var tValue: Float = 0.0
            var name: String { return "Go left" }
        }
        
        struct GoForward: NaoMoveCommand {
            var xValue: Float = 0.1
            var yValue: Float = 0.0
            var tValue: Float = 0.0
            var name: String { return "Go forward" }
        }
        
        struct GoBackward: NaoMoveCommand {
            var xValue: Float = -0.1
            var yValue: Float = 0.0
            var tValue: Float = 0.0
            var name: String { return "Go back" }
        }
        
        struct GoRight: NaoMoveCommand {
            var xValue: Float = 0.0
            var yValue: Float = -0.1
            var tValue: Float = 0.0
            var name: String { return "Go right" }
        }
        
        struct Say: NaoSpeechCommand {
            var name: String { return "Say ..." }
            var text: String
            var pathComponents: [String: String] { return ["text": text] }

            init(text: String) {
                self.text = text
            }
        }
        
        struct StandPosture: NaoPostureCommand {
            var name: String { return "Stand" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.mayaBlue
            }
        }
        
        struct StandInitPosture: NaoPostureCommand {
            var name: String { return "Stand Init" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.mayaBlue
            }
        }
        
        struct StandZeroPosture: NaoPostureCommand {
            var name: String { return "Stand Zero" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.mayaBlue
            }
        }
        
        struct CrouchPosture: NaoPostureCommand {
            var name: String { return "Crouch" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.radicalRed
            }
        }
        
        struct SitPosture: NaoPostureCommand {
            var name: String { return "Sit" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.emerald
            }
        }
        
        struct SitRelaxPosture: NaoPostureCommand {
            var name: String { return "Sit Relax" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.emerald
            }
        }
        
        struct LyingBellyPosture: NaoPostureCommand {
            var name: String { return "Lying Belly" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.sunglow
            }

        }
        
        struct LyingBackPosture: NaoPostureCommand {
            var name: String { return "Lying Back" }
            var pathComponents: [String: String] { return ["posture": name, "speed": String(speed)] }

            var color: UIColor {
                return Pallete.sunglow
            }
        }
        
        static var speech: [NaoCommand] {
            return [Say(text: "Hello")]
        }
        
        static var walk: [NaoCommand] {
            return [GoLeft(),
                    GoRight(),
                    GoForward(),
                    GoBackward()]
        }
        
        static var posture: [NaoCommand] {
            return [StandPosture(),
                    StandInitPosture(),
                    StandZeroPosture(),
                    CrouchPosture(),
                    SitPosture(),
                    SitRelaxPosture(),
                    LyingBellyPosture(),
                    LyingBackPosture()]
        }
    }
}
