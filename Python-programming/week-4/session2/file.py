import sqlite3
from datetime import datetime


class HospitalDB:
    def __init__(self, db="hospital.db"):
        self.db = db
        self._init()

    def _conn(self):
        c = sqlite3.connect(self.db)
        c.row_factory = sqlite3.Row
        return c

    def _init(self):
        with self._conn() as c:
            c.executescript("""
                CREATE TABLE IF NOT EXISTS patients (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    dob TEXT,
                    phone TEXT,
                    blood_type TEXT,
                    ward TEXT
                );

                CREATE TABLE IF NOT EXISTS doctors (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    specialisation TEXT,
                    department TEXT
                );

                CREATE TABLE IF NOT EXISTS appointments (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    patient_id INTEGER REFERENCES patients(id),
                    doctor_id INTEGER REFERENCES doctors(id),
                    date TEXT,
                    time TEXT,
                    reason TEXT,
                    status TEXT DEFAULT 'Scheduled'
                );
            """)

    def add_patient(self, name, dob, phone, blood_type, ward):
        try:
            with self._conn() as c:
                c.execute(
                    "INSERT INTO patients VALUES (NULL,?,?,?,?,?)",
                    (name, dob, phone, blood_type, ward)
                )
            print(f"✓ Patient {name} registered.")
        except Exception as e:
            print(f"✗ Error: {e}")
            
    def view_patients(self):
        with self._conn() as c:
            rows = c.execute('SELECT * FROM patients ORDER BY name').fetchall()
        print(f'\n  {"ID":>4}  {"Name":<22} {"Blood":>6} {"Ward":<12} {"Phone"}')
        print('  ' + '-'*62)
        for r in rows:
            print(f'  {r["id"]:>4}  {r["name"]:<22} {r["blood_type"]:>6} {r["ward"]:<12} {r["phone"]}')
        print(f'  Total: {len(rows)} patient(s)')

    def book_appointment(self, patient_id, doctor_id, date, time, reason):
        with self._conn() as c:
            c.execute('INSERT INTO appointments VALUES (NULL,?,?,?,?,?,"Scheduled")',
                      (patient_id, doctor_id, date, time, reason))
        print(f'  ✓ Appointment booked for {date} at {time}')

# ─── MAIN MENU ─────────────────────────────────────────────
hms = HospitalDB()
while True:
    print('\n====== HOSPITAL MANAGEMENT SYSTEM ======')
    print('1. Register Patient  2. View Patients')
    print('3. Add Doctor        4. Book Appointment')
    print('5. View Appointments 6. Billing  7. Exit')
    ch = input('Select: ')
    if   ch=='1': hms.add_patient(input('Name: '),input('DOB: '),input('Phone: '),input('Blood: '),input('Ward: '))
    elif ch=='2': hms.view_patients()
    elif ch=='7': print('Goodbye!'); break
            
            
            
