# Recipe Application README

Welcome to the Recipe Application! This application allows users to search and save recipes. To use this app, you need to register via API first. Upon registration, you will receive a Bearer token that you can use to access the following endpoints:

## Endpoints

### 1. Search and Save Recipes

Use this endpoint to search for recipes and save your favorite ones.

- **Endpoint**: `/recipes/search_and_save`
- **HTTP Method**: GET

### 2. Get Recipes by IDs

Retrieve recipes by specifying their IDs using this endpoint.

- **Endpoint**: `/recipes/get_by_ids`
- **HTTP Method**: POST

### 3. Create a Rate

You can also create a rate for a recipe using this endpoint.

- **Endpoint**: `/rates`
- **HTTP Method**: POST

## Registration

To get started, you need to register as a user via the API. Once registered, you will receive your unique Bearer token.

## Using the Bearer Token

To access the above endpoints, you must include your Bearer token in the authorization headers of your API requests.

### Example Authorization Header:

Authorization: Bearer YOUR_BEARER_TOKEN_HERE


## Testing

For your convenience, we've provided a Postman collection with pre-configured requests for testing the API. You can import this collection into your Postman workspace.

Postman Collection: Viapath.postman_collection.json

## Daily Recipe Updates

Please note that daily recipe updates are managed by Sidekiq, a background job processing system. Sidekiq is responsible for updating recipes daily and retrieving recipe details. Ensure that Sidekiq is properly configured and running in your environment for these features to work.

## Getting Started

Register as a user via the API and obtain your Bearer token.

Include your Bearer token in the authorization headers of your API requests.

Start using the endpoints to search for and save recipes!