# Project 5 - *BeReal Clone*

Submitted by: **Leonardo Villalobos**

**BeReal Clone** is a clone of the app BeReal. It allows users to signup, login,
and upload posts from their camera roll.

Time spent: **3** hours spent in total

## Required Features

The following **required** functionality is completed:

- [X] User can register a new account
- [X] User can log in with newly created account
- [X] App has a feed of posts when user logs in
- [X] User can upload a new post which takes in a picture from photo library and a caption	
 
The following **optional** features are implemented:

- [X] User stays logged in when app is closed and open again

The following **additional** features are implemented:

- [X] User is able to see errors when logging in with incorrect credentials
- [X] Errors are shown within the view instead of an alert
- [X] UIActivityIndicatorViews are used to show something is happening in the background

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](assets/images/demo.gif)

GIF created with XCode Simulator screen recording tool

## Notes

I had trouble hiding the login error label that shows up when entering incorrect credentials,
and figured out that it was because the code that executed after the `.success(_)` arm from the
`switch` had to be exectued on the main thread. I was trying to perform some visual effects in the
`.success(_)` arm, but none of it was showing up. The solution was to execute the call to
`NotificationCenter.default.post(name:object)` in the main thread.

## License

    Copyright 2023 Leonardo Villalobos

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.