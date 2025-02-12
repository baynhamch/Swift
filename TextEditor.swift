struct ContentView: View {
    @State private var profileText = "Enter your bio"

    var body: some View {
        NavigationStack {
            TextEditor(text: $profileText)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .navigationTitle("About you")
        }
    }
}
