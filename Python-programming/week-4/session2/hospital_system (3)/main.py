"""
main.py

Entry point for the Hospital Management System.
"""

from utils.patient_ops import PatientOperations
from utils.doctor_ops import DoctorOperations
from utils.appointment_ops import AppointmentOperations
from utils.billing import BillingOperations
from utils.ward import WardOperations


patients = PatientOperations()
doctors = DoctorOperations()
appointments = AppointmentOperations()
billing = BillingOperations()
wards = WardOperations()


def patient_menu():

    while True:

        print("\n========== PATIENT MENU ==========")
        print("1. Add Patient")
        print("2. View Patients")
        print("3. Search Patient")
        print("4. Update Patient")
        print("5. Delete Patient")
        print("6. Back")

        choice = input("Select an option: ")

        if choice == "1":

            name = input("Name: ")
            age = int(input("Age: "))
            dob = input("Date of Birth: ")
            phone = input("Phone: ")
            blood = input("Blood Type: ")
            ward = input("Ward: ")

            patients.add_patient(
                name,
                age,
                dob,
                phone,
                blood,
                ward
            )

        elif choice == "2":

            patients.view_patients()

        elif choice == "3":

            patient_id = int(input("Patient ID: "))
            patients.search_patient(patient_id)

        elif choice == "4":

            patient_id = int(input("Patient ID: "))
            name = input("Name: ")
            age = int(input("Age: "))
            dob = input("Date of Birth: ")
            phone = input("Phone: ")
            blood = input("Blood Type: ")
            ward = input("Ward: ")

            patients.update_patient(
                patient_id,
                name,
                age,
                dob,
                phone,
                blood,
                ward
            )

        elif choice == "5":

            patient_id = int(input("Patient ID: "))
            patients.delete_patient(patient_id)

        elif choice == "6":

            break

        else:

            print("Invalid choice.")


def doctor_menu():

    while True:

        print("\n========== DOCTOR MENU ==========")
        print("1. Add Doctor")
        print("2. View Doctors")
        print("3. Search Doctor")
        print("4. Search Department")
        print("5. Update Doctor")
        print("6. Delete Doctor")
        print("7. Back")

        choice = input("Select an option: ")

        if choice == "1":

            doctors.add_doctor(
                input("Name: "),
                int(input("Age: ")),
                input("Phone: "),
                input("Specialization: "),
                input("Department: ")
            )

        elif choice == "2":

            doctors.view_doctors()

        elif choice == "3":

            doctors.search_doctor(
                int(input("Doctor ID: "))
            )

        elif choice == "4":

            doctors.search_by_department(
                input("Department: ")
            )

        elif choice == "5":

            doctor_id = int(input("Doctor ID: "))

            doctors.update_doctor(
                doctor_id,
                input("Name: "),
                int(input("Age: ")),
                input("Phone: "),
                input("Specialization: "),
                input("Department: ")
            )

        elif choice == "6":

            doctors.delete_doctor(
                int(input("Doctor ID: "))
            )

        elif choice == "7":

            break

        else:

            print("Invalid choice.")


def appointment_menu():

    while True:

        print("\n========== APPOINTMENTS ==========")
        print("1. Book Appointment")
        print("2. View Appointments")
        print("3. Search Appointment")
        print("4. Update Status")
        print("5. Delete Appointment")
        print("6. Back")

        choice = input("Select: ")

        if choice == "1":

            appointments.book_appointment(
                int(input("Patient ID: ")),
                int(input("Doctor ID: ")),
                input("Date: "),
                input("Time: "),
                input("Reason: ")
            )

        elif choice == "2":

            appointments.view_appointments()

        elif choice == "3":

            appointments.search_appointment(
                int(input("Appointment ID: "))
            )

        elif choice == "4":

            appointments.update_status(
                int(input("Appointment ID: ")),
                input("Status: ")
            )

        elif choice == "5":

            appointments.delete_appointment(
                int(input("Appointment ID: "))
            )

        elif choice == "6":

            break

        else:

            print("Invalid choice.")


def billing_menu():

    while True:

        print("\n========== BILLING ==========")
        print("1. Generate Bill")
        print("2. View Bills")
        print("3. Mark Paid")
        print("4. Back")

        choice = input("Select: ")

        if choice == "1":

            billing.generate_bill(
                int(input("Patient ID: ")),
                float(input("Consultation Fee: ")),
                float(input("Medicine Fee: ")),
                float(input("Other Charges: "))
            )

        elif choice == "2":

            billing.view_bills()

        elif choice == "3":

            billing.mark_paid(
                int(input("Bill ID: "))
            )

        elif choice == "4":

            break

        else:

            print("Invalid choice.")


def ward_menu():

    while True:

        print("\n========== WARDS ==========")
        print("1. Add Ward")
        print("2. View Wards")
        print("3. Admit Patient")
        print("4. Discharge Patient")
        print("5. Back")

        choice = input("Select: ")

        if choice == "1":

            wards.add_ward(
                input("Ward Name: "),
                int(input("Capacity: "))
            )

        elif choice == "2":

            wards.view_wards()

        elif choice == "3":

            wards.admit_patient(
                int(input("Ward ID: "))
            )

        elif choice == "4":

            wards.discharge_patient(
                int(input("Ward ID: "))
            )

        elif choice == "5":

            break

        else:

            print("Invalid choice.")


def main():

    while True:

        print("\n===================================")
        print(" HOSPITAL MANAGEMENT SYSTEM ")
        print("===================================")
        print("1. Patient Registration")
        print("2. Doctor Management")
        print("3. Appointment System")
        print("4. Billing")
        print("5. Ward Management")
        print("6. Exit")

        choice = input("Select an option: ")

        if choice == "1":

            patient_menu()

        elif choice == "2":

            doctor_menu()

        elif choice == "3":

            appointment_menu()

        elif choice == "4":

            billing_menu()

        elif choice == "5":

            ward_menu()

        elif choice == "6":

            print("\nThank you for using the Hospital Management System.")
            break

        else:

            print("Invalid choice.")


if __name__ == "__main__":
    main()