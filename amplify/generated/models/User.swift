// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var username: String
  public var externalProvider: ExternalProvider?
  public var projects: List<Project>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      externalProvider: ExternalProvider? = nil,
      projects: List<Project>? = []) {
    self.init(id: id,
      username: username,
      externalProvider: externalProvider,
      projects: projects,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      username: String,
      externalProvider: ExternalProvider? = nil,
      projects: List<Project>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.externalProvider = externalProvider
      self.projects = projects
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
