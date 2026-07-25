"""
doctor_ops.py

Contains all doctor-related database operations.
"""

from utils.db_manager import HospitalDB


class DoctorOperations:
    """Handles CRUD operations for doctors."""

    def __init__(self):
        self.db = HospitalDB()

    def add_doctor(self, name, age, phone, specialization, department):
        """Add a new doctor."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO doctors
                    (name, age, phone, specialization, department)
                    VALUES (?, ?, ?, ?, ?)
                """, (name, age, phone, specialization, department))

                conn.commit()

            print(f"\nDoctor '{name}' added successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def view_doctors(self):
        """Display all doctors."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM doctors
                    ORDER BY name
                """)

                doctors = cursor.fetchall()

                if not doctors:
                    print("\nNo doctors found.")
                    return

                print("\n====== DOCTOR LIST ======\n")

                for doctor in doctors:
                    print(f"ID              : {doctor['id']}")
                    print(f"Name            : {doctor['name']}")
                    print(f"Age             : {doctor['age']}")
                    print(f"Phone           : {doctor['phone']}")
                    print(f"Specialization  : {doctor['specialization']}")
                    print(f"Department      : {doctor['department']}")
                    print("-" * 40)

        except Exception as e:
            print(f"\nError: {e}")

    def search_doctor(self, doctor_id):
        """Search for a doctor using ID."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM doctors
                    WHERE id = ?
                """, (doctor_id,))

                doctor = cursor.fetchone()

                if doctor:
                    print("\nDoctor Found\n")

                    print(f"ID              : {doctor['id']}")
                    print(f"Name            : {doctor['name']}")
                    print(f"Age             : {doctor['age']}")
                    print(f"Phone           : {doctor['phone']}")
                    print(f"Specialization  : {doctor['specialization']}")
                    print(f"Department      : {doctor['department']}")

                else:
                    print("\nDoctor not found.")

        except Exception as e:
            print(f"\nError: {e}")

    def search_by_department(self, department):
        """Display doctors in a department."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM doctors
                    WHERE department = ?
                    ORDER BY name
                """, (department,))

                doctors = cursor.fetchall()

                if not doctors:
                    print("\nNo doctors found in that department.")
                    return

                print(f"\nDoctors in {department}\n")

                for doctor in doctors:
                    print(f"{doctor['id']} - Dr. {doctor['name']} ({doctor['specialization']})")

        except Exception as e:
            print(f"\nError: {e}")

    def update_doctor(
        self,
        doctor_id,
        name,
        age,
        phone,
        specialization,
        department
    ):
        """Update doctor information."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE doctors
                    SET
                        name = ?,
                        age = ?,
                        phone = ?,
                        specialization = ?,
                        department = ?
                    WHERE id = ?
                """, (
                    name,
                    age,
                    phone,
                    specialization,
                    department,
                    doctor_id
                ))

                conn.commit()

                if cursor.rowcount:
                    print("\nDoctor updated successfully.")
                else:
                    print("\nDoctor not found.")

        except Exception as e:
            print(f"\nError: {e}")

    def delete_doctor(self, doctor_id):
        """Delete a doctor."""
        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    DELETE FROM doctors
                    WHERE id = ?
                """, (doctor_id,))

                conn.commit()

                if cursor.rowcount:
                    print("\nDoctor deleted successfully.")
                else:
                    print("\nDoctor not found.")

        except Exception as e:
            print(f"\nError: {e}")