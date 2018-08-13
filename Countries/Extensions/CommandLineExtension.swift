extension CommandLine {
    /// Command and optional associated value which collectively make up a command line option. i.e. `$ swift build --build-path ./.build` where `--build-path` is the command and `./.build` is the associated value.
    struct Option {
        let commandArgument: String
        let valueArgument: String?
    }
    
    /// Returns Option for passed in command argument if present in CommandLine.arguments.
    static func option(for commandArgument: String) -> Option? {
        guard let commandIndex = CommandLine.arguments.index(of: commandArgument) else {
            return nil
        }
        let valueArgument = CommandLine.arguments.element(after: commandIndex)
        return Option(commandArgument: commandArgument, valueArgument: valueArgument)
    }
}

/// Array extension functions used to simplify CommandLine extension above.
private extension Array where Element: Hashable {
    func element(after index: Index) -> Element? {
        let nextIndex = self.index(after: index)
        return self.element(at: nextIndex)
    }
    
    private func element(at index: Index) -> Element? {
        guard index >= self.startIndex else { return nil }
        guard index < self.endIndex else { return nil }
        return self[index]
    }
}

