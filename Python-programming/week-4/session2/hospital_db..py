import sqlite3
from datetime import datetime

class HospitalDB:
    def __init__ (self, db = 'hospital.db'):
        self.db =db
        self._init()
        
    def _conn(self):
        c = sqlite3.connect(self.db)
        c.row_factory = sqlite3.Row
        
        return c
    def _init(self):
        with self._conn() as c:
            c.executescript(
                """
                CREATE TABLE IF NOT EXISTS patients(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    NAME TEXT NOT NULL,
                    dob TEXT,
                    phone TEXT,
                    blood_type TEXT,
                    ward TEXT
                );
                CREATE TABLE IF NOT EXISTS doctors(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    nmae TEXT NOT NULL,
                    specialisation TEXT,
                    department TEXT
                );
                CREATE TABLE IF NOT EXISTS nurse(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL
                    department TEXT
                    
                )
                CREATE TABLE IF NOT EXISTS appointments(
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    patient_id INTEGER REFERENCES patients(id),
                    date TEXT,
                    time TEXT,
                    reason TEXT,
                    status TEXT DEFAULT 'scheduled'
                )
                """
            )
            
        