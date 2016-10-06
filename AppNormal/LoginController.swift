//
//  LoginController.swift
//  AppNormal
//
//  Created by Michelle Grover on 10/4/16.
//  Copyright © 2016 Norbert Grover. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var loginRegisterButton:UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Register", forState: .Normal)
        button.setTitleColor(UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
        button.backgroundColor = UIColor(red: 0.41, green: 0.01, blue: 0.01, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0).CGColor
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.backgroundColor = UIColor.clearColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.clearColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.05, green: 0.00, blue: 0.00, alpha: 1.0)
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor.clearColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.secureTextEntry = true
        return textField
    }()
    
    lazy var profileImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        return imageView
    }()
    
    lazy var loginRegisterSegementedControl:UISegmentedControl = {
        let control = UISegmentedControl(items: ["Login", "Register"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 1
        control.tintColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        control.addTarget(self, action: #selector(handleLoginRegisterChanged), forControlEvents: .ValueChanged)
        return control
    }()
    
    let errorDisplayLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 18)
        label.textColor = UIColor(red: 1.00, green: 0.53, blue: 0.14, alpha: 1.0)
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        return label
    }()
    
    
    
    func handleLogin() {
        guard let email = emailTextField.text, password = passwordTextField.text else {
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if (error != nil) {
                print(error)
                return
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        })

    }
    
    func handleLoginRegister() {
        if (loginRegisterSegementedControl.selectedSegmentIndex == 0) {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLoginRegisterChanged() {
        let title = loginRegisterSegementedControl.titleForSegmentAtIndex(loginRegisterSegementedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        profileImage.hidden = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? true : false
        inputsContainerHeightAnchor?.constant = loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 100 : 150
        //nameTextField size changes
        nameTextFieldHeightAnchor?.active = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        emailTextFieldHeightAnchor?.active = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        passwordTextFieldHeightAnchor?.active = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegementedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.17, green: 0.05, blue: 0.00, alpha: 1.0)
        
        
        view.addSubview(profileImage)
        view.addSubview(loginRegisterSegementedControl)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(errorDisplayLabel)
        
        
        setupInputsContainerView()
        setUpLoginRegisterButton()
        setUpProfileImageView()
        setUpLoginRegisterSegmentedControl()
        setUpErrorDisplayLabel()
        
        }
    
    func setUpErrorDisplayLabel() {
        errorDisplayLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        errorDisplayLabel.topAnchor.constraintEqualToAnchor(loginRegisterButton.bottomAnchor, constant: 12).active = true
        errorDisplayLabel.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        errorDisplayLabel.heightAnchor.constraintEqualToConstant(60).active = true
    }
    
    func setUpLoginRegisterSegmentedControl() {
        loginRegisterSegementedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegementedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
        loginRegisterSegementedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterSegementedControl.heightAnchor.constraintEqualToConstant(40).active = true
    }
    
    func setUpProfileImageView() {
        profileImage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImage.bottomAnchor.constraintEqualToAnchor(loginRegisterSegementedControl.topAnchor, constant: -12).active = true
        profileImage.widthAnchor.constraintEqualToConstant(150).active = true
        profileImage.heightAnchor.constraintEqualToConstant(150).active = true
        
    }
    
    func setUpLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    var inputsContainerHeightAnchor:NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    
    func setupInputsContainerView() {
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputsContainerHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputsContainerHeightAnchor?.active = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        nameSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeperatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        emailSeperatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeperatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeperatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeperatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.active = true

    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

   

}
