// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "c282a3a6489d8633a9b090e2b1473186"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Project.self)
  }
}