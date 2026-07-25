"""
ward.py

Handles ward management.
"""

from utils.db_manager import HospitalDB


class WardOperations:

    def __init__(self):
        self.db = HospitalDB()

    def add_ward(self, ward_name, capacity):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO wards
                    (
                        ward_name,
                        capacity
                    )
                    VALUES (?, ?)
                """, (ward_name, capacity))

                conn.commit()

                print("\nWard added successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def view_wards(self):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM wards
                """)

                wards = cursor.fetchall()

                if not wards:
                    print("\nNo wards found.")
                    return

                for ward in wards:

                    available = ward["capacity"] - ward["occupied"]

                    print(f"Ward: {ward['ward_name']}")
                    print(f"Capacity: {ward['capacity']}")
                    print(f"Occupied: {ward['occupied']}")
                    print(f"Available Beds: {available}")
                    print("-" * 30)

        except Exception as e:
            print(f"\nError: {e}")

    def admit_patient(self, ward_id):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE wards
                    SET occupied = occupied + 1
                    WHERE id = ?
                """, (ward_id,))

                conn.commit()

                print("\nPatient admitted.")

        except Exception as e:
            print(f"\nError: {e}")

    def discharge_patient(self, ward_id):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE wards
                    SET occupied = occupied - 1
                    WHERE id = ? AND occupied > 0
                """, (ward_id,))

                conn.commit()

                print("\nPatient discharged.")

        except Exception as e:
            print(f"\nError: {e}")