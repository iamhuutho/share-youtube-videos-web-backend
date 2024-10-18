# Project Name
Share Youtube Video Backend
## Introduction
This project is a web application that allows users to share YouTube videos and receive real-time notifications when new videos are shared by other users. The primary purpose of the application is to create a collaborative platform where users can discover and share video content effortlessly. 

### Key Features
- **User Registration and Login**: Users can create an account and log in to the application.
- **Sharing YouTube Videos**: Logged-in users can share their favorite YouTube videos with the community.
- **Viewing a List of Shared Videos**: Users can view a list of all videos shared by others, real-time interaction with the videos ( likes and dislikes ).
- **Real-time Notifications**: Users receive instant notifications when a new video is shared, enhancing community interaction.

## Prerequisites
Before you begin, ensure you have the following software installed:
- **Ruby**:
- **Rails**:
- **PostgreSQL**:

## Installation & Configuration
Follow these steps to set up the project on your local machine:

1. **Clone the repository**
   ```bash
   git clone 
   cd 
2. **Install dependencies**
    ```bash
   bundle install
3. **Set up the database**
    Please navigate to ./config/database.yml. Change `username` and `password` based on your local database configuration. Then follow these commands.
    ```bash
    rails db:create
    rails db:migrate
4. **Start the server ( localhost:3001 )**
    ```bash
    rails s
5. **Run unit test**
    ```bash
    bundle exec rspec ./spec/path
    ```
    Run all unit tests in a folder
    ```bash
    bundle exec rspec ./spec/controllers
    ```
    Run a specific file only
    ```bash
    bundle exec rspec ./spec/controllers/notification_controller_spec.rb
    ```
