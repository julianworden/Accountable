# Rep Buddy
Accountable is a productivity tracking app built with SwiftUI, Swift Charts, AWS Amplify, WidgetKit, and StoreKit that features Lock Screen and Home Screen Widgets.

<p align="center">
    <img src="https://github.com/julianworden/Accountable/blob/main/READMEImages/HomeView.png" width=30% height=30%> <img src="https://github.com/julianworden/Accountable/blob/main/READMEImages/ProjectDetailsView.png" width=30% height=30%>
</p>

<p align="center">
    <img src="https://github.com/julianworden/Accountable/blob/main/READMEImages/HomeScreenWidgets.png" width=25% height=25%>
</p>

## On The Surface
Here's how Accountable works: To start, the user creates a project that represents a skill they want to learn. Then, every time the user wants to work on this skill, they can start a session. Starting a session will start a stopwatch that will run until the user ends the session. Once the session is ended, it will be saved alongside its project and shown within various charts and work analytics throughout the app. The user can also help themselves stay motiviated to work towards their goal by adding Accountable's Home Screen and Lock Screen Widgets to their phone.

## Under the Hood
Accountable was built with:

- Swift and SwiftUI
- MVVM architecture
- AWS Amplify for database and user management
- WidgetKit for Lock Screen and Home Screen Widgets
- The Swift Charts API for all charts
- StoreKit for managing the Accountable Premium in-app purchase

## Notes
- In order to run this app on your system, you'll need to connect it to your own Amplify backend. To do this, you'll need to install the Amplify CLI with the instructions here: https://docs.amplify.aws/cli/start/install/
    - After installing the Amplify CLI, use these instructions to clone this project onto your system: https://docs.amplify.aws/cli/start/workflows/#clone-sample-amplify-project
