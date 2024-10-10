# JTribe: IITJ Help Desk App

An app based on Flutter and Firebase (for backend database management) that allows users belonging to IITJ Community to log in and post/answer to academic and non-academic queries.

## Built using:

- [Flutter: ](https://flutter.dev/docs/get-started/codelab) Flutter documentation
- [Dart: ](https://dart.dev/) Dart documentation
- [Google Cloud: ](https://console.cloud.google.com/) Google cloud console documentation
- [Google Firebase:](https://firebase.flutter.dev/docs/overview) Google firebase documentation
- [Google Firestore:](https://firebase.flutter.dev/docs/firestore/usage/) Google firestore documentation 
- [Google Firebase Storage:](https://firebase.google.com/docs/storage) Google firebase storage documentation

## Help Desk Application Features:
- Login/Logout
- Signin/Signup 
  - OTP verification via Email(Only valid iitj email will receive the OTP to signup thus ensuring only IITJ community gets the access to the app)
- Add/Post Query
    - Can select the category (Academic/Non-Academic)
    - Can opt to post anonymously
- Home page
    - Shows all the queries posted by users till now
    - Option to flag a query if inappropriate
    - Can upvote or downvote a query that indicates the number of users interested in knowing about that query
    - Option for answering or replying to the query 
    - Date when the query was posted is shown
    - All the answers to the query posted can also be seen

## Future features:
- Adding notification support when a query is answered for the user who posted the query
- Option to upvote/downvote the answers also which helps users understand the credibility of the answer
