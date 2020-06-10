//
//  ContentView.swift
//  iOSConferences
//
//  Created by jsmith on 27.02.20.
//  Copyright © 2020 JetBrains. All rights reserved.
//

import SwiftUI

struct ConferenceList: View {
    @ObservedObject var conferenceLoader = ConferencesLoader()
    var body: some View {
        NavigationView {
            List(conferenceLoader.conferences) { conference in
                NavigationLink(destination: ConferenceDetails(conference: conference)) {
                    VStack(alignment: .leading) {
                        Text(conference.name).font(.headline)
                        Text(conference.location).font(.subheadline)
                    }
                }
            }.navigationBarTitle("Conferences")
        }
    }
}

class ConferenceList_Previews: PreviewProvider {
    static var previews: some View {
        ConferenceList()
    }

    #if DEBUG
    @objc class func injected() {
        UIApplication.shared.windows.first?.rootViewController =
                UIHostingController(rootView: ConferenceList())
    }
    #endif
}
