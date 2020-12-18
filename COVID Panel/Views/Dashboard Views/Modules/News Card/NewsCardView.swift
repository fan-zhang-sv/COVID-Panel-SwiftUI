//
//  NewsCardView.swift
//  Solid News
//
//  Created by Fan Zhang on 7/13/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI
//import URLImage

struct NewsCardView: View {
    
    @AppStorage("defaultLang") var defaultLang: String?
    
    var news: NewsModel = NewsModel.defaultNews()
    var mkt: String = "en-US"
    var localeIdentifier: String {
        defaultLang!.replacingOccurrences(of: "-", with: "_")
    }
    var relativeTime: String {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.locale = Locale(identifier: localeIdentifier)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let safeTime = dateFormatter.date(from: news.datePublished!) {
            //            print(safeTime)
            return relativeDateTimeFormatter.localizedString(for: safeTime, relativeTo: Date())
        }
        return news.datePublished!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
//            if let safe_imgUrl = news.imgUrl {
//                URLImage(url: URL(string: safe_imgUrl)!,
//                         content: { image in
//                            image
//                                .resizable()
//                                .scaledToFit()
//
//                         })
//            }
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Text(news.providerName ?? "Provider Not Available")
                    .font(.footnote)
                Text(news.name ?? "Title Not Available")
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.bold)
                    .lineLimit(nil)
                    .padding(.top, 4)
                if let safeDescription = news.description {
                    Text(safeDescription)
                        .font(.system(.subheadline, design: .serif))
                        .lineLimit(nil)
                        .padding(.top, 7)
                }
                Text(relativeTime)
                    .font(.caption)
                    .padding(.top, 7)
            }
            .padding()
        }
        .newsCardViewStyle()
    }
}

struct NewsCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCardView()
            .padding()
            .previewDevice("iPhone 12")
    }
}

