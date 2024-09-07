// pull complete from Developing branch  2024 10th july  11:09 am  (after combine+firebase for new acc)

import SwiftUI

struct View_SignUP: View {
    
    @Binding var isCurrentModal : Bool
    
    @StateObject var viewModel = ViewModel_SignUP()

    @State var passwordCheckingDone : Bool = false
    
    @State var alertForNewUser : Bool = false
    
//    @State var showingImagePicker: Bool = false
//    @State var profileImage: UIImage?
    
    var body: some View {
        
        
        VStack{
            
            ZStack {
                WavyRectangle(waveHeight: 25, frequency: 20)
                    .fill(LinearGradient(
                        gradient: viewModel.isAnimation ? Gradient(colors: [Color("sublogoStart"), Color("sublogoEnd")]) : Gradient(colors: [.green,.orange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .ignoresSafeArea()
                    .offset( x: viewModel.isAnimation ? 600 : -100)
                    .onAppear(perform: {
                        withAnimation(Animation.easeOut(duration: 3)) {
                            viewModel.isAnimation = true
                        }
                    })
                    .frame(width: 1800)
                    .opacity(viewModel.isAnimation ? 0.5 : 1)
                
                WavyRectangle(waveHeight: 25, frequency: 20)
                    .fill(LinearGradient(
                        gradient: viewModel.isAnimation ? Gradient(colors: [Color("logoStart"), Color("logoEnd")]) : Gradient(colors: [.yellow, .pink]),                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .overlay(content: {
                        
                    })
                    .ignoresSafeArea()
                    .frame(width: 1800)
                    .offset(x: viewModel.isAnimation ? -350 : 350)
                    .opacity(viewModel.isAnimation ? 0.3 : 1)
           
            }
        }
        
        VStack{
            
            viewModel.joinUsText()
            
            Spacer()
                .frame(height: 30)
            
            Button(action: {
                
                viewModel.showingImagePicker.toggle()

            }, label: {
                
                VStack{
                    if let profileImage = viewModel.profileImage {
                                               Image(uiImage: profileImage)
                                                   .resizable()
                                                   .scaledToFill()
                                                   .frame(width: 100, height: 100)
                                                   .clipShape(Circle())
                                           } else {
                                               viewModel.profilePhotoImage()
                                           }
                
                    Text("프로필 사진")
                        .foregroundStyle(Gradient(colors: [.green,.purple]))
                }
            })
            .sheet(isPresented: $viewModel.showingImagePicker) {
                ImagePicker(image: $viewModel.profileImage)
            }
    
            ZStack{
                GradientStrokeTextField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New Email", bindingValue: $viewModel.user.email)
                    .padding(.top)
                    .onChange(of: viewModel.user.email) { oldValue, newValue in
                        viewModel.filteringStringForUserId(newValue: newValue)
                    }
                
                HStack{
                    viewModel.idCheckingImage()
                    
                    Button(action: {
                        viewModel.checkingEmailExistWithCombine()
                            viewModel.isAlertForCheckingID.toggle()
                        
                    }, label: {
                        Image( systemName: "person.fill.questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20,height: 20)
                            .foregroundStyle(.gray)
                    })
                    .offset(x: 85,y: 7)
                    .alert(isPresented: $viewModel.isAlertForCheckingID) {
                        viewModel.alertAlreadyExsitsId()
                    }
                }
            }
            
            
            GradientStrokeTextField(gradient: LinearGradient(colors: [.green, .purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New Name", bindingValue: $viewModel.user.name)
                .padding(.top)
                .onChange(of: viewModel.user.name) { oldValue, newValue in
                        viewModel.filteringStringForUserName(newValue: newValue)
                }
            
            ZStack{
                GradientStrokeSecureField(gradient: LinearGradient(colors: [.green,.purple], startPoint: .leading, endPoint: .trailing), placeholderValue: "New PW", bindingValue: $viewModel.user.password, isVisibleCode: false)
                    .padding([.top, .bottom])
                    .onChange(of: viewModel.user.password) { oldValue, newValue in
                        viewModel.filteringStringForUserPw(newValue: newValue)
                    }

                Button(action: {
                    print("\(viewModel.user.password)")
                }, label: {
                    viewModel.pwCheckBoxImage()
    
                })
                .offset(x: 70)
                .disabled(true)
                
            }
            
            VStack {
                HStack{
                    viewModel.lengthConditionForCheckingPwText()
                 
                }
                
                HStack{
                    viewModel.numberConditionForPwText()
                 
                }
                
                HStack{
                    viewModel.lowcaseConditionForPwText()
              
                    
                }
                HStack{
                    viewModel.specialCharacterText()
                  
                    
                }
            }
            .padding(.bottom)
                      
            Spacer()
                .frame(height: 10)
            
            
            GradientStrokeButton(action: {
                viewModel.successForNewAccount()
                alertForNewUser.toggle()
                viewModel.signUPwithCombine()
            }, label: "Done", gradient: LinearGradient(colors: [.yellow,.green], startPoint: .leading, endPoint: .trailing))
            .padding(.bottom)
            .disabled(viewModel.emailUsable && viewModel.emailChecking && viewModel.passwordCheckingDone ? false : true)
            .alert(isPresented: $viewModel.alertForNewUser, content: {
                Alert(title:  Text("Welcome! \(viewModel.user.email)!!!"), message: Text("Now you can Login"), dismissButton: .default(Text("Login Page"), action: {
                    isCurrentModal = false
                    print("로그인 페이지로 이동합니다.")
                    viewModel.alertForNewUser.toggle()
                        viewModel.authLogOutWithCombine()
                }))
            })
            
            GradientStrokeButton(action: {
                print("회원가입을 하지않고 다시 로그인페이지로 이동하기위해 현제 풀스크린 모달을 벗어납니다.")
                isCurrentModal = false
            }, label: "Back", gradient: LinearGradient(colors: [.red,.purple], startPoint: .leading, endPoint: .trailing))
            
            Spacer()
                .frame(height: 10)
        }
    }
}

#Preview {
    View_SignUP( isCurrentModal: .constant(true) )
}
