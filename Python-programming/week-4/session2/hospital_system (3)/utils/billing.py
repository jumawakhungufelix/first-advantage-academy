"""
billing.py

Handles billing operations.
"""

from utils.db_manager import HospitalDB


class BillingOperations:

    def __init__(self):
        self.db = HospitalDB()

    def generate_bill(
        self,
        patient_id,
        consultation_fee,
        medicine_fee,
        other_fee
    ):
        """Generate a patient bill."""

        try:

            total = consultation_fee + medicine_fee + other_fee

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO bills
                    (
                        patient_id,
                        consultation_fee,
                        medicine_fee,
                        other_fee,
                        total,
                        payment_status
                    )
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (
                    patient_id,
                    consultation_fee,
                    medicine_fee,
                    other_fee,
                    total,
                    "Unpaid"
                ))

                conn.commit()

                print("\nBill generated successfully.")

        except Exception as e:
            print(f"\nError: {e}")

    def view_bills(self):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    SELECT *
                    FROM bills
                """)

                bills = cursor.fetchall()

                if not bills:
                    print("\nNo bills found.")
                    return

                for bill in bills:

                    print(f"Bill ID: {bill['id']}")
                    print(f"Patient ID: {bill['patient_id']}")
                    print(f"Total: {bill['total']}")
                    print(f"Status: {bill['payment_status']}")
                    print("-" * 30)

        except Exception as e:
            print(f"\nError: {e}")

    def mark_paid(self, bill_id):

        try:

            with self.db.connect() as conn:

                cursor = conn.cursor()

                cursor.execute("""
                    UPDATE bills
                    SET payment_status='Paid'
                    WHERE id=?
                """, (bill_id,))

                conn.commit()

                print("\nPayment updated.")

        except Exception as e:
            print(f"\nError: {e}")