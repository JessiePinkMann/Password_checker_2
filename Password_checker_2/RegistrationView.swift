import SwiftUI

struct RegistrationView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordStrength: PasswordStrength = .weak
    
    private var isLoginButtonEnabled: Bool {
        return passwordStrength == .strong && !username.isEmpty && password == confirmPassword
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
            
            SecureField("Password", text: $password)
                .padding()
                .onChange(of: password) { _ in
                    updatePasswordStrength()
                }
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
            
            HStack {
                Text("Password Strength:")
                    .foregroundColor(passwordStrength.color)
                    .padding()
                
                Spacer()
                
                Text(passwordStrength.rawValue)
                    .foregroundColor(passwordStrength.color)
                    .padding()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                CriteriaView(icon: "checkmark.circle", description: "At least 8 characters", met: password.count >= 8)
                CriteriaView(icon: "checkmark.circle", description: "At least one uppercase letter", met: password.rangeOfCharacter(from: .uppercaseLetters) != nil)
                CriteriaView(icon: "checkmark.circle", description: "At least one lowercase letter", met: password.rangeOfCharacter(from: .lowercaseLetters) != nil)
                CriteriaView(icon: "checkmark.circle", description: "At least one digit", met: password.rangeOfCharacter(from: .decimalDigits) != nil)
                CriteriaView(icon: "checkmark.circle", description: "At least one special character", met: password.rangeOfCharacter(from: .symbols) != nil)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(isLoginButtonEnabled ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .disabled(!isLoginButtonEnabled)
            }
        }
        .padding()
    }
    
    private func updatePasswordStrength() {
        let criteriaMet = [
            password.count >= 8,
            password.rangeOfCharacter(from: .uppercaseLetters) != nil,
            password.rangeOfCharacter(from: .lowercaseLetters) != nil,
            password.rangeOfCharacter(from: .decimalDigits) != nil,
            password.rangeOfCharacter(from: .symbols) != nil
        ]
        
        let fulfilledCriteria = criteriaMet.filter { $0 }.count
        
        switch fulfilledCriteria {
        case 0...2:
            passwordStrength = .weak
        case 3...4:
            passwordStrength = .midStrong
        default:
            passwordStrength = .strong
        }
    }
}

struct CriteriaView: View {
    var icon: String
    var description: String
    var met: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(met ? .green : .red)
            Text(description)
                .foregroundColor(met ? .primary : .secondary)
        }
    }
}

enum PasswordStrength: String {
    case weak = "Weak"
    case midStrong = "Mid-Strong"
    case strong = "Strong"
    
    var color: Color {
        switch self {
        case .weak:
            return .red
        case .midStrong:
            return .orange
        case .strong:
            return .green
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
