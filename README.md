# Customer Invite API

This Rails API allows uploading a JSON lines file of customers and returns those within **100 km distance from Mumbai office location**. It returns customers sorted by User ID in ascending order. It includes API key authentication and rate limiting.

## Features

- Upload a JSON lines file (`.txt` or `.json`) with customer data.  
- Filters customers using a **bounding box optimization** and accurate **Haversine distance**.  
- Supports **API key authentication** via `X-API-KEY` header.  
- Rate limited: **100 requests per minute per user**.  
- Swagger API documentation included

## Prerequisites

- Ruby 3.x
- Rails 6.x or 7.x
- Redis (for rate limiting)
- MySQL

## Installation and Starting Server

```bash
git clone https://github.com/SouradeepDutta18/CUSTOMER_INVITE_API
cd CUSTOMER_INVITE_API
bundle install
rails db:create 
rails db:migrate
rails db:seed
rails s
```

## For Testing

```bash
rake db:test:prepare
rspec spec
```

## For API Documentation
- hit http://localhost:3000/api/v1/docs/api_docs endpoint
- paste the JSON response of the endpoint in https://editor.swagger.io/