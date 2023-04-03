// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3d1edcf6facace38c14ce6826915891e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Project.self)
  }
}