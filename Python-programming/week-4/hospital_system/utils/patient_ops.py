"""
patient_ops.py

Contains all patient-related database operations.
"""

from utils.db_manager import HospitalDB


class PatientOperations:
    """Handles CRUD operations for patients."""

    def __init__(self):
        self.db = HospitalDB()

    def add_patient(self, name, age, dob, phone, blood_type, ward):
        """Add a new patient."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO patients
                    (name, age, dob, phone, blood_type, ward)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (name, age, dob, phone, blood_type, ward))

                conn.commit()

            print(f"\nPatient '{name}' registered successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def view_patients(self):
        """Display all patients."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("SELECT * FROM patients ORDER BY name")

                patients = cursor.fetchall()

                if not patients:
                    print("\nNo patients found.")
                    return

                print("\n====== PATIENT LIST ======\n")

                for patient in patients:
                    print(f"ID          : {patient['id']}")
                    print(f"Name        : {patient['name']}")
                    print(f"Age         : {patient['age']}")
                    print(f"DOB         : {patient['dob']}")
                    print(f"Phone       : {patient['phone']}")
                    print(f"Blood Type  : {patient['blood_type']}")
                    print(f"Ward        : {patient['ward']}")
                    print("-" * 40)

        except Exception as e:
            print(f"\nError: {e}")

    def search_patient(self, patient_id):
        """Search for a patient using their ID."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute(
                    "SELECT * FROM patients WHERE id = ?",
                    (patient_id,)
                )

                patient = cursor.fetchone()

                if patient:
                    print("\nPatient Found\n")

                    print(f"ID          : {patient['id']}")
                    print(f"Name        : {patient['name']}")
                    print(f"Age         : {patient['age']}")
                    print(f"DOB         : {patient['dob']}")
                    print(f"Phone       : {patient['phone']}")
                    print(f"Blood Type  : {patient['blood_type']}")
                    print(f"Ward        : {patient['ward']}")

                else:
                    print("\nPatient not found.")

        except Exception as e:
            print(f"\nError: {e}")

    def update_patient(
        self,
        patient_id,
        name,
        age,
        dob,
        phone,
        blood_type,
        ward
    ):
        """Update patient information."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE patients
                    SET
                        name = ?,
                        age = ?,
                        dob = ?,
                        phone = ?,
                        blood_type = ?,
                        ward = ?
                    WHERE id = ?
                """, (
                    name,
                    age,
                    dob,
                    phone,
                    blood_type,
                    ward,
                    patient_id
                ))

                conn.commit()

                if cursor.rowcount:
                    print("\nPatient updated successfully.")
                else:
                    print("\nPatient not found.")

        except Exception as e:
            print(f"\nError: {e}")

    def delete_patient(self, patient_id):
        """Delete a patient."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute(
                    "DELETE FROM patients WHERE id = ?",
                    (patient_id,)
                )

                conn.commit()

                if cursor.rowcount:
                    print("\nPatient deleted successfully.")
                else:
                    print("\nPatient not found.")

        except Exception as e:
            print(f"\nError: {e}")