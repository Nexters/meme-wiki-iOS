//
//  CustomColor.swift
//  Meme
//
//  Created by 임현규 on 7/28/25.
//

import UIKit

enum CustomColor {
    case black(Black)
    case gray(Gray)
    case blue(Blue)
    case green(Green)
    case lightBlue(LightBlue)
    case lime(Lime)
    case pink(Pink)
    case purple(Purple)
    case red(Red)
    case redOrange(RedOrange)
    case violet(Violet)
    case yellow(Yellow)
    
    fileprivate var base: CustomColorConvertible {
        switch self {
        case .black(let black): return black
        case .gray(let gray): return gray
        case .blue(let blue): return blue
        case .green(let green): return green
        case .lightBlue(let leightBlue): return leightBlue
        case .lime(let lime): return lime
        case .pink(let pink): return pink
        case .purple(let purple): return purple
        case .red(let red): return red
        case .redOrange(let redOrange): return redOrange
        case .violet(let violet): return violet
        case .yellow(let yellow): return yellow
        }
    }
    
    var color: UIColor? {
        return base.color
    }
}

// MARK: - Colors

enum Black: String, CustomColorConvertible {
    case black
    
    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Gray: String, CustomColorConvertible {
    case gray10
    case gray9
    case gray8
    case gray7
    case gray6
    case gray5
    case gray4
    case gray3
    case gray2
    case gray1
    
    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Blue: String, CustomColorConvertible {
    case blue99
    case blue90
    case blue80
    case blue70
    case blue60
    case blue50
    case blue40
    case blue30
    
    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Green: String, CustomColorConvertible {
    case green99
    case green90
    case green80
    case green70
    case green60
    case green50
    case green40
    case green30
    
    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum LightBlue: String, CustomColorConvertible {
    case lightBlue99
    case lightBlue90
    case lightBlue80
    case lightBlue70
    case lightBlue60
    case lightBlue50
    case lightBlue40
    case lightBlue30
    
    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Lime: String, CustomColorConvertible {
    case lime99
    case lime90
    case lime80
    case lime70
    case lime60
    case lime50
    case lime40
    case lime30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Pink: String, CustomColorConvertible {
    case pink99
    case pink90
    case pink80
    case pink70
    case pink60
    case pink50
    case pink40
    case pink30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Purple: String, CustomColorConvertible {
    case purple99
    case purple90
    case purple80
    case purple70
    case purple60
    case purple50
    case purple40
    case purple30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Red: String, CustomColorConvertible {
    case red99
    case red90
    case red80
    case red70
    case red60
    case red50
    case red40
    case red30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum RedOrange: String, CustomColorConvertible {
    case redOrange99
    case redOrange90
    case redOrange80
    case redOrange70
    case redOrange60
    case redOrange50
    case redOrange40
    case redOrange30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Violet: String, CustomColorConvertible {
    case violet99
    case violet90
    case violet80
    case violet70
    case violet60
    case violet50
    case violet40
    case violet30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}

enum Yellow: String, CustomColorConvertible {
    case yellow99, yellow90, yellow80, yellow70, yellow60, yellow50, yellow40, yellow30

    var color: UIColor? {
        return UIColor(named: self.rawValue)
    }
}
