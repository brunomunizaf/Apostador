import Foundation

public final class Environment {
  public enum EnvironmentVariables: String {
    case apiBaseURL = "API_BASE_URL"
  }

  public static func variable(_ key: EnvironmentVariables) -> String {
    Bundle.main.infoDictionary![key.rawValue] as! String
  }
}
