//
//  CompactNewsCard.swift
//  Solid News
//
//  Created by Fan Zhang on 11/15/20.
//  Copyright © 2020 Fan Zhang. All rights reserved.
//

import SwiftUI

struct CompactNewsCardView: View {
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
            HStack {
                Spacer()
            }
            Text(news.providerName ?? "Provider Not Available")
                .font(.footnote)
            Text(news.name ?? "Title Not Available")
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.bold)
                .lineLimit(3)
                .padding(.top, 4)
            Spacer()
            Text(relativeTime)
                .font(.caption)
                .padding(.top, 7)
        }
        .padding()
        .newsCardViewStyle()
        .frame(width: 250, height: 160)
        
    }
}

struct CompactNewsCard_Previews: PreviewProvider {
    static var previews: some View {
        CompactNewsCardView()
    }
}
