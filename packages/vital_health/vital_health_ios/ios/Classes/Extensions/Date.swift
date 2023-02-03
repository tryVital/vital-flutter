import Foundation

extension Date {
  internal init(epochMillis: Int) {
    self.init(timeIntervalSince1970: Double(epochMillis) / 1000)
  }
}
