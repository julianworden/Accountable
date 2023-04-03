// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var username: String
  public var externalProvider: ExternalProvider?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      externalProvider: ExternalProvider? = nil) {
    self.init(id: id,
      username: username,
      externalProvider: externalProvider,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      username: String,
      externalProvider: ExternalProvider? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.externalProvider = externalProvider
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}