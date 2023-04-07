// swiftlint:disable all
import Amplify
import Foundation

public struct Session: Model {
  public let id: String
  public var project: Project
  public var durationInSeconds: Int
  public var unixDate: Double
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      project: Project,
      durationInSeconds: Int,
      unixDate: Double) {
    self.init(id: id,
      project: project,
      durationInSeconds: durationInSeconds,
      unixDate: unixDate,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      project: Project,
      durationInSeconds: Int,
      unixDate: Double,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.project = project
      self.durationInSeconds = durationInSeconds
      self.unixDate = unixDate
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}