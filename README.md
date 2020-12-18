# COVID Panel

For video demo: [YouTube](https://youtu.be/o77KbcBb_ow).

This is an iOS app for COVID-19 data visualization, built with SwiftUI and UIKit. I designed and developed this app to help users get and analyze data easily on their iPhones.

Unfortunetely, Apple does not allow COVID related app to be uploaded by individual developer, thus, I am still looking for any research institution or CDC offcials, that wants to publish their data to users, to collaborate on this project.

If you would like to know more about this app, please contact me on: [LinkedIn](https://www.linkedin.com/in/fan-zhang-sv/).

# Functionality

## Dashboard

The dashboard is a list to show COVID summarization for multipal saved location.

<img src="https://github.com/fan-zhang-sv/COVID-Panel-SwiftUI/blob/main/Images/Posters/1.png?raw=true">

Once user click on one of the location card, a new page would open and show more detailed information about the location. All the charts are interactable, where users can click each bar in the chart and see the information, such as new cases and fatality, on that specific day.

<img src="https://github.com/fan-zhang-sv/COVID-Panel-SwiftUI/blob/main/Images/Posters/2.png?raw=true">

## Map

The map provides a way for the user to see the situation in a bigger picture, where above each county in the US shows a circle, whose diameter determines how many new cases are confirmed today in each county. It could also be set the total cases number or deaths number.

<img src="https://github.com/fan-zhang-sv/COVID-Panel-SwiftUI/blob/main/Images/Posters/3.png?raw=true">

## News

Within the detailed information page provides latest local news, which is provided by Microsoft's Bing News API, so its credibility could be guaranteed. And if user wants to check for news in places that does not speak English, user can simply click the Translate button to get translated title for those news, which is also provided by Microsoft's translate API.

<img src="https://github.com/fan-zhang-sv/COVID-Panel-SwiftUI/blob/main/Images/Posters/4.png?raw=true">

## i18n & l10n

This app offers interface in English, Chinese (simplified), Chinese (traditional), Japanese, Korean.

<img src="https://github.com/fan-zhang-sv/COVID-Panel-SwiftUI/blob/main/Images/Posters/5.png?raw=true">

# Installation & Usgae

If you'd like to download this project and compile for your own device. Simply download it from this page.

After downloading it, you need to provide api keys to make this app works. Check under the Models folder, in which there are four module that need to be provided a key or URL to make it work, they are:

**MapDotUpdater.swift**: mapDotsUrl (this api is developed by me, please contact me for the url.)

**SingleLineTranslater.swift**: translateKey (this api key is for Bing Translate API.)

**NewsListUpdater.swift**: newsKey (this api key is for Bing News API.)

**CovidDataGarbber.swift**: covidDataUrl (this api is developed by me, please contact me for the url.)
