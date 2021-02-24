//
//  NewsView.swift
//  COVID Panel
//
//  Created by Fan Zhang on 11/21/20.
//

import SwiftUI

struct NewsView: View {
    
    @AppStorage("defaultLang") var defaultLang: String?
    
    let placeName: String
    let country: String
    
    var translatable: Bool {
        defaultLang != Languages.countryToLang[country]
    }
    
    var localeIdentifier: String {
        defaultLang!.replacingOccurrences(of: "-", with: "_")
    }
    
    @State private var translate: Bool = false
    @State var noResults: Bool = false
    
    @State var newsList: [NewsModel]?
    
    var newsManager: NewsListUpdater { NewsListUpdater(newsList: $newsList, country: country) }
    var translateManager: NewsListTranslater{ NewsListTranslater(newsList: $newsList) }
    
    @State var show_modal: Bool = false
    
    @Environment(\.appColor) var appColor
    
    var today: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: localeIdentifier)
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing:0) {
                    HStack {
                        Image(systemName: "mappin")
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.white)
                            .frame(width: 8)
                        Text(placeName)
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(.white)
                    }
                    HStack {
                        Text("Local News")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                        Spacer()
                        Menu(content: {
                            if translatable {
                                if translate {
                                    Button(action: {
                                        translateManager.untranslate()
                                        translate = false
                                    }) {
                                        Label(
                                            title: { Text("Show Origin") },
                                            icon: { Image(systemName: "doc") }
                                        )
                                    }
                                } else {
                                    Button(action: {
                                        translateManager.archiveDataAndTranslate()
                                        translate = true
                                    }, label: {
                                        Label(
                                            title: { Text("Translate") },
                                            icon: { Image(systemName: "doc.plaintext") }
                                        )
                                    })
                                }
                            } else {
                                Text("Translate")
                                    .foregroundColor(Color(.systemGray))
                            }
                        }) {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    Text(today)
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical)
            .onAppear {
                newsManager.updateViews(searchTopic: placeName, translate: SingleLineTranslater.translateAndDoCallback)
            }
            
            LazyVStack(spacing: 0) {
                if newsList == nil {
                    Placeholder()
                } else {
                    ForEach(newsList!, id:\.id) { news in
                        NewsButton(news: news, mkt: Languages.countryToMkt[country]!, show_modal: $show_modal)
                    }
                    .padding(.bottom, 16)
                }
                
            }
            
            Divider()
            HStack {
                Text("Data updated on:")
                Text(today)
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.bottom, 20)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("adaptiveBlue"),Color("adaptiveBlue"), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom))
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            NewsView(placeName: "San Jose", country: "United States")
        }
    }
}


struct Placeholder: View {
    let articles: [NewsModel] = [NewsModel.defaultNews(), NewsModel.defaultNews(), NewsModel.defaultNews()]
    
    var body: some View {
        ForEach(articles, id:\.id) { news in
            NewsButton(news: news, mkt: "en-US", show_modal: .constant(false))
                .redacted(reason: .placeholder)
        }
        .padding(.bottom, 16)
    }
}

struct NewsButton: View {
    
    let defaultUrl = "https://www.apple.com/"
    
    var news: NewsModel = NewsModel.defaultNews()
    var mkt: String = "en-US"
    var url: URL {
        URL(string: news.url ?? defaultUrl)!
    }
    
    var compact: Bool = false
    
    @Binding var show_modal: Bool
    
    var body: some View {
        Button(action: {
            show_modal = true
        }) {
            NewsCardView(news: news, mkt: mkt)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $show_modal) {
            SafariView(url: url)
                .edgesIgnoringSafeArea(.all)
        }
    }
}


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
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                .frame(height: 1)
                Text(news.providerName ?? "Provider Not Available")
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .font(.footnote)
                Text(news.name ?? "Title Not Available")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    //                    .foregroundColor(Color("casesColor"))
                    .lineLimit(nil)
                    .padding(.vertical, 1)
                Text(relativeTime)
                    .font(.footnote)
                HStack {
                    Spacer()
                }
            }
            .padding(.vertical, 14)
        }
        .padding(.horizontal)
        .background(Color("CardBackground"))
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
