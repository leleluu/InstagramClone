import UIKit

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }

    var buttonBackgroundColour: UIColor { get }

    var buttonTitleColour: UIColor { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }

    var buttonBackgroundColour: UIColor {
        return formIsValid ? .systemPink : .systemBlue.withAlphaComponent(0.5)
    }

    var buttonTitleColour: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?

    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
        && fullname?.isEmpty == false && username?.isEmpty == false

    }

    var buttonBackgroundColour: UIColor {
        return formIsValid ? .systemPink : .systemBlue.withAlphaComponent(0.5)
    }

    var buttonTitleColour: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
