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
    let releaseYear: String
    let runtime: String?
    
    init(title: String, overview: String, releaseYear: String, runtime: String?) {
        self.title = title
        self.overview = overview
        self.releaseYear = releaseYear
        self.runtime = runtime
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.white)
            
            
            HStack(spacing: 4) {
                Text(releaseYear)
                
                if let runtime {
                    Text(runtime)
                }
                
            }
            .font(.footnote)
            .foregroundStyle(Color.white)
            
            Text(overview)
                .font(.footnote)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .foregroundStyle(Color.white)
        }
    }
}
