from flask import Blueprint, request, jsonify
from utils import get_db_connection


event_bp = Blueprint('event', __name__, url_prefix='/event')

@event_bp.route('/posts')
def list_posts():
    return 'List of blog posts'

@event_bp.route('/posts/<int:post_id>')
def get_post(post_id):
    return f'Blog post with ID {post_id}'