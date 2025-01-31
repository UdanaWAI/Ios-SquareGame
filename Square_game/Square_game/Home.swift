import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Square Game").font(.largeTitle.bold()).padding(.bottom)
                NavigationLink(destination: GridView()) {
                    Text("Play")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(5)
                NavigationLink(destination: GridView()) {
                    Text("High Score")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                NavigationLink(destination: GridView()) {
                    Text("Guide")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.top, 100)
                
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
}
