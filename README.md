# Netflix-Clone

With this app you can get info about movies and TV series using The Move DB API as backend and data source.

The user can display media sorted based on categories: Trending Movies, Trending TV, Popular, Upcomoing and Top Rated.
There is a search option to search for any type of media and get the trailer video from YouTube.

If you want to try out and test this app, you need to create an account with TMDB and get your own API key: https://www.themoviedb.org
You need to get also your own API key for YouTube on your Google Developer Console.

Open the project with Xcode and create a new swift file in the main directory named ApiKeys.swift and create the following struct:\\struct ApiKeys 
{    
    static let API_KEY = "your API key"
    static let UTUBE_API_KEY = "Your API key"
}

Add SDWebImage as Package Dependency as this package is used to download the images from the backend. 

Replace the text _your API key_ with your own API Keys for TMDB and Google Developer Console.
Run the app and you can play around with it.

App main views

<img width="157" alt="image" src="https://github.com/GeorgyGanev/Netflix-Clone/assets/106162345/f8617a69-e9f9-4cd7-8077-f290ec3eea25">
<img width="157" alt="image" src="https://github.com/GeorgyGanev/Netflix-Clone/assets/106162345/d3444f40-ba14-45a8-ad0c-a1dcbf403ad6">
<img width="154" alt="image" src="https://github.com/GeorgyGanev/Netflix-Clone/assets/106162345/599233b5-c38c-4fdc-9865-2e1d4de3325d">



