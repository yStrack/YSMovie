//
//  DetailsTableViewCell.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import SwiftUI

struct DetailsTableViewCell: View {
    static let identifier: String = "DetailsTableViewCell"
    
    let title: String
    let overview: String
    
    init(title: String, overview: String) {
        self.title = title
        self.overview = overview
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.white)
            Text(overview)
                .font(.footnote)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.white)
        }
    }
}
