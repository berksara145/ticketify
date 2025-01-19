from flask import request, jsonify
from flask_jwt_extended import verify_jwt_in_request, jwt_required, get_jwt_identity

# Middleware function to check access token
def check_access_token():
    # Exclude endpoints that do not require authentication
    excluded_endpoints = ['/login', '/register']  # Add more endpoints if needed

    # Check if the requested endpoint requires authentication
    if request.endpoint and request.endpoint not in excluded_endpoints:
        token = request.headers.get('Authorization')
        print(f"Authorization Token: {token}")
        # Verify access token in the request headers
        verify_jwt_in_request()


def expired_token_callback(jwt_header, jwt_payload):
    return jsonify({'message': 'Token has expired'}), 401

def invalid_token_callback(error):
    # Print the token that caused the error
    token = request.headers.get('Authorization')
    print(f"Invalid token received: {token}")  # This will print the token value
    print(f"Invalid token error: {error}")
    return jsonify({'message': 'Invalid token'}), 401

def unauthorized_callback(error):
    return jsonify({'message': 'Unauthorized access'}), 401

def needs_fresh_token_callback(jwt_header, jwt_payload):
    return jsonify({'message': 'Token is not fresh'}), 401

def revoked_token_callback(jwt_header, jwt_payload):
    return jsonify({'message': 'Token has been revoked'}), 401