
import SwiftUI

struct View_SignUP: View {
    
    @Binding var isCurrentModal : Bool
    
    @StateObject var viewModel = ViewModel_SignUP()
    
    //    @State var isCheckingMark: Bool = true
    
    @State var isAnimation : Bool = false
    
    
    @State var alreadyExist: Bool = false
    
    @State var isAlertForCheckingID: Bool = false
    @State var idUsable: Bool = false
    
    
    
    @State var showingImagePicker: Bool = false
    @State var profileImage: UIImage?
    
    
    
    
    var body: some View {
        
        
        VStack{
            
            ZStack {
                WavyRectangle(waveHeight: 25, frequency: 20)
                    .fill(LinearGradient(
                        gradient: isAnimation ? Gradient(colors: [Color("sublogoStart"), Color("sublogoEnd")]) : Gradient(colors: [/*Color("sublogoEnd"),Color("sublogoStart")*/.green,.orange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .ignoresSafeArea()
                    .offset( x: isAnimation ? 600 : -100)
             
//                    .animation(.easeInOut(duration: 5).repeatForever(), value: isAnimation)
//                    .onAppear(perform: {
//                        withAnimation(Animation.easeOut(duration: 3).repeatForever(autoreverses: true)) {
//                            isAnimation = true
//                        }
//                    })
                    .onAppear(perform: {
                        withAnimation(Animation.easeOut(duration: 5)) {
                            isAnimation = true
                        }
                    })
                    .frame(width: 1800)
                    .opacity(isAnimation ? 0.5 : 1)

                
                WavyRectangle(waveHeight: 25, frequency: 20)
                    .fill(LinearGradient(
                        gradient: isAnimation ? Gradient(colors: [Color("logoStart"), Color("logoEnd")]) : Gradient(colors: [.yellow, .pink]),                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .overlay(content: {
                        
                    })
                    .ignoresSafeArea()
                    .frame(width: 1800)
                    .offset(x: isAnimation ? -350 : 350)
                    .opacity(isAnimation ? 0.3 : 1)

                
              
            }
        }
        
        
        
        
        VStack{
            
                Text("Join US")
                    .padding(.bottom)
                    .fontWeight(.black)
                    .font(.system(size: 45))
                    .foregroundStyle(.black)
                    .fontDesign(.rounded)
                    .fontWidth(Font.Width(100))
               
            
            
            
            Spacer()
                .frame(height: 30)
            
            Button(action: {
                
            }, label: {
                
                VStack{
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .foregroundStyle(Gradient(colors: [.mint,.purple]))
                        .overlay {
                            Circle()
                                .background(.clear)
                                .foregroundStyle(.clear)
                        }
                    Text("프로필 사진")
                        .foregroundStyle(Gradient(colors: [.green,.purple]))
                }
            })
            
            
            ZStack{
                GradientStrokeTextField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New ID", bindingValue: $viewModel.idForNewUser)
                    .padding(.top)
//                    .onChange(of: viewModel.idForNewUser) { newValue in
//                                            viewModel.idForNewUser = newValue.replacingOccurrences(of: " ", with: "")
//                                        }
                    .onChange(of: viewModel.idForNewUser) { oldValue, newValue in
                        viewModel.idForNewUser = newValue.lowercased().replacingOccurrences(of: " ", with: "")

                    }
                
                HStack{
                    
                    Image(systemName: alreadyExist ? "x.circle" : "checkmark.circle" )
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(idUsable ? .green : .gray)
                        .offset(x: 80, y: 7)
                    
                    
                    
                    Button(action: {
                        if !viewModel.idForNewUser.isEmpty{
                            
                            alreadyExist = mockUsers.contains(where: { Model_SignIN_SignUP in
                                Model_SignIN_SignUP.id == viewModel.idForNewUser
                            })
                        }
                        isAlertForCheckingID.toggle()
                        
                    }, label: {
                        
                        Image( systemName: "person.fill.questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20,height: 20)
                            .foregroundStyle(.gray)
                        
                        
                        
                        
                    })
                    .offset(x: 85,y: 7)
                    
                    
                    .alert(isPresented: $isAlertForCheckingID) {
                        if alreadyExist {
                            return Alert(title: Text("이미 존재하는 ID 입니다."),dismissButton: .cancel(Text("확인"), action: {
                                
                            }))
                        } else if viewModel.idForNewUser.isEmpty == true {
                            return Alert(title: Text("ID를 입력해주세요"))
                        } else {
                            return Alert(title: Text("사용가능한 ID 입니다."),message: Text("사용하시겠습니까?"), primaryButton: .default(Text("취소"), action: {
                                viewModel.idForNewUser = ""
                                idUsable = false
                            }), secondaryButton: .default(Text("사용하기"), action: {
                                idUsable = true                                                    }))
                        }
                    }
                }
            }
            
            
            GradientStrokeTextField(gradient: LinearGradient(colors: [.green, .purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New Name", bindingValue: $viewModel.nameForNewUser)
                .padding(.top)
                .onChange(of: viewModel.nameForNewUser) { oldValue, newValue in
                    viewModel.nameForNewUser = newValue.replacingOccurrences(of: " ", with: "")
                }
            
            ZStack{
                GradientStrokeSecureField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New PW", bindingValue: $viewModel.pwForNewUser, isVisibleCode: false)
                    .padding([.top, .bottom])
                    .onChange(of: viewModel.pwForNewUser) { oldValue, newValue in
                        viewModel.pwForNewUser = newValue.replacingOccurrences(of: " ", with: "")
                    }
                
                
                Button(action: {
                    //                    isCheckingMark.toggle()
                    viewModel.validPassword(viewModel.pwForNewUser)
                    print("\(viewModel.checkingPasswordCondition(viewModel.pwForNewUser.description))")
                }, label: {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.gray)
                })
                .offset(x: 70)
                
            }
            
            
            Spacer()
                .frame(height: 30)
            
            
                GradientStrokeButton(action: {
                    viewModel.successForNewAccount()
                    
                    
                    
                    
                }, label: "Done", gradient: LinearGradient(colors: [.yellow,.green], startPoint: .leading, endPoint: .trailing))
                .padding(.bottom)
                .disabled(idUsable ? false : true)
            
            
            
            
            
            GradientStrokeButton(action: {
                print("회원가입을 하지않고 다시 로그인페이지로 이동하기위해 현제 풀스크린 모달을 벗어납니다.")
                isCurrentModal = false
            }, label: "Back", gradient: LinearGradient(colors: [.red,.purple], startPoint: .leading, endPoint: .trailing))
            
            Spacer()
                .frame(height: 70)
        }
    }
}


#Preview {
    View_SignUP(isCurrentModal: .constant(true) )
}



