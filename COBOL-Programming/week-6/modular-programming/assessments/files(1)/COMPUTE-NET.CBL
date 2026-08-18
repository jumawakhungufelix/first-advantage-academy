      *> ================================================================
      *> COMPUTE-NET.CBL
      *> Subprogram: NET PAY = GROSS PAY - TAX
      *> ================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPUTE-NET.

       DATA DIVISION.
       LINKAGE SECTION.
       01  LS-GROSS              PIC 9(7)V99.
       01  LS-TAX                PIC 9(7)V99.
       01  LS-NET                PIC 9(7)V99.

       PROCEDURE DIVISION USING LS-GROSS LS-TAX LS-NET.

       000-MAIN.
           COMPUTE LS-NET = LS-GROSS - LS-TAX
           GOBACK.
