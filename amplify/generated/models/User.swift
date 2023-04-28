// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var username: String
  public var isPremium: Bool
  public var projects: List<Project>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      isPremium: Bool,
      projects: List<Project>? = []) {
    self.init(id: id,
      username: username,
      isPremium: isPremium,
      projects: projects,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      username: String,
      isPremium: Bool,
      projects: List<Project>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.isPremium = isPremium
      self.projects = projects
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}