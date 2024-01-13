//
//  InfosCell.swift
//  YSMovie
//
//  Created by ystrack on 09/01/24.
//

import SwiftUI

struct InfosCell: View {
    static let identifier: String = "DetailsTableViewCell"
    
    let title: String
    let overview: String
    let certification: String?
    let releaseYear: String
    let runtime: String?
    
    @State private var lineLimit: Int? = 3
    
    init(title: String, overview: String, certification: String?, releaseYear: String, runtime: String?) {
        self.title = title
        self.overview = overview
        self.certification = certification
        self.releaseYear = releaseYear
        self.runtime = runtime
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.white)
                
                
                HStack(spacing: 4) {
                    Text(releaseYear)
                    
                    if let certification {
                        AgeRatingView(certification: certification)
                    }
                    
                    if let runtime {
                        Text(runtime)
                    }
                    
                }
                .font(.footnote)
                .foregroundStyle(Color.white)
                
                seeMoreButton
                    .padding(.bottom, 8)
                
                Text(overview)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .lineLimit(lineLimit)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
        }
    }
    
    var seeMoreButton: some View {
        Button("Details", action: {})
            .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: Scale ButtonStyle
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.medium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundStyle(Color.black)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear(duration: 0.2), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.1 : 0)
    }
}

// MARK: Brazil Age Rating colors
struct AgeRatingView: View {
    
    let certification: String
    
    var body: some View {
        Text(certification)
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(getBackgroundColor() == Color.eighteenYears ? Color.white : Color.black)
            .padding(.horizontal, getBackgroundColor() == Color.free ? 6 : 4)
            .padding(.vertical, 2)
            .background(getBackgroundColor())
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func getBackgroundColor() -> Color {
        switch certification {
        case "L":
            Color.free
        case "10":
            Color.tenYears
        case "12":
            Color.twelveYears
        case "14":
            Color.fourteenYears
        case "16":
            Color.sixteenYears
        case "18":
            Color.eighteenYears
        default:
            Color.unknownAge
        }
    }
}
