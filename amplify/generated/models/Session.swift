// swiftlint:disable all
import Amplify
import Foundation

public struct Session: Model {
  public let id: String
  public var project: Project?
  public var durationInSeconds: Int
  public var unixDate: Double
  public var weekday: Weekday
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      project: Project? = nil,
      durationInSeconds: Int,
      unixDate: Double,
      weekday: Weekday) {
    self.init(id: id,
      project: project,
      durationInSeconds: durationInSeconds,
      unixDate: unixDate,
      weekday: weekday,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      project: Project? = nil,
      durationInSeconds: Int,
      unixDate: Double,
      weekday: Weekday,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.project = project
      self.durationInSeconds = durationInSeconds
      self.unixDate = unixDate
      self.weekday = weekday
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}