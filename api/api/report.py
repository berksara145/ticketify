from flask import Blueprint, request, jsonify
from datetime import datetime
from utils import get_db_connection

report_bp = Blueprint('report', __name__, url_prefix='/report')


from flask_jwt_extended import get_jwt_identity

@report_bp.route('/createReport', methods=['POST'])
def create_report():   
    
    return jsonify({}), 200