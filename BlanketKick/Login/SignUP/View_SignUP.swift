
import SwiftUI

struct View_SignUP: View {
    
    @Binding var isCurrentModal : Bool
    
    @StateObject var viewModel = ViewModel_SignUP()
    
    //    @State var isCheckingMark: Bool = true
    
    @State var isAnimation : Bool = false
    
    
    @State var alreadyExist: Bool = false
    
    @State var isAlertForCheckingID: Bool = false
    
    @State var idUsable: Bool = false
    @State var idChecking : Bool = false
    
    
    @State var rangeMinMax : Bool = false
    @State var hasNumber : Bool = false
    @State var hasEngLowcase : Bool = false
    @State var hasSpecialCharacter : Bool = false
    
    @State var passwordCheckingDone : Bool = false
    
    @State var alertForNewUser : Bool = false
    
    
    
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
                    if viewModel.idForNewUser.isEmpty {
                        
                        Image(systemName: "circle" )
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.gray)
                            .offset(x: 80, y: 7)
                            .onAppear(perform: {
                                idUsable = false
                                idChecking = false
                            })
                    } else {
                        if idChecking == true {
                            Image(systemName: alreadyExist ? "x.circle" : "checkmark.circle" )
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(idUsable ? .green : .gray)
                                .offset(x: 80, y: 7)
                        }
                        else {
                            Image(systemName: "circle" )
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(idUsable ? .green : .gray)
                                .offset(x: 80, y: 7)
                            
                        }
                    }
                    
                    
                    
                    Button(action: {
                        if !viewModel.idForNewUser.isEmpty{
                            //                            idChecking = true
                            alreadyExist = viewModel.mockUsers.contains(where: { Model_SignIN_SignUP in
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
                                idUsable = false
                                idChecking = false
                                viewModel.idForNewUser = ""
                                
                            }))
                        } else if viewModel.idForNewUser.isEmpty == true {
                            return Alert(title: Text("ID를 입력해주세요"), dismissButton: .cancel(Text("확인"), action: {
                                viewModel.idForNewUser = ""
                                idUsable = false
                                idChecking = false
                            })
                            )
                        } else {
                            return Alert(title: Text("사용가능한 ID 입니다."),message: Text("사용하시겠습니까?"), primaryButton: .default(Text("취소"), action: {
                                viewModel.idForNewUser = ""
                                idUsable = false
                                idChecking = false
                            }), secondaryButton: .default(Text("사용하기"), action: {
                                idUsable = true
                                idChecking = true
                            }))
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
                    
//                    viewModel.validPassword(viewModel.pwForNewUser)
                    //                    print("\(viewModel.checkingPasswordCondition(viewModel.pwForNewUser.description))")
                    print("\(viewModel.pwForNewUser)")
                }, label: {
                    if rangeMinMax == true && hasNumber == true && hasEngLowcase == true && hasSpecialCharacter == true {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .onAppear(perform: {
                                passwordCheckingDone = true
                            })
                        
                    } else {
                        Image(systemName: "circle")
                            .foregroundStyle(.gray)
                    }
                })
                .offset(x: 70)
                .disabled(true)
                
            }
            
            VStack {
                HStack{
                    if viewModel.pwForNewUser.count >= 6 && viewModel.pwForNewUser.count <= 14 {
                        
                        Text("비밀번호: 길이 6자리에서 14자리")
                            .foregroundStyle(.green)
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .onAppear(perform: {
                                rangeMinMax = true
                            })
                        
                        Text(rangeMinMax.description)
                            .foregroundStyle(.green
                            )
                        
                    }
                    else if viewModel.pwForNewUser.isEmpty{
                        
                        Text("비밀번호는 6자리에서 14자리 까지")
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.gray)
                            .onAppear(perform: {
                                rangeMinMax = false
                            })
                        
                        Text(/*rangeMinMax.description*/"empty")
                            .foregroundStyle(.gray)
                        
                    } else {
                        
                        Text("비밀번호: 길이는 6자리에서 14자리")
                            .foregroundStyle(.red)
                        
                        Image(systemName: "x.circle")
                            .foregroundStyle(.red)
                            .onAppear(perform: {
                                rangeMinMax = false
                            })
                        
                        Text(rangeMinMax.description)
                            .foregroundStyle(.red)
                        
                    }
                    
                }
                
                HStack{
                    if viewModel.pwForNewUser.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil {
                        
                        Text("비밀번호는 0~9숫자를 반드시 포함")
                            .foregroundStyle(.green)
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .onAppear(perform: {
                                hasNumber = true
                            })
                        
                        Text(rangeMinMax.description)
                            .foregroundStyle(.green
                            )
                        
                    }
                    else if viewModel.pwForNewUser.isEmpty{
                        
                        Text("비밀번호는 0~9숫자를 반드시 포함")
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.gray)
                            .onAppear(perform: {
                                hasNumber = false
                            })
                        
                        Text(/*rangeMinMax.description*/"empty")
                            .foregroundStyle(.gray)
                        
                    } else {
                        
                        Text("비밀번호는 0~9숫자를 반드시 포함")
                            .foregroundStyle(.red)
                        
                        Image(systemName: "x.circle")
                            .foregroundStyle(.red)
                            .onAppear(perform: {
                                hasNumber = false
                            })
                        
                        Text(hasNumber.description)
                            .foregroundStyle(.red)
                        
                    }
                    
                }
                
                
                HStack{
                    if viewModel.pwForNewUser.rangeOfCharacter(from: .lowercaseLetters) != nil {
                        
                        Text("비밀번호는 영소문자를 반드시 포함")
                            .foregroundStyle(.green)
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .onAppear(perform: {
                                hasEngLowcase = true
                            })
                        
                        
                        Text(hasEngLowcase.description)
                            .foregroundStyle(.green)
                        
                        
                    } else if viewModel.pwForNewUser.isEmpty {
                        
                        Text("비밀번호는 영소문자를 반드시 포함")
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.gray)
                            .onAppear(perform: {
                                hasEngLowcase = false
                            })
                        
                        Text(/*hasEngLowcase.description*/"empty")
                            .foregroundStyle(.gray)
                        
                    } else {
                        
                        Text("비밀번호는 영소문자를 반드시 포함")
                            .foregroundStyle(.red)
                        
                        Image(systemName: "x.circle")
                            .foregroundStyle(.red)
                            .onAppear(perform: {
                                hasEngLowcase = false
                            })
                        
                        Text(hasEngLowcase.description)
                            .foregroundStyle(.red)
                        
                        
                    }
                    
                }
                HStack{
                    if viewModel.pwForNewUser.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()_+-={}[]|\\:;\"'<>,.?/`~")) != nil {
                        
                        Text("비밀번호는 특수문자를 반드시 포함")
                            .foregroundStyle(.green)
                        
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(.green)
                            .onAppear(perform: {
                                hasSpecialCharacter = true
                            })
                        
                        Text(hasEngLowcase.description)
                            .foregroundStyle(.green)
                        
                        
                    } else if  viewModel.pwForNewUser.isEmpty {
                        
                        Text("비밀번호는 특수문자를 반드시 포함")
                            .foregroundStyle(.gray)
                        
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.gray)
                            .onAppear(perform: {
                                hasSpecialCharacter = false
                            })
                        
                        Text(/*hasEngLowcase.description*/"empty")
                            .foregroundStyle(.gray)
                        
                    } else {
                        
                        Text("비밀번호는 특수문자를 반드시 포함")
                            .foregroundStyle(.red)
                        
                        Image(systemName: "x.circle")
                            .foregroundStyle(.red)
                            .onAppear(perform: {
                                hasSpecialCharacter = false
                            })
                        
                        Text(hasEngLowcase.description)
                            .foregroundStyle(.red)
                        
                    }
                    
                }
                
                
                
            }
            .padding(.bottom)
            
            
            
            
            Spacer()
                .frame(height: 10)
            
            
            GradientStrokeButton(action: {
                viewModel.successForNewAccount()
                alertForNewUser.toggle()
                
                
                
            }, label: "Done", gradient: LinearGradient(colors: [.yellow,.green], startPoint: .leading, endPoint: .trailing))
            .padding(.bottom)
            .disabled(idUsable && idChecking && passwordCheckingDone ? false : true)
            .alert(isPresented: $alertForNewUser, content: {
                Alert(title:  Text("Welcome! \(viewModel.idForNewUser)!!!"), message: Text("Now you can Login"), dismissButton: .default(Text("Login Page"), action: {
                    isCurrentModal = false
                    print("로그인 페이지로 이동합니다.")
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
    
    func rangeMinMaxOn () {
        rangeMinMax = true
    }
}


#Preview {
    View_SignUP(isCurrentModal: .constant(true) )
}



