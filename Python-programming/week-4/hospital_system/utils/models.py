"""
models.py

Contains all classes used in the Hospital Management System.
Demonstrates inheritance and polymorphism.
"""


class Person:
    """Base class for every person in the hospital."""

    def __init__(self, name, age, phone):
        self.name = name
        self.age = age
        self.phone = phone

    def describe(self):
        """Return a description of the person."""
        return (
            f"Name: {self.name}\n"
            f"Age: {self.age}\n"
            f"Phone: {self.phone}"
        )


class Patient(Person):
    """Represents a hospital patient."""

    def __init__(self, name, age, phone, blood_type, ward):
        super().__init__(name, age, phone)
        self.blood_type = blood_type
        self.ward = ward

    def describe(self):
        return (
            f"Patient: {self.name}\n"
            f"Blood Type: {self.blood_type}\n"
            f"Ward: {self.ward}"
        )


class Doctor(Person):
    """Represents a doctor."""

    def __init__(self, name, age, phone, specialization, department):
        super().__init__(name, age, phone)
        self.specialization = specialization
        self.department = department

    def describe(self):
        return (
            f"Doctor: Dr. {self.name}\n"
            f"Specialization: {self.specialization}\n"
            f"Department: {self.department}"
        )


class Nurse(Person):
    """Represents a nurse."""

    def __init__(self, name, age, phone, ward, shift):
        super().__init__(name, age, phone)
        self.ward = ward
        self.shift = shift

    def describe(self):
        return (
            f"Nurse: {self.name}\n"
            f"Ward: {self.ward}\n"
            f"Shift: {self.shift}"
        )