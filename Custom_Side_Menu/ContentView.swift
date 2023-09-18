//
//  ContentView.swift
//  Custom_Side_Menu
//
//  Created by Avinash Muralidharan on 15/09/23.
//

import SwiftUI


struct SideBarItem : Identifiable, Equatable {
    var id = UUID()
    var iconName : String
    var name : String
    var screen : AnyView
    
    static func == (lhs: SideBarItem, rhs: SideBarItem) -> Bool {
        return lhs.id == rhs.id
    }
    
}
struct ContentView: View {
    var body: some View {
        CustomSideMenu(
            userDp:"profileDp",
            userName: "Avinash Muralidharan",
            [
            SideBarItem(iconName: "house", name: "Home", screen: AnyView(HomeView())),
            SideBarItem(iconName: "magnifyingglass", name: "Search", screen: AnyView(SearchView())),
            SideBarItem(iconName: "person", name: "Profile", screen: AnyView(ProfileView()))
        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CustomSideMenu : View {
    @State var selected : Int
    @State private var yOffSet = 0.0
    @State var sideBarItems : [SideBarItem]
    @State var menu : Bool = false
    var userDp : String
    var userName : String
    
    init(userDp:String,userName:String,_ SideBarItems:[SideBarItem]){
        self.userDp = userDp
        self.userName = userName
        _sideBarItems = State(initialValue: SideBarItems)
        selected = 0
    }
    
    var body: some View {
        ZStack{
            
            VStack(spacing:20){
                HStack{
                    Image(userDp)
                        .resizable()
                        .frame(width: 50,height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text(userName)
                }
                .padding(.top,100)
                .foregroundColor(Color(UIColor.systemBackground))
                
                ForEach(sideBarItems) { item in
                    
                    
                    HStack(spacing: 20){
                        Image(systemName: item.iconName)
                        Text(item.name)
                            .font(.headline)
                    }
                    .onTapGesture {
                        withAnimation(.spring()){
                            selected = sideBarItems.firstIndex(of: item) ?? 0
                            yOffSet = CGFloat( selected ) * 70.0
                        }
                    }
                    .frame(maxWidth:.infinity,alignment:.leading)
                    .padding()
                    .foregroundColor(Color(UIColor.systemBackground))
                    
                    
                }
                
                Spacer()
            }
            .padding(.leading,0)
            .frame(maxWidth: 250)
            .overlay{
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor((Color(UIColor.systemBackground)))
                    
                    HStack(spacing: 20){
                        Image(systemName:sideBarItems[selected].iconName)
                        Text(sideBarItems[selected].name)
                            .font(.headline)
                    }
                    .frame(maxWidth:.infinity,maxHeight:40,alignment:.leading)
                    .padding(.leading,50)
                    .foregroundColor(Color(UIColor.label))
                    .zIndex(2)
                }
                .frame(width:280,height: 40)
                .offset(x:-20,y:yOffSet - 230)
                .zIndex(-10)
            }
                
                Rectangle()
                     .frame(maxWidth: 250,maxHeight: 650)
                     .background(.thinMaterial)
                     .cornerRadius(30)
                     .offset(x:menu ? 250 :120,y:0)
               Rectangle()
                    .frame(maxWidth: 250,maxHeight: 670)
                    .background(.thickMaterial)
                    .cornerRadius(30)
                    .offset(x:menu ? 260 :120,y:0)
                    
                ZStack{
                    Image(systemName: "line.3.horizontal")
                        .onTapGesture {
                            withAnimation(.spring()){
                                menu = true
                            }
                        }
                        .font(.system(size: 30))
                        .foregroundColor(menu ? Color(UIColor.systemBackground) : Color(UIColor.label) )
                        .offset(x:menu ? -300 :-150,y:menu ? -300 :-350)
                        .zIndex(30)
                    VStack{
                        sideBarItems[selected].screen
                            
                    }
                    .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                        .onEnded { value in
                            print(value.translation)
                            switch(value.translation.width, value.translation.height) {
                                case (...0, -30...30):  print("left swipe")
                                case (0..., -30...30):withAnimation(.spring()){
                                    menu = true
                                }
                                case (-100...100, ...0):  print("up swipe")
                                case (-100...100, 0...):  print("down swipe")
                                default:  print("no clue")
                            }
                        }
                    )

                       
                }
                .frame(maxWidth: menu ? 300 : .infinity,maxHeight:menu ? 700 : .infinity)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(30)
                .offset(x:menu ? 300 : 0)
                .onTapGesture {
                    withAnimation(.spring()){
                        menu = false
                    }
                }

            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment:.leading)
        .background(Color(UIColor.label))
        .ignoresSafeArea()
       
        
    }
}



struct HomeView : View{
    var body: some View{
        Text("Home")

    }
}

struct SearchView : View{
    var body: some View{
        Text("Search")
    }
}

struct ProfileView : View{
    var body: some View{
        Text("Profile")
    }
}
