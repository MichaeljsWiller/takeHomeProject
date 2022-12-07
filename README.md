# takeHomeProject
Tech Test Take home project that makes use of the Pixabay API to allow users to search for photos and videos

## Architecture

The architecture I chose to go with was MVVM-C.
As I also decided to build out the apps UI using UIkit I chose MVVM-C as it allows for testability by seperating concerns of view logic and business logic into viewModels. And also seperates navigation logic from the view logic with use of the coordinator.

Within my architecture I also made use of dependecy injection along with a protcol oriented approach in order to increase the testablity of my classes by allowing the creation of mocks and passing them into the concrete object when testing

## Current Issues and Limitations

1. **Videos no longer play**

-   This is due to a change within the API, mainly the source of where they provide their videos from. When creating this project (in 2021) the API wasn't as popular as it is now and stored the videos o their own server meaning that usig AVPlayer you was able to stream the video using the url provided. Now they have updated this and their videos are from vimeo which does not allow for streaming within the app (similar to how you are unable to stream a youtube link)

### Solution

There isn't particularly a solution to this but I kept the logic in the app so that you can see how the app was meant to work and also my knowledge with AVFoundation and AVPlayer.

2. **Lack of consistency with how unit tests are written.**

-   You will probably notice that the way unit tests are written for the `CacheManager` and for the `SearchViewModel` are quite different. This is due to the unit tests for the `CacheManager` being written when I first created this project and the tests for the `SearchViewModel` being written a fews days ago. As there has been a year between writing both tests I have been able to grown as a developer and write cleaner unit tests. I decided not to update the `CacheManager` unit tests in order to show my growth within the year and how as time passes I always strive to improve as a developer. The most recent tests I decided to write using a BDD testing approach and also made use of stubs for mocking.

3. **Error Handling**

-   If i was to spend more time on this I would handle errors returned from the api and display an alert to the user when an error occurs. I have done this in some places but in particularly for the `APIManager` the main network call can fail silently by returning nil which is not a good practice.

4. **UI Polish**

-   Also I would of focused on the UI more, as currently the UI is extremely simple.

5. **Third Party Frameworks**

-   I didnt use any third party frameworks. Mainly because it is quite a small project.
    If i was to go back and add one though, the main one I would add would be `SwiftLint`. As even now I am nervous submitting this without a linter.
    I am sure i've made a lot of silly mistakes (I'm praying I haven't lol), but I'd have peace of mind if I implemented this framework.
