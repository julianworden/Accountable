// swiftlint:disable all
import Amplify
import Foundation

extension Session {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case project
    case durationInSeconds
    case unixDate
    case weekday
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let session = Session.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Sessions"
    
    model.attributes(
      .primaryKey(fields: [session.id])
    )
    
    model.fields(
      .field(session.id, is: .required, ofType: .string),
      .belongsTo(session.project, is: .optional, ofType: Project.self, targetNames: ["projectSessionsId"]),
      .field(session.durationInSeconds, is: .required, ofType: .int),
      .field(session.unixDate, is: .required, ofType: .double),
      .field(session.weekday, is: .required, ofType: .enum(type: Weekday.self)),
      .field(session.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(session.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Session: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}