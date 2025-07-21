
import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    String token;
    int userId;
    String email;

    Welcome({
        required this.token,
        required this.userId,
        required this.email,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        token: json["token"],
        userId: json["user_id"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user_id": userId,
        "email": email,
    };
}









// // API URL: http://192.168.1.5:8000/api/

// Admin Credentials:
//     Email:admin001@gmail.com
//     username:admin001
//     Password:Password@123

// User Credentials:
//     Email:user001@gmail.com
//     username:user001
//     Phone Number:+1234567890
//     Password:Password@123


// Admin Login

// POST /admin-login/
// Content-Type: application/json

// Request Body:
// {
//     "email": "admin@example.com",
//     "password": "adminpassword"
// }

// Response (200 OK):
// {
//     "token": "9944b09199c62bcf9418ad846dd0e4bbdfc6ee4b",
//     "user_id": 1,
//     "email": "admin@example.com"
// }

// // ==============================================================================================

// Admin Logout

// POST /logout/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// {
//     "message": "Successfully logged out"
// }

// // ==============================================================================================


// Create Banner

// POST /banners/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "image": <file>,
//     "status": true
// }

// Response (201 Created):
// {
//     "id": 1,
//     "image": "http://example.com/media/banners/image.jpg",
//     "status": true
// }


// // ==============================================================================================


// Update Banner

// PUT/PATCH /banners/{id}/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "image": <file>,
//     "status": false
// }

// Response (200 OK):
// {
//     "id": 1,
//     "image": "http://example.com/media/banners/image.jpg",
//     "status": false
// }


// ==============================================================================================


// Delete Banner

// DELETE /banners/{id}/
// Headers: 
//     Authorization: Token <your-token>

// Response (204 No Content):
// {
//     "message": "Banner deleted successfully"
// }

// ==============================================================================================

// Create Grocery

// POST /grocery/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "title": "Grocery",
//     "image": <file>
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Grocery",
//     "image": "http://example.com/media/grocery/categories/veg.jpg",
//     "categories": []
// }

// ==============================================================================================

// Create Grocery Category

// POST /grocery-categories/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "title": "Vegetables",
//     "image": <file>,
//     "grocery": 1
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Vegetables",
//     "image": "http://example.com/media/grocery/categories/veg.jpg",
//     "grocery": 1,
//     "products": []
// }


// ==============================================================================================


// Create Grocery Product

// POST /grocery-products/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "title": "Tomatoes",
//     "image": <file>,
//     "amount": "2.99",
//     "offer_amount": "1.99",
//     "description": "Fresh farm tomatoes",
//     "category": 1
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Tomatoes",
//     "image": "http://example.com/media/grocery/products/tomatoes.jpg",
//     "amount": "2.99",
//     "offer_amount": "1.99",
//     "description": "Fresh farm tomatoes",
//     "category": 1
// }

// ==============================================================================================


// Create Food Category

// POST /food/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "title": "Fast Food"
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Fast Food",
//     "items": []
// }

// ==============================================================================================


// Create Food Item

// POST /food-items/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "title": "Chicken Burger",
//     "image": <file>,
//     "description": "Juicy chicken burger with fresh vegetables",
//     "amount": "8.99",
//     "offer_amount": "7.99",
//     "food": 1
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Chicken Burger",
//     "image": "http://example.com/media/food/items/burger.jpg",
//     "description": "Juicy chicken burger with fresh vegetables",
//     "amount": "8.99",
//     "offer_amount": "7.99",
//     "food": 1
// }


// ==============================================================================================


// Create Service Category

// POST /services/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "title": "Home Maintenance"
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Home Maintenance",
//     "provided_services": []
// }
    

// ==============================================================================================


// Create Service Item

// POST /services-provided/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: multipart/form-data

// Request Body:
// {
//     "title": "Plumbing Service",
//     "image": <file>,
//     "description": "Professional plumbing services",
//     "service": 1
// }

// Response (201 Created):
// {
//     "id": 1,
//     "title": "Plumbing Service",
//     "image": "http://example.com/media/services/plumbing.jpg",
//     "description": "Professional plumbing services",
//     "service": 1
// }

// ==============================================================================================


// Update Order Status

// PATCH /grocery-orders/{id}/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "status": "ACCEPTED"
// }

// Response (200 OK):
// {
//     "id": 1,
//     "status": "ACCEPTED",
//     ...
// }

// ------------------------------------------------------------------------------------------------
// Similar endpoints are available for:

// - Food Orders: `PATCH /food-orders/{id}/`

// - Service Orders: `PATCH /service-orders/{id}/`

// ------------------------------------------------------------------------------------------------



// ==============================================================================================


// List All Orders (Admin Only)

// GET /grocery-orders/
// GET /food-orders/
// GET /service-orders/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "user": {
//             "id": 1,
//             "email": "user@example.com"
//         },
//         "full_name": "John Doe",
//         "phone_number": "+1234567890",
//         "address": "123 Street",
//         "landmark": "Near Park",
//         "status": "PENDING",
//         "created_at": "2024-03-14T12:00:00Z",
//         "cart_items": [...]
//     }
// ]

// ------------------------------------------------------------------------------------------------
// ==============================================================================================
// ------------------------------------------------------------------------------------------------
// ==============================================================================================
// ------------------------------------------------------------------------------------------------




// Register User request OTP

// POST /register-request-otp/
// Content-Type: application/json

// Request Body:
// {
//     "email": "user003@example.com",
//     "phone_number": "8078225107",
//     "username": "newuser003"
// }

// Response (200 OK):
// {
//     "message": "OTP sent successfully"
// }
// ==============================================================================================


// Register User verify OTP

// POST /register-verify-otp/
// Content-Type: application/json

// Request Body:
// {
//     "phone_number": "8521445415",
//     "otp": "123456"
// }

// Response (200 OK):
// {
//     "message": "OTP verified successfully"
// }

// ==============================================================================================



// Login (Request OTP)

// POST /request-otp/
// Content-Type: application/json

// Request Body:
// {
//     "phone_number": "+1234567890"
// }

// Response (200 OK):
// {
//     "message": "OTP sent successfully"
// }

// ==============================================================================================


// Login (Verify OTP)

// POST /verify-otp/
// Content-Type: application/json

// Request Body:
// {
//     "phone_number": "+1234567890",
//     "otp": "123456"
// }

// Response (200 OK):
// {
//     "token": "4ead3a5eabfa62b5bdb0ac63ea6bc6ad48439db9",
//     "user_id": 2,
//     "phone_number": "+1234567890"
// }

// ==============================================================================================


// Logout

// POST /logout/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// {
//     "message": "Successfully logged out"
// }

// // ==============================================================================================



// List Banners

// GET /banners/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "image": "http://example.com/media/banners/image.jpg",
//         "status": true
//     }
// ]

// // ==============================================================================================


// List Groceries

// GET /grocery/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "title": "Grocery Store",
//         "categories": [
//             {
//                 "id": 1,
//                 "title": "Fruits",
//                 "image": "http://example.com/media/grocery/categories/fruits.jpg",
//                 "products": [
//                     {
//                         "id": 1,
//                         "title": "Apple",
//                         "image": "http://example.com/media/grocery/products/apple.jpg",
//                         "amount": "2.99",
//                         "offer_image": null,
//                         "description": "Fresh apples"
//                     }
//                 ]
//             }
//         ]
//     }
// ]

// // ==============================================================================================


// List Food Items

// GET /food/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "title": "Restaurant",
//         "items": [
//             {
//                 "id": 1,
//                 "title": "Burger",
//                 "image": "http://example.com/media/food/items/burger.jpg",
//                 "description": "Delicious burger",
//                 "amount": "9.99",
//                 "offer_amount": null
//             }
//         ]
//     }
// ]

// ==============================================================================================



// List Services

// GET /services/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "title": "Home Services",
//         "provided_services": [
//             {
//                 "id": 1,
//                 "title": "Cleaning",
//                 "image": "http://example.com/media/services/cleaning.jpg",
//                 "description": "Professional cleaning service"
//             }
//         ]
//     }
// ]

// // ==============================================================================================


// List Cart Items

// GET /grocery-cart/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "user": 1,
//         "product": 1,
//         "quantity": 2
//     }
// ]

// // ==============================================================================================



// Add to Cart

// POST /grocery-cart/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "product": 1,
//     "quantity": 2
// }


// ------------------------------------------------------------------------------------------------
// Similar endpoints available for food cart at `/food-cart/`
// {
//     "user": 1, 
//     "food_item": 2,  
//     "quantity": 3 
// }
// ------------------------------------------------------------------------------------------------

// ==============================================================================================




// Create Order

// POST /grocery-orders/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "full_name": "John Doe",
//     "phone_number": "+1234567890",
//     "address": "123 Street",
//     "landmark": "Near Park",
//     "cart_items": [1, 2]
// }

// Response (201 Created):
// {
//     "id": 1,
//     "status": "PENDING",
//     "created_at": "2024-03-14T12:00:00Z",
//     ...
// }

// // ==============================================================================================



// List Orders

// GET /grocery-orders/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "status": "PENDING",
//         "created_at": "2024-03-14T12:00:00Z",
//         ...
//     }
// ]

// // ------------------------------------------------------------------------------------------------
// - Food Orders: `/food-orders/`
// // ==============================================================================================
// Create Food Pre-Order Cart

// POST /preorder-food-cart/

// Headers: 
//     Authorization: Token <your-token>,
//     Content-Type: application/json

// Request Body:

// {
//     "food_item": 1, 
//     "quantity": 2
// }

// Response :

// {
//     "id": 1,
//     "food_item": 1,
//     "food_item_details": {
//         "id": 1,
//         "title": "Pizza",
//         "image": "url_to_image",
//         "description": "Delicious cheese pizza",
//         "amount": "10.00",
//         "offer_amount": null
//     },
//     "quantity": 2,
//     "user": 1
// }
// // ==============================================================================================
// List Food Pre-Order Cart

// GET /preorder-food-cart/
// Headers: 
//     Authorization: Token <your-token>

// Response:
// [
//     {
//         "id": 5,
//         "food_item": 2,
//         "food_item_details": {
//             "id": 2,
//             "title": "Chicken Burger",
//             "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_H2VpqlQ.png",
//             "description": "Spicy Chicken burger",
//             "amount": "8.99",
//             "offer_amount": "7.99",
//             "food": 2
//         },
//         "quantity": 30,
//         "user": 2
//     }
// ]

// // ==============================================================================================


// Create PreOrderFoodOrder

// POST /preorder-food-orders/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:

// {
//     "cart_items": [1, 2],  // List of PreOrderFoodCart IDs
//     "full_name": "John Doe",
//     "phone_number": "1234567890",
//     "address": "123 Main St",
//     "landmark": "Near Park",
//     "delivery_date": "2023-12-31",
//     "pincode": "123456"
// }

// Response:
// {
//     "id": 1,
//     "full_name": "John Doe",
//     "phone_number": "1234567890",
//     "address": "123 Main St",
//     "landmark": "Near Park",
//     "status": "PENDING",
//     "created_at": "2023-11-01T12:00:00Z",
//     "total_amount": "20.00",  // Total amount calculated from cart items
//     "user": 1,
//     "order_items": [
//         {
//             "id": 1,
//             "food_item": 1,
//             "food_item_details": {
//                 "id": 1,
//                 "title": "Pizza",
//                 "image": "url_to_image",
//                 "description": "Delicious cheese pizza",
//                 "amount": "10.00",
//                 "offer_amount": null
//             },
//             "quantity": 2,
//             "total_amount": "20.00"
//         }
//     ],
//     "delivery_date": "2023-12-31",
//     "pincode": "123456"
// }

// // ==============================================================================================


// List Food Pre-Order orders

// GET /preorder-food-orders/
// Headers: 
//     Authorization: Token <your-token>

// Response:

// [
//     {
//         "id": 1,
//         "full_name": "John Doe",
//         "phone_number": "1234567890",
//         "address": "123 Main St",
//         "landmark": "Near Park",
//         "status": "PENDING",
//         "created_at": "2025-01-29T05:52:37.185691Z",
//         "total_amount": "47.94",
//         "user": 2,
//         "order_items": [
//             {
//                 "id": 1,
//                 "food_item": 2,
//                 "food_item_details": {
//                     "id": 2,
//                     "title": "Chicken Burger",
//                     "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_H2VpqlQ.png",
//                     "description": "Spicy Chicken burger",
//                     "amount": "8.99",
//                     "offer_amount": "7.99",
//                     "food": 2
//                 },
//                 "quantity": 3,
//                 "total_amount": 23.97
//             },
//             {
//                 "id": 2,
//                 "food_item": 1,
//                 "food_item_details": {
//                     "id": 1,
//                     "title": "Korean Chicken",
//                     "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_yDZVKuq.png",
//                     "description": "Spicy Chicken dish",
//                     "amount": "8.99",
//                     "offer_amount": "7.99",
//                     "food": 1
//                 },
//                 "quantity": 3,
//                 "total_amount": 23.97
//             }
//         ],
//         "delivery_date": "2023-12-31",
//         "pincode": "123456"
//     },
//     {
//         "id": 2,
//         "full_name": "John Doe",
//         "phone_number": "1234567890",
//         "address": "123 Main St",
//         "landmark": "Near Park",
//         "status": "ACCEPTED",
//         "created_at": "2025-01-29T07:24:59.822041Z",
//         "total_amount": "263.67",
//         "user": 2,
//         "order_items": [
//             {
//                 "id": 3,
//                 "food_item": 1,
//                 "food_item_details": {
//                     "id": 1,
//                     "title": "Korean Chicken",
//                     "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_yDZVKuq.png",
//                     "description": "Spicy Chicken dish",
//                     "amount": "8.99",
//                     "offer_amount": "7.99",
//                     "food": 1
//                 },
//                 "quantity": 3,
//                 "total_amount": 23.97
//             },
//             {
//                 "id": 4,
//                 "food_item": 2,
//                 "food_item_details": {
//                     "id": 2,
//                     "title": "Chicken Burger",
//                     "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_H2VpqlQ.png",
//                     "description": "Spicy Chicken burger",
//                     "amount": "8.99",
//                     "offer_amount": "7.99",
//                     "food": 2
//                 },
//                 "quantity": 30,
//                 "total_amount": 239.7
//             }
//         ],
//         "delivery_date": "2025-12-31",
//         "pincode": "123456"
//     }
// ]
// // ==============================================================================================

// Update Food Pre-Order Order

// PATCH /preorder-food-orders/{id}/
// Headers: 
//     Authorization: Token <your-token>,
//     Content-Type: application/json

// Request Body:
// {
//     "status": "ACCEPTED"
// }

// Response:
// {
//     "id": 2,
//     "full_name": "John Doe",
//     "phone_number": "1234567890",
//     "address": "123 Main St",
//     "landmark": "Near Park",
//     "status": "ACCEPTED",
//     "created_at": "2025-01-29T07:24:59.822041Z",
//     "total_amount": "263.67",
//     "user": 2,
//     "order_items": [
//         {
//             "id": 3,
//             "food_item": 1,
//             "food_item_details": {
//                 "id": 1,
//                 "title": "Korean Chicken",
//                 "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_yDZVKuq.png",
//                 "description": "Spicy Chicken dish",
//                 "amount": "8.99",
//                 "offer_amount": "7.99",
//                 "food": 1
//             },
//             "quantity": 3,
//             "total_amount": 23.97
//         },
//         {
//             "id": 4,
//             "food_item": 2,
//             "food_item_details": {
//                 "id": 2,
//                 "title": "Chicken Burger",
//                 "image": "http://127.0.0.1:8000/food/items/Screenshot_2025-01-17_171403_H2VpqlQ.png",
//                 "description": "Spicy Chicken burger",
//                 "amount": "8.99",
//                 "offer_amount": "7.99",
//                 "food": 2
//             },
//             "quantity": 30,
//             "total_amount": 239.7
//         }
//     ],
//     "delivery_date": "2025-12-31",
//     "pincode": "123456"
// }

// // ==============================================================================================


// List Service Orders

// GET /service-orders/
// Headers: 
//     Authorization: Token <your-token>

// Response (200 OK):
// [
//     {
//         "id": 1,
//         "full_name": "John Doe",
//         "phone_number": "+1234567890",
//         "address": "123 Main St",
//         "landmark": "Near Park",
//         "status": "PENDING",
//         "created_at": "2024-03-21T10:00:00Z",
//         "total_amount": "0.00",
//         "user": 1,
//         "services": [1, 2]
//     }
// ]


// Create Service Order

// POST /service-orders/
// Headers: 
//     Authorization: Token <your-token>
// Content-Type: application/json

// Request Body:
// {
//     "full_name": "John Doe",
//     "phone_number": "+1234567890",
//     "address": "123 Main St",
//     "landmark": "Near Park",
//     "services": [1, 2]  // Array of service IDs
// }


// // ------------------------------------------------------------------------------------------------

// // ==============================================================================================