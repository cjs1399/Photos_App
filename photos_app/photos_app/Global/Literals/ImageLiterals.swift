//
//  ImageLiterals.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//


import UIKit

enum ImageLiterals {
    
    enum EditView {
        static var add_photo_ic: UIImage { .load(name: "add_photo_ic").withRenderingMode(.alwaysOriginal)}
        static var back_ic: UIImage { .load(name: "back_ic").withRenderingMode(.alwaysOriginal)}
        static var back_dark_ic: UIImage { .load(name: "back_dark_ic").withRenderingMode(.alwaysOriginal)}
        static var edit_ic: UIImage { .load(name: "edit_ic").withRenderingMode(.alwaysOriginal)}
        static var share_ic: UIImage { .load(name: "share_ic").withRenderingMode(.alwaysOriginal)}
        static var share_dark_ic: UIImage { .load(name: "share_dark_ic").withRenderingMode(.alwaysOriginal)}
        static var grid_ic_3: UIImage { .load(name: "3x3_grid_ic").withRenderingMode(.alwaysOriginal)}
        static var grid_ic_2: UIImage { .load(name: "2x2_grid_ic").withRenderingMode(.alwaysOriginal)}
    }
    
    enum BottomMenu {
        static var effect_ic: UIImage { .load(name: "effect_ic").withRenderingMode(.alwaysOriginal)}
        static var film_ic: UIImage { .load(name: "film_ic").withRenderingMode(.alwaysOriginal)}
        static var filter_ic: UIImage { .load(name: "filter_ic").withRenderingMode(.alwaysOriginal)}
        static var heart_ic: UIImage { .load(name: "heart_ic").withRenderingMode(.alwaysOriginal)}
        static var plastic_surgery_ic: UIImage { .load(name: "plastic_surgery_ic").withRenderingMode(.alwaysOriginal)}
        static var shopping_ic: UIImage { .load(name: "shopping_ic").withRenderingMode(.alwaysOriginal)}
        static var square_ic: UIImage { .load(name: "square_ic").withRenderingMode(.alwaysOriginal)}
        static var text_ic: UIImage { .load(name: "text_ic").withRenderingMode(.alwaysOriginal)}
        static var texture_ic: UIImage { .load(name: "texture_ic").withRenderingMode(.alwaysOriginal)}
    }
    
    enum editModeMenu {
        static var check_ic: UIImage { .load(name: "check_ic").withRenderingMode(.alwaysOriginal)}
        static var close_ic: UIImage { .load(name: "close_ic").withRenderingMode(.alwaysOriginal)}
        static var revert_ic: UIImage { .load(name: "revert_ic").withRenderingMode(.alwaysOriginal)}

    }
}

