# Tripzi

Tripzi is an innovative travel app that helps users discover different locations and places with complete categories, rich photos, user tips, reviews and map locations and book flights to their desired destinations. Whether you're planning a trip or exploring nearby attractions, Tripzi offers a comprehensive travel experience.

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

## Screenshots

Click on the thumbnails to view full-size images:

<p float="left">
  <a href="https://github.com/user-attachments/assets/99c98332-a556-4f62-baaf-ad636d6455d1"><img src="https://github.com/user-attachments/assets/99c98332-a556-4f62-baaf-ad636d6455d1" width="200" /></a>
    <a href="https://github.com/user-attachments/assets/22fd4e8d-2010-481f-87f5-d7e83b8029ba"><img src="https://github.com/user-attachments/assets/22fd4e8d-2010-481f-87f5-d7e83b8029ba" width="200" /></a>
  <a href="https://github.com/user-attachments/assets/1702b55e-1a06-4ce4-8a18-34997d88a841"><img src="https://github.com/user-attachments/assets/1702b55e-1a06-4ce4-8a18-34997d88a841" width="200" /></a>
  <a href="https://github.com/user-attachments/assets/e6a39695-a8f3-43c1-b130-615074ed9ea1">
        <img src="https://github.com/user-attachments/assets/e6a39695-a8f3-43c1-b130-615074ed9ea1" width="200" height="374" />
    </a>
</p>

<p float="left">
    <a href="https://github.com/user-attachments/assets/c3f56253-43a7-42d3-974a-1bbbd120bf9d"><img src="https://github.com/user-attachments/assets/c3f56253-43a7-42d3-974a-1bbbd120bf9d" width="200" /></a>
    <a href="https://github.com/user-attachments/assets/90df7c98-7b06-4c44-b883-6d2f08e159ea"><img src="https://github.com/user-attachments/assets/90df7c98-7b06-4c44-b883-6d2f08e159ea" width="200" /></a>
<a href="https://github.com/user-attachments/assets/01cfabaa-47b4-4260-8a1c-d58a16c3f4ef">
    <img src="https://github.com/user-attachments/assets/01cfabaa-47b4-4260-8a1c-d58a16c3f4ef" width="200" />
</a>
  <a href="https://github.com/user-attachments/assets/7ca70472-126c-4b61-92e3-bd5fb4a5c41f"><img src="https://github.com/user-attachments/assets/7ca70472-126c-4b61-92e3-bd5fb4a5c41f" width="200" /></a>
</p>

<p float="left">
   <a href="https://github.com/user-attachments/assets/5cea030a-6e10-460a-a7a7-697f474ab5bf"><img src="https://github.com/user-attachments/assets/5cea030a-6e10-460a-a7a7-697f474ab5bf" width="200" /></a>
  <a href="https://github.com/user-attachments/assets/24df38fe-b7db-4d14-9ef6-9a2651c0b367"><img src="https://github.com/user-attachments/assets/24df38fe-b7db-4d14-9ef6-9a2651c0b367" width="200" /></a>
  <a href="https://github.com/user-attachments/assets/b085262e-c9d6-4ecd-801f-d8d41c669eeb"><img src="https://github.com/user-attachments/assets/b085262e-c9d6-4ecd-801f-d8d41c669eeb" width="200" /></a>
  <a href="https://github.com/user-attachments/assets/c32bd79e-ee46-44b6-9188-8e1517161032"><img src="https://github.com/user-attachments/assets/c32bd79e-ee46-44b6-9188-8e1517161032" width="200" /></a>
</p>

<p float="left">
  <a href="https://github.com/user-attachments/assets/6d75dcb1-374e-486a-9316-6fdd634eeba2"><img src="https://github.com/user-attachments/assets/6d75dcb1-374e-486a-9316-6fdd634eeba2" width="200" /></a>
    <a href="https://github.com/user-attachments/assets/ede64a1d-7a4f-4008-952b-7f080c648ef2"><img src="https://github.com/user-attachments/assets/ede64a1d-7a4f-4008-952b-7f080c648ef2" width="200" /></a>
      <a href="https://github.com/user-attachments/assets/9ec4e443-c678-4af7-9c60-e5fed65319c5"><img src="https://github.com/user-attachments/assets/9ec4e443-c678-4af7-9c60-e5fed65319c5" width="200" /></a>
</p>
