
import mysql.connector

def get_db_connection():
    connection = mysql.connector.connect(
        host='db',
        user='root',
        password='password1212',
        database='cs353dbproject'
    )
    return connection