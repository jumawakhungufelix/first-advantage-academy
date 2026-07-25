"""
db_manager.py

Handles SQLite database connection and creates all required tables.
"""

import sqlite3


class HospitalDB:
    """Handles all database operations."""

    def __init__(self, db_name="hospital.db"):
        self.db_name = db_name
        self.create_tables()

    def connect(self):
        """
        Creates and returns a database connection.
        """
        connection = sqlite3.connect(self.db_name)
        connection.row_factory = sqlite3.Row
        return connection

    def create_tables(self):
        """
        Creates all tables if they do not already exist.
        """

        with self.connect() as conn:
            cursor = conn.cursor()

            cursor.executescript("""

            CREATE TABLE IF NOT EXISTS patients(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                age INTEGER,
                dob TEXT,
                phone TEXT,
                blood_type TEXT,
                ward TEXT
            );

            CREATE TABLE IF NOT EXISTS doctors(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                age INTEGER,
                phone TEXT,
                specialization TEXT,
                department TEXT
            );

            CREATE TABLE IF NOT EXISTS nurses(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                age INTEGER,
                phone TEXT,
                ward TEXT,
                shift TEXT
            );

            CREATE TABLE IF NOT EXISTS appointments(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                patient_id INTEGER,
                doctor_id INTEGER,
                appointment_date TEXT,
                appointment_time TEXT,
                reason TEXT,
                status TEXT DEFAULT 'Scheduled',

                FOREIGN KEY(patient_id) REFERENCES patients(id),
                FOREIGN KEY(doctor_id) REFERENCES doctors(id)
            );

            CREATE TABLE IF NOT EXISTS bills(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                patient_id INTEGER,
                consultation_fee REAL,
                medicine_fee REAL,
                other_fee REAL,
                total REAL,
                payment_status TEXT,

                FOREIGN KEY(patient_id) REFERENCES patients(id)
            );

            CREATE TABLE IF NOT EXISTS wards(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ward_name TEXT,
                capacity INTEGER,
                occupied INTEGER DEFAULT 0
            );

            """)

            conn.commit()