//
//  ConferenceList.swift
//  iOSConferences
//
//  Created by jetbrains on 29.10.21.
//
//

import SwiftUI

struct ConferenceList: View {
    @ObservedObject var conferenceLoader = ConferencesLoader()
    var body: some View {
        NavigationView {
            List(conferenceLoader.conferences) {conference in
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
