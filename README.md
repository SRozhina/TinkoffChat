# TinkoffChat

This is a project I've made in Fintech school by Tinkoff.

As result I have a chat with 5 screens: Conversations List, Conversation, Profile, Edit Profile, Load Avatar Image.

There were 12 lectures and 12 homeworks:

1. Xcode. Project structure and application and UIViewController lifecycle.

2. Base UI Elements - Simple view for Profile with possibility to select user avatar from Photos app.

3. UITableView and UINavigationController - UITableView for Conversations List with different conversations states: Online, Offline, Has unread messages. Conversations List has UIBarButtonItem for Profile view. UITableVIew for Conversation with incoming and outgoing messages cells.

4. Memory management - Homework with classes and dependencies in Homework 4 folder in project's root

5. Multithreading - Edit Profile view with possibility to save profile data (avatar, name, info) to file in device and load from file using GCD and Operations. Also data validation and error handling implemented.

6. MultipeerConnectivity - Implement finding new Conversations using MultipeerConnectivity and possibility to send and receive messages in dialog (Without saving). Disable sending messages when user become offline.

7. CoreData - Implement conversations storage using CoreData.

8. NSFetchedResultsController - Refactor conversations storage and implement new storages using NSFetchedResultsController.

9. Application architectures - Split application on SOA layers.

10. Networking - Implement Loading Avatar Image screen with images from Internet resource with public API. Add possibility to select and save new avatar.

11. Animations - Animate user become online/offline in Conversation screen and add animation on pan gesture.

12. Testing - Implement unit tests for networking service for loading avatar images using mocks and stubs.
