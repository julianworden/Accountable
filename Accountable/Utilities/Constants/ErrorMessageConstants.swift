//
//  ErrorMessageConstants.swift
//  Accountable
//
//  Created by Julian Worden on 3/30/23.
//

import Foundation

struct ErrorMessageConstants {
    static let unknown = "Something went wrong, please check your internet connection and try again."
    static let emailAddressesDontMatchOnSignUp = "The email addresses you entered do not match. Please try again."
    static let emailAddressAlreadyInUse = "This email address is already registered with Accountable. Please try a different email address or go back and sign in."
    static let invalidEmailAddressOnSignUp = "Please enter a valid email address."
    static let passwordsDontMatchOnSignUp = "The passwords you entered do not match. Please try again."
    static let invalidViewState = "Invalid ViewState."
    static let invalidVerificationCodeLength = "The verification code can only be 6 digits long. Please try again."
    static let verificationCodeIsNotANumber = "Only numbers are included in the verification code, please try again."
    static let incorrectConfirmationCode = "The confirmation code you entered is not correct, please try again."
    static let incorrectPassword = "The email address or password you entered is incorrect, please try again."
    static let accountNotConfirmed = "You'll need to confirm your account before you can log in. Tap the button below to do so."
    static let accountDoesNotExist = "This email address is not registered with Accountable. Use the sign up button below if you need to create a new account."
    static let passwordTooShort = "Your password is too short, it must be at least 8 characters long."
    static let emptyOnboardingField = "Please ensure you've filled in all fields in the form."
}
