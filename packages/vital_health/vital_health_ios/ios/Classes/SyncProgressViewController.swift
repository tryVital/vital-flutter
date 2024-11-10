import UIKit
import SwiftUI
import VitalHealthKit

struct SyncProgressView: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      List {
        Section {
          ForEachVitalResource()
        }
      }
      .navigationTitle(Text("Sync Progress"))
      .navigationBarItems(
        leading: Button {
          presentationMode.wrappedValue.dismiss()
        } label: {
          Text("Close")
        }
      )
    }
  }
}

class SyncProgressViewController: UIHostingController<SyncProgressView> {
  init() {
    super.init(rootView: SyncProgressView())
  }

  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
