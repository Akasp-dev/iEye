import Foundation

class Init{
    static let keyes = ["coinChaseTimeLeft", "coinChaseTimeDecrease", "shapesAvailableShapes", "shapesVelocity", "shapesSize"]
    static let defaultValues = [20, 0.1, 2, 10 ,100]
    static func initiateDefaultValues(){
        for x in keyes{
            if UserDefaults.standard.integer(forKey: x) == 0{
                UserDefaults.standard.set(defaultValues[keyes.firstIndex(of: x)!], forKey: x)	
            }
        }
    }
}
