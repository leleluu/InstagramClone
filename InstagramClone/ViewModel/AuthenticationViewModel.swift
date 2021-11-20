import UIKit

struct LoginViewModel {
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

struct RegistrationViewModel {

}
