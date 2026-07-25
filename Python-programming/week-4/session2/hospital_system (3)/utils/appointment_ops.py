"""
appointment_ops.py

Handles appointment-related database operations.
"""

from utils.db_manager import HospitalDB


class AppointmentOperations:

    def __init__(self):
        self.db = HospitalDB()

    def book_appointment(
        self,
        patient_id,
        doctor_id,
        appointment_date,
        appointment_time,
        reason
    ):
        """Book a new appointment."""

        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO appointments
                    (
                        patient_id,
                        doctor_id,
                        appointment_date,
                        appointment_time,
                        reason
                    )
                    VALUES (?, ?, ?, ?, ?)
                """, (
                    patient_id,
                    doctor_id,
                    appointment_date,
                    appointment_time,
                    reason
                ))

                conn.commit()

                print("\nAppointment booked successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def view_appointments(self):
        """View all appointments."""

        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM appointments
                    ORDER BY appointment_date
                """)

                appointments = cursor.fetchall()

                if not appointments:
                    print("\nNo appointments found.")
                    return

                print("\n====== APPOINTMENTS ======\n")

                for appointment in appointments:

                    print(f"ID: {appointment['id']}")
                    print(f"Patient ID: {appointment['patient_id']}")
                    print(f"Doctor ID: {appointment['doctor_id']}")
                    print(f"Date: {appointment['appointment_date']}")
                    print(f"Time: {appointment['appointment_time']}")
                    print(f"Reason: {appointment['reason']}")
                    print(f"Status: {appointment['status']}")
                    print("-" * 40)

        except Exception as e:
            print(f"\nError: {e}")

    def search_appointment(self, appointment_id):
        """Search appointment by ID."""

        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM appointments
                    WHERE id = ?
                """, (appointment_id,))

                appointment = cursor.fetchone()

                if appointment:

                    print(f"\nAppointment ID: {appointment['id']}")
                    print(f"Patient ID: {appointment['patient_id']}")
                    print(f"Doctor ID: {appointment['doctor_id']}")
                    print(f"Date: {appointment['appointment_date']}")
                    print(f"Time: {appointment['appointment_time']}")
                    print(f"Reason: {appointment['reason']}")
                    print(f"Status: {appointment['status']}")

                else:
                    print("\nAppointment not found.")

        except Exception as e:
            print(f"\nError: {e}")

    def update_status(self, appointment_id, status):
        """Update appointment status."""

        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE appointments
                    SET status = ?
                    WHERE id = ?
                """, (status, appointment_id))

                conn.commit()

                print("\nAppointment updated successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def delete_appointment(self, appointment_id):
        """Delete an appointment."""

        try:
            with self.db.connect() as conn:
                cursor = conn.cursor()

                cursor.execute("""
                    DELETE FROM appointments
                    WHERE id = ?
                """, (appointment_id,))

                conn.commit()

                print("\nAppointment deleted successfully.")

        except Exception as e:
            print(f"\nError: {e}")