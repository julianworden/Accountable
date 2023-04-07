// swiftlint:disable all
import Amplify
import Foundation

extension Project {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case creator
    case name
    case priority
    case description
    case sessions
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let project = Project.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Projects"
    
    model.attributes(
      .primaryKey(fields: [project.id])
    )
    
    model.fields(
      .field(project.id, is: .required, ofType: .string),
      .belongsTo(project.creator, is: .optional, ofType: User.self, targetNames: ["userProjectsId"]),
      .field(project.name, is: .required, ofType: .string),
      .field(project.priority, is: .required, ofType: .enum(type: Priority.self)),
      .field(project.description, is: .optional, ofType: .string),
      .hasMany(project.sessions, is: .optional, ofType: Session.self, associatedWith: Session.keys.project),
      .field(project.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(project.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Project: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}