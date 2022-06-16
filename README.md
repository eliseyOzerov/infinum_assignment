# Test assignment for Infinum

The following is the feedback I was sent by their team after I've completed the assignment. The assignment took me about 20 hours, with most of the time spent designing the architecture of the project.

PROS
- “Remember me” storage is done securely. But there is no in-memory token persistence, so every request needs to fetch token from keychain on every request which is slow compared to memory read.
- Layers are separated nicely into controllers and services.
- The are tests written for controllers. The test could be made better with usage of Mockito and mocking different kinds of Api responses.
- On the UI everything is functional and work as expected, except for a small issue with status bar and collapsing app bar. 
- Very nice git history

CONS
- Token injection in header could be done better. With this setup every request (but login) needs to read data from keychain and send it to the client. The idea is to have one Dio instance injected in all services and used for all requests and interceptor is set there for whole app. Here dio is created for every request and header token is added every time.
- I agree that controller shouldn’t depend on BuildContext, as it’s written in the comments. At the same time  the controller depends on flutter/material because of TextEditingControllers. On a same topic, the controllers do have a dependency on router which has a dependency on the BuildContext. This is problematic, as having BuildContext as a field in non-widget classes is tricky, since that class can outlive the widget and still hold the reference to context leading to all kind of tricky to solve problems.
- Empty initial screen is not necessary. You can do the check before the runApp, which is better since the splash would continue. Here screen will be blank for split-second.
- List of shows and list of episodes don’t have error or loading states of network request. Login does have it but it does not differentiate between errors. So entering wrong password or having no internet will result in same “Login failed”, but the message could be more specific.
- Dart convention says that files and directories should use snake_case. Here they are PascalCase, and test files are in camelCase/snake_case combination.
- DependencyInjector looks to be singleton, but it’s not. It’s instantiated multiple times. This injector injects controllers into the screens. But other layers are not really injected, they are all singletons or created when needed.
- ListOfShowsScreenController shouldn’t be checking if token is available. The way it’s done in the app, a lot of controllers (including ones that were not in scope) would need to add this same check for every request. Returning null is misleading as it says there is no data, while there is data.
