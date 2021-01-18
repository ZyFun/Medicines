//
//  test.swift
//  Medicines
//
//  Created by Дмитрий Данилин on 18.01.2021.
//
// TODO: Это временный файл с примерами того, как можно писать документацию

import Foundation

/// 🚲 A two-wheeled, human-powered mode of transportation.
class Bicycle {
    /**
        Frame and construction style.

        - Road: For streets or trails.
        - Touring: For long journeys.
        - Cruiser: For casual trips around town.
        - Hybrid: For general-purpose transportation.
    */
    public enum Style {
        case Road, Touring, Cruiser, Hybrid
    }

    /**
        Mechanism for converting pedal power into motion.

        - Fixed: A single, fixed gear.
        - Freewheel: A variable-speed, disengageable gear.
    */
    public enum Gearing {
        case Fixed
        case Freewheel(speeds: Int)
    }

    /**
        Hardware used for steering.

        - Riser: A casual handlebar.
        - Café: An upright handlebar.
        - Drop: A classic handlebar.
        - Bullhorn: A powerful handlebar.
    */
    enum Handlebar {
        case Riser, Café, Drop, Bullhorn
    }

    /// The style of the bicycle.
    let style: Style

    /// The gearing of the bicycle.
    let gearing: Gearing

    /// The handlebar of the bicycle.
    let handlebar: Handlebar

    /// The size of the frame, in centimeters.
    let frameSize: Int

    /// The number of trips travelled by the bicycle.
    private(set) var numberOfTrips: Int

    /// The total distance travelled by the bicycle, in meters.
    private(set) var distanceTravelled: Double

    /**
        Initializes a new bicycle with the provided parts and specifications.

        :param: style The style of the bicycle
        :param: gearing The gearing of the bicycle
        :param: handlebar The handlebar of the bicycle
        :param: centimeters The frame size of the bicycle, in centimeters

        :returns: A beautiful, brand-new, custom built just for you.
    */
    init(style: Style, gearing: Gearing, handlebar: Handlebar, frameSize centimeters: Int) {
        self.style = style
        self.gearing = gearing
        self.handlebar = handlebar
        self.frameSize = centimeters

        self.numberOfTrips = 0
        self.distanceTravelled = 0.0
    }

    /**
        Take a bike out for a spin.

        :param: meters The distance to travel in meters.
    */
    func travel(distance meters: Double) {
        if meters > 0.0 {
            self.distanceTravelled += meters
            self.numberOfTrips += 1
        }
    }
}

/**
 The `Utility` class provides various useful functions and values.
*/
class Utility {
    /**
     Fixes the string representation of number.
     
     ```
     1.0 -> 1 (not 1.0)
     0.00003 -> 0.00003 (not 3e-05)
     ```
     
     ```
     тут будет наглядный пример как это работает
     ```

     
     - parameters:
        - doubleValue: The number to be represented as the string.
     
     - returns: The string representation of number.
    */
    class func doubleToString(doubleValue: Double) -> String {
        var stringValue: String
        
        if trunc(doubleValue) == doubleValue {
            stringValue = "\(Int(doubleValue))"
        } else if abs(doubleValue) < 0.0001 {
            stringValue = "" // \(doubleValue + (doubleValue.sign ? -1 : 1))"
            stringValue = "" //(stringValue.stringByReplacingOccurrencesOfString(";1.", withString: "0."))"
        } else {
            stringValue = "\(doubleValue)"
        }
        
        return stringValue
    }
}
