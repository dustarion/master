# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Master' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Master
  
  # Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  
  # Google
  pod 'GoogleSignIn'
  
  # Facebook
  pod 'Bolts'
  pod 'FBSDKCoreKit', '~> 4.38.0' # Apparently there is a bug on the FBSDKCoreKit and FBSDKLoginKit and the solution seems to be to downgrade to 4.38.0
  pod 'FBSDKLoginKit', '~> 4.38.0' # Apparently there is a bug on the FBSDKCoreKit and FBSDKLoginKit and the solution seems to be to downgrade to 4.38.0

  # Transitions
  pod 'Hero'
  
  # Notifications
  pod 'SwiftMessages'
  pod 'BulletinBoard'
  
  # Tableview Animations
  pod 'SwipeCellKit'
  
  
  # Others


  target 'MasterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MasterUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
