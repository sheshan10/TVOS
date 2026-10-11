import Foundation

enum TopicID: String, Codable, CaseIterable, Identifiable, Hashable {
    case animals
    case fruits
    case vehicles

    var id: String { rawValue }

    var title: String {
        switch self {
        case .animals: "Animals"
        case .fruits: "Fruits"
        case .vehicles: "Vehicles"
        }
    }

    var summary: String {
        switch self {
        case .animals: "Meet five friendly animals."
        case .fruits: "Name five colourful fruits."
        case .vehicles: "Spot five ways to travel."
        }
    }

    var sampleImageName: String {
        switch self {
        case .animals: IllustrationAsset.animalCat.rawValue
        case .fruits: IllustrationAsset.fruitApple.rawValue
        case .vehicles: IllustrationAsset.vehicleCar.rawValue
        }
    }
}

enum IllustrationAsset: String, CaseIterable {
    case animalCat = "animal_cat"
    case animalDog = "animal_dog"
    case animalElephant = "animal_elephant"
    case animalRabbit = "animal_rabbit"
    case animalFish = "animal_fish"
    case fruitApple = "fruit_apple"
    case fruitBanana = "fruit_banana"
    case fruitOrange = "fruit_orange"
    case fruitGrapes = "fruit_grapes"
    case fruitWatermelon = "fruit_watermelon"
    case vehicleCar = "vehicle_car"
    case vehicleBus = "vehicle_bus"
    case vehicleTrain = "vehicle_train"
    case vehicleBoat = "vehicle_boat"
    case vehicleAirplane = "vehicle_airplane"

    static var names: Set<String> {
        Set(allCases.map(\.rawValue))
    }
}
