# Tripzi

Tripzi is an innovative travel app that helps users discover a variety of locations and places, complete with categories, rich photos, user tips, reviews, and map locations. Whether you're planning a trip or exploring nearby attractions, Tripzi offers a comprehensive travel experience.

## Features

### Location and Places
- **Explore Nearby Places**: Allow the app to use your location to explore nearby places.
- **Categories and Rich Photos**: Discover places categorized for easy navigation, each accompanied by high-quality images.
- **User Tips and Reviews**: Get insights from other travelers through tips and reviews.
- **Place Location with Map**: View locations on a map using CoreLocation and MapKit.

### Flights
- **Global Flight Suggestions**: Find airline flights from all over the world by entering your departure location, destination, and travel dates.
- **Flight Details and Booking**: View detailed flight information.

### Payment
- **Secure Payments**: Purchase tickets using Apple Pay or card payment (via Stripe).
- **Stripe Integration**: Ensures secure and seamless transactions for your flight bookings.

### Authentication
- **Login Options**: Sign up or log in using Facebook, Google, or email. Reset your password if needed.
- **Personal Information**: View your personal information fetched from Firebase Firestore.

### Favorites
- **Add to Favorites**: Save places to your favorites, which are also stored in Firebase Firestore.

### Search
- **Search Places**: Enter a place name or coordinates (longitude and latitude) to find nearby locations.
- **Radius Search**: Define a search radius to fetch places within a specified distance (e.g., 20,000 meters for 20 km).

### Profile Management
- **Upload Profile Image**: Upload and save your profile image in Firebase Storage.
- **Edit Personal Info**: Update your personal information as needed.
  
### Dark/Ligth mode

## Technologies Used
- **SwiftUI**: For building the user interface.
- **UIKit**: For some parts of the app to ensure optimal performance.
- **CoreLocation and MapKit**: For location-based services and map integration.
- **Firebase**: For authentication, Firestore database, and storage.
- **Stripe**: For secure payment processing.
- **Foursquare Places API**: For fetching place details.
- **Amadeus Flights API**: For fetching flight information.

## Usage

1. **Login**: Log in using Facebook, Google, or sign up with email.

2. **Explore**: Allow the app to use your location and start exploring nearby places.

3. **Search**: Use the search functionality to find specific places or explore areas within a certain radius.

   - Enter a place name or coordinates (longitude and latitude) to find nearby locations.
   - Define a search radius to fetch places within a specified distance (e.g., 20,000 meters for 20 km).

4. **Flights**: Enter your travel details to find and book flights.

5. **Favorites**: Add places to your favorites for easy access later.

6. **Profile**: Upload a profile image and update your personal information.


## Getting Started

### Prerequisites
- Xcode 12 or later
- iOS 14.0 or later

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/irinkadat/tripzi.git
    ```
2. Open the project in Xcode :
   ```
   cd tripzi
   
   open Tripzi.xcodepro
   ```
3. Install dependencies:
   ```
   pod install
   ```
4. Set up Firebase:
- Follow the instructions to add your GoogleService-Info.plist file to the project.

5. Set up Stripe:
- Add your Stripe API keys to the project configuration.


