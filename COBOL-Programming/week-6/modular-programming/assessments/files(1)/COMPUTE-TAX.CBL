      *> ================================================================
      *> COMPUTE-TAX.CBL
      *> Subprogram: TAX = GROSS PAY x 10% (ROUNDED)
      *> ================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPUTE-TAX.

       DATA DIVISION.
       LINKAGE SECTION.
       01  LS-GROSS              PIC 9(7)V99.
       01  LS-TAX                PIC 9(7)V99.

       PROCEDURE DIVISION USING LS-GROSS LS-TAX.

       000-MAIN.
           COMPUTE LS-TAX ROUNDED = LS-GROSS * 0.10
           GOBACK.
