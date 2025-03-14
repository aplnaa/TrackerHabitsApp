enum RepositoryError: Error {
    case habitNotFound
    case networkError
    case serverError
    
    var errorDescription: String {
        switch self {
        case .habitNotFound:
            return "Привычка не найдена"
        case .networkError:
            return "Ошибка сети"
        case .serverError:
            return "Ошибка сервера"
        }
    }
}
