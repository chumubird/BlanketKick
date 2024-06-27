// 백업 완료후 브랜치 테스트 커밋 18. 6 .24

import SwiftUI


struct View_SignIN: View {
  
    @StateObject var viewModel = ViewModel_SignIN()
    
    
    @State var isAnimation : Bool = false

    
    
    var body: some View {
        
        VStack {
        
            ZStack{
                
                WavyRectangle(waveHeight: 40, frequency: 20)
                    .fill(LinearGradient(
                        gradient: isAnimation ? Gradient(colors: [Color("logoEnd"), Color("logoStart")]) : Gradient(colors: [Color("rememberCircleStart"), Color("sublogoEnd")]) ,
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .ignoresSafeArea()
                    .frame(width: 1800)
                    .opacity(isAnimation ? 0.5 : 1)
//                    .offset(x: -70)
                    .offset( x: isAnimation ? 600 : -100)

                
                WavyRectangle(waveHeight: 40, frequency: 20)
                    .fill(LinearGradient(
                        gradient: isAnimation ? Gradient(colors: [Color("rememberCircleStart"), Color("sublogoStart")]) : Gradient(colors: [Color("logoStart"), Color("sublogoEnd")]),                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .overlay(content: {
                        
                    })
                    .ignoresSafeArea()
                    .frame(width: 1800)
                    .opacity(isAnimation ? 0.5 : 1)
                    .offset(x: isAnimation ? -350 : 350)


                
            }
            .onAppear(perform: {
                withAnimation(Animation.easeOut(duration: 3)) {
                    isAnimation = true
                }
            })
            Text("Welcome!")
                .font(.largeTitle)
                .fontWeight(.black)
            
            GradientStrokeTextField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "User ID", bindingValue: $viewModel.idForLogin)
                .padding()
            
            GradientStrokeSecureField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "User PW", bindingValue: $viewModel.pwForLogin)
                            
                }
            
            HStack {
                Button (action: {
                    viewModel.isRememberUser.toggle()
                    
                }, label: {
                    HStack{
                        Spacer()
                            .frame(width: 20)
                        GradientCircle(gradient: LinearGradient( colors: viewModel.isRememberUser ? [.red, .blue] : [Color("rememberCircleStart"),Color("rememberCircleEnd")] , startPoint: .leading, endPoint: .trailing), size: 20)                            .overlay {
                            Circle()
                                .frame(width: 12)
                                .foregroundColor(viewModel.isRememberUser ? Color("logoStart") : .white)
                        }
                        
                        
                        Text("Remember ID")
                            .font(.system(size: 13))
                            .foregroundColor(viewModel.isRememberUser ? .cyan : .gray)
                    }
                })
                .padding()
                
                Spacer()
                    .frame(width: 55)
                
                HStack{
                    Button (action: {
                        
                    }, label: {

                        viewModel.Buttonforget()
                        
                    })
                    .padding()
                    Spacer()
                        .frame(width: 20)
                }
            }
            
            GradientStrokeButton(action: {
                
            }, label: "Login", gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing))
            
            HStack{
                Text("New User ?")
                    .font(.system(size: 13))
                
                Button(action: {

                    viewModel.isSignUPmodal.toggle()
                    
                }, label: {
                    GradientText(
                        text: "Sign UP",
                        gradient: LinearGradient(
                            colors: [.green,.purple],
                            startPoint: .leading,
                            endPoint: .trailing), fontSize: .system(size: 15))
                    
                }).fullScreenCover(isPresented: $viewModel.isSignUPmodal, content: {
                    View_SignUP(isCurrentModal: $viewModel.isSignUPmodal)
                })
            }
            
            ZStack {
                Divider()
                    .frame(width: 275, height: 1.2)
                    .background(.gray)
                    .padding()
                
                GradientText(
                    text: "OR",
                    gradient: LinearGradient(
                        gradient: Gradient(colors: [.green, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ), fontSize: .headline
                )
                .padding()
                .background(Color.white)
            }
            
            HStack {
                
                Button(action: {
                    
                }, label: {
                    Text("APPLE")
                })
                
                Button(action: {
                    
                }, label: {
                    Text("KAKAOTALK")
                })
            }
            
            Text("Sign in with another account")
                .padding()
                .font(.system(size: 10))
                .fontWeight(.light)
                .foregroundStyle(.gray)
        }
    }





#Preview {
    View_SignIN()
}


