      *> ================================================================
      *> MAIN-PAYROLL.CBL
      *> Reads EMPLOYEES.DAT, CALLs COMPUTE-GROSS, COMPUTE-TAX and
      *> COMPUTE-NET in sequence for each employee, and writes a
      *> formatted payslip line to PAYSLIPS.DAT.
      *> ================================================================
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN-PAYROLL.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE ASSIGN TO "EMPLOYEES.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PAYSLIP-FILE ASSIGN TO "PAYSLIPS.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  EMPLOYEE-FILE.
       01  EMPLOYEE-LINE         PIC X(80).

       FD  PAYSLIP-FILE.
       01  PAYSLIP-LINE          PIC X(100).

       WORKING-STORAGE SECTION.

      *> Shared employee record layout, from the common copybook.
       COPY EMPREC.

       01  WS-EOF-FLAG           PIC X VALUE "N".
           88  END-OF-FILE       VALUE "Y".

      *> Results passed between the chained subprogram CALLs.
       01  WS-GROSS              PIC 9(7)V99.
       01  WS-TAX                PIC 9(7)V99.
       01  WS-NET                PIC 9(7)V99.

      *> Numeric-edited versions for STRING-ing into the payslip line.
       01  WS-GROSS-ED           PIC Z(6)9.99.
       01  WS-TAX-ED             PIC Z(6)9.99.
       01  WS-NET-ED             PIC Z(6)9.99.

      *> Running totals across all employees (stretch goal).
       01  WS-TOTAL-GROSS        PIC 9(9)V99 VALUE 0.
       01  WS-TOTAL-TAX          PIC 9(9)V99 VALUE 0.
       01  WS-TOTAL-NET          PIC 9(9)V99 VALUE 0.
       01  WS-TOTAL-GROSS-ED     PIC Z(8)9.99.
       01  WS-TOTAL-TAX-ED       PIC Z(8)9.99.
       01  WS-TOTAL-NET-ED       PIC Z(8)9.99.

      *> UNSTRING work fields for parsing each raw comma-delimited line.
       01  WS-FIELD-1            PIC X(20).
       01  WS-FIELD-2            PIC X(20).
       01  WS-FIELD-3            PIC X(20).
       01  WS-FIELD-4            PIC X(20).

       01  WS-OUT-LINE           PIC X(100).

       PROCEDURE DIVISION.

       000-MAIN.
           OPEN INPUT EMPLOYEE-FILE
           OPEN OUTPUT PAYSLIP-FILE

           PERFORM UNTIL END-OF-FILE
               READ EMPLOYEE-FILE
                   AT END
                       MOVE "Y" TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM 100-PROCESS-EMPLOYEE
               END-READ
           END-PERFORM

           PERFORM 200-WRITE-SUMMARY

           CLOSE EMPLOYEE-FILE
           CLOSE PAYSLIP-FILE

           STOP RUN.

       100-PROCESS-EMPLOYEE.
      *> Parse the raw comma-delimited line into the shared record.
           UNSTRING EMPLOYEE-LINE DELIMITED BY ","
               INTO WS-FIELD-1 WS-FIELD-2 WS-FIELD-3 WS-FIELD-4
           END-UNSTRING

           MOVE FUNCTION TRIM(WS-FIELD-1) TO EMP-ID
           MOVE FUNCTION TRIM(WS-FIELD-2) TO EMP-NAME
           MOVE FUNCTION NUMVAL(WS-FIELD-3) TO EMP-BASIC
           MOVE FUNCTION NUMVAL(WS-FIELD-4) TO EMP-ALLOWANCES

      *> Chain the three subprogram CALLs: gross -> tax -> net.
           CALL "COMPUTE-GROSS" USING BY REFERENCE EMPLOYEE-RECORD
                                       BY REFERENCE WS-GROSS
           END-CALL

           IF RETURN-CODE = 1
               DISPLAY "WARNING: skipping " FUNCTION TRIM(EMP-ID)
                   " (" FUNCTION TRIM(EMP-NAME)
                   ") - basic salary and allowances are both zero"
               MOVE 0 TO RETURN-CODE
           ELSE
               CALL "COMPUTE-TAX" USING BY REFERENCE WS-GROSS
                                         BY REFERENCE WS-TAX
               END-CALL

               CALL "COMPUTE-NET" USING BY REFERENCE WS-GROSS
                                         BY REFERENCE WS-TAX
                                         BY REFERENCE WS-NET
               END-CALL

               PERFORM 150-WRITE-PAYSLIP

               ADD WS-GROSS TO WS-TOTAL-GROSS
               ADD WS-TAX   TO WS-TOTAL-TAX
               ADD WS-NET   TO WS-TOTAL-NET
           END-IF.

       150-WRITE-PAYSLIP.
           MOVE WS-GROSS TO WS-GROSS-ED
           MOVE WS-TAX   TO WS-TAX-ED
           MOVE WS-NET   TO WS-NET-ED

           MOVE SPACES TO WS-OUT-LINE
           STRING
               FUNCTION TRIM(EMP-ID)        DELIMITED BY SIZE
               " "                          DELIMITED BY SIZE
               FUNCTION TRIM(EMP-NAME)      DELIMITED BY SIZE
               " GROSS="                    DELIMITED BY SIZE
               FUNCTION TRIM(WS-GROSS-ED)   DELIMITED BY SIZE
               " TAX="                      DELIMITED BY SIZE
               FUNCTION TRIM(WS-TAX-ED)     DELIMITED BY SIZE
               " NET="                      DELIMITED BY SIZE
               FUNCTION TRIM(WS-NET-ED)     DELIMITED BY SIZE
               INTO WS-OUT-LINE
           END-STRING

           WRITE PAYSLIP-LINE FROM WS-OUT-LINE.

       200-WRITE-SUMMARY.
           MOVE WS-TOTAL-GROSS TO WS-TOTAL-GROSS-ED
           MOVE WS-TOTAL-TAX   TO WS-TOTAL-TAX-ED
           MOVE WS-TOTAL-NET   TO WS-TOTAL-NET-ED

           MOVE SPACES TO WS-OUT-LINE
           STRING
               "TOTALS GROSS="                DELIMITED BY SIZE
               FUNCTION TRIM(WS-TOTAL-GROSS-ED) DELIMITED BY SIZE
               " TAX="                        DELIMITED BY SIZE
               FUNCTION TRIM(WS-TOTAL-TAX-ED) DELIMITED BY SIZE
               " NET="                        DELIMITED BY SIZE
               FUNCTION TRIM(WS-TOTAL-NET-ED) DELIMITED BY SIZE
               INTO WS-OUT-LINE
           END-STRING

           WRITE PAYSLIP-LINE FROM WS-OUT-LINE.
