// swiftlint:disable all
import Amplify
import Foundation

public struct Project: Model {
  public let id: String
  public var creator: User?
  public var name: String
  public var priority: Priority
  public var description: String?
  public var sessions: List<Session>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      creator: User? = nil,
      name: String,
      priority: Priority,
      description: String? = nil,
      sessions: List<Session>? = []) {
    self.init(id: id,
      creator: creator,
      name: name,
      priority: priority,
      description: description,
      sessions: sessions,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      creator: User? = nil,
      name: String,
      priority: Priority,
      description: String? = nil,
      sessions: List<Session>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.creator = creator
      self.name = name
      self.priority = priority
      self.description = description
      self.sessions = sessions
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}