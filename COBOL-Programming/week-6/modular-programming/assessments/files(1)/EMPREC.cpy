      *> ================================================================
      *> EMPREC.cpy
      *> Shared employee record layout.
      *> COPY'd into MAIN-PAYROLL (WORKING-STORAGE) and into each
      *> subprogram's LINKAGE SECTION. No program declares these
      *> fields independently.
      *> ================================================================
       01  EMPLOYEE-RECORD.
           05  EMP-ID           PIC X(5).
           05  EMP-NAME         PIC X(20).
           05  EMP-BASIC        PIC 9(7)V99.
           05  EMP-ALLOWANCES   PIC 9(6)V99.
