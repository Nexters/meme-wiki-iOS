//
//  RandomColor.swift
//  Meme
//
//  Created by 임현규 on 7/31/25.
//

import UIKit

enum RandomColor: CaseIterable {
    // TODO: - add yellow color
    case purple, pink, violet, lightBlue, green, red
    
    var labelColor: UIColor? {
        switch self {
        case .purple: return CustomColor.purple(.purple90).color
        case .pink: return CustomColor.pink(.pink90).color
        case .violet: return CustomColor.violet(.violet90).color
        case .lightBlue: return CustomColor.lightBlue(.lightBlue90).color
        case .green: return CustomColor.green(.green90).color
        case .red: return CustomColor.red(.red90).color
        }
    }
    
    var gradientColor: UIColor? {
        switch self {
        case .purple: return CustomColor.purple(.purple30).color
        case .pink: return CustomColor.pink(.pink40).color
        case .violet: return CustomColor.violet(.violet30).color
        case .lightBlue: return CustomColor.lightBlue(.lightBlue30).color
        case .green: return CustomColor.green(.green60).color
        case .red: return CustomColor.red(.red50).color
        }
    }
}
