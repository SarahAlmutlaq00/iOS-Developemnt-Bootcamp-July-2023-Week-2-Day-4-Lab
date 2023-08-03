//
import SwiftUI

struct SignUpView : View {
    @State var username: String = ""
    @State var password: String = ""
    @State var email: String = ""
    @State var mobileNumber: String = ""
    @State var showAlert : Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        Form {
            TextField("Username", text: $username) { isChanged in
                if !isChanged {
                    validateUsername(username)
                }
            }
            .font(.largeTitle)
            
            SecureField("Password", text: $password)
                .font(.largeTitle)
            
            TextField("Email", text: $email) { isChanged in
                if !isChanged {
                    validateEmail(email)
                }
            }
            .font(.largeTitle)
            TextField("Mobile Number", text: $mobileNumber) { isChanged in
                if !isChanged {
                    validateMobileNumber(mobileNumber)
                }
            }
            .font(.largeTitle)
            
            Spacer().frame(height: 50)
            Button {
                validateUsername(username)
                validatePassword(password)
                validateEmail(email)
                validateMobileNumber(mobileNumber)
            } label: {
                Text(" sign up")
                    .font(.largeTitle)
                    .padding(.all)
                    .cornerRadius(125)
            }
            
            
        }
        .alert(isPresented: $showAlert) {
            Alert (title: Text(alertMessage))
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$", options: [.caseInsensitive])
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.utf16.count)) != nil
    }
    
    func validateUsername(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Username should not be empty"
        } else {
            if value.count < 8 {
                showAlert = true
                alertMessage = "Username should be more than 8 characters"
            }
        }
    }

    func validateEmail(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Email should not be empty"
        } else if(!isValidEmail(email)) {
            showAlert = true
            alertMessage = "Email valid "
        }
    }

    func validatePassword(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "Password should not be empty"
        } else {
            if value.count < 8 {
                showAlert = true
                alertMessage = "Password should be more than 8 characters"
            }
        }
    }
    
    func validateMobileNumber(_ value: String) {
        if value.isEmpty {
            showAlert = true
            alertMessage = "kindly enter a mobile number"
        } else {
            var isNumber = true
            value.forEach { char in
                if !char.isNumber {
                    isNumber = false
                    return
                }
            }
            if !isNumber {
                showAlert = true
                alertMessage = "kindly enter a valid mobile number"
                mobileNumber = ""
            }
        }
    }
}

struct HobbieData : Identifiable  {
    var id: UUID = UUID()
    let name : String
    let imageURL :URL?
}

struct HobbiesView: View {
    let data : HobbieData
    var body: some View {
        HStack {
            NavigationLink(
                destination:{
                    VStack {
                        GeometryReader { geometryProxy in
                            ZStack {
                                AsyncImage(url: data.imageURL){ result in
                                    if let image = result.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        //Rectangle()
                                        //.fill(Color.black.opacity(0.1))
                                        ProgressView()
                                    }
                                    
                                }
                                .frame(
                                    width: geometryProxy.size.width,
                                    height :geometryProxy.size.height
                                )
                                VStack{
                                    Spacer()
                                    Text(data.name)
                                        .frame(maxWidth : .infinity ,alignment : .center)
                                }
                                .foregroundColor(.white)
                                .background(Gradient(colors: [
                                    Color.clear ,
                                    Color.clear ,
                                    Color.clear ,
                                    Color.black
                                    
                                ]  )  )
                                
                            }
                        }
                    }.navigationTitle(data.name)
                },
                label: {
                    Text(data.name)
                        .padding()
                        .frame(maxWidth : .infinity ,alignment : .leading)
                }
            )
        }
    }
}

func makeHobbieData() -> Array<HobbieData> {
    let hobbieData = hobbiesList.map { hobbie in
        HobbieData(name: hobbie, imageURL:
                    
                    URL(string: "https://source.unsplash.com/200x200/?\(hobbie)"))
    }
    
    return hobbieData
}


struct ContentView: View {
    let hobbiesData : Array<HobbieData> = makeHobbieData()
    
    var body: some View {
        NavigationView {
            VStack {
                List(hobbiesData) { hobbies in
                    HobbiesView(data: hobbies)
                }
            } .navigationTitle("hobbies")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                TabView {
                    ContentView()
                        .tabItem{
                            Label("hobbies" , systemImage : "doc")
                        }
                    
                    SignUpView()
                        .tabItem{
                            Label("Signup" , systemImage : "person")
                        }
                }
            }
            
        }
    }
}
let hobbiesList : Array<String> = """
3D printing
Acroyoga
Acting
Alternate history
Amateur chemistry
Amateur radio
Animation
Anime
Art
Baton twirling
Beatboxing
Beer tasting
Bell ringing
Binge watching
Bird watching
Blacksmith
Blogging
Bonsai
Board/tabletop games
Book discussion clubs
Book restoration
Bowling
"""
    .components(separatedBy: "\n")

