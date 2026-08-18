      *> ================================================================
      *> COMPUTE-GROSS.CBL
      *> Subprogram: GROSS PAY = BASIC SALARY + ALLOWANCES
      *> Stretch goal: sets RETURN-CODE to 1 if both basic salary and
      *> allowances are zero (likely bad data), else 0.
      *> ================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPUTE-GROSS.

       DATA DIVISION.
       LINKAGE SECTION.
       COPY EMPREC.

       01  LS-GROSS             PIC 9(7)V99.

       PROCEDURE DIVISION USING EMPLOYEE-RECORD LS-GROSS.

       000-MAIN.
           IF EMP-BASIC = 0 AND EMP-ALLOWANCES = 0
               MOVE 0 TO LS-GROSS
               MOVE 1 TO RETURN-CODE
           ELSE
               COMPUTE LS-GROSS = EMP-BASIC + EMP-ALLOWANCES
               MOVE 0 TO RETURN-CODE
           END-IF
           GOBACK.
