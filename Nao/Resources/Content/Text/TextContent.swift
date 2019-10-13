enum TextContent {
    enum Error {
        enum Validation {
            static let ipFormat = "Invalid IP address format"
            static let portFormat = "Invalid PORT format"
            static let unknown = "Unknown"
        }
    }
    
    enum Intro {
        static let title = "How it works"
        
        enum Slide {
            enum One {
                static let title = "Hello!"
                static let description = "This is an app that allows you control NAO robot.\n\nTap next to find out how to set it all up!"
                static let buttonTitle = "Next"
            }
            
            enum Two {
                static let title = "Set it up!"
                static let description = "Use the code snippet and put it inside Python box in your Choreographe project."
                static let link = "Tap here to get the script"
                static let buttonTitle = "Done"
            }
            
            enum Three {
                static let title = "Almost there!"
                static let description = "Make sure your phone is connected to the same Wi-Fi network that your NAO robot operates in. \n\nUse your robot IP address to connect to it."
                static let buttonTitle = "Let's go!"
            }
        }
    }
    
    enum SetUp {
        enum Error {
            static let title = "Error"
            static let button = "Ok"
        }
        
        static let buttonTitle = "Connect"
        static let ipAddressPlaceholder = "IP address of your Nao"
        static let portNumberPlaceholder = "Port number of your Nao"
    }
}
