       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROL-BATCH.
       AUTHOR. FELIX-JUMA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL.
           SELECT EMPLOYEE-FILE ASSIGN TO 'EMPLOYEE.DAT'
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           STATUS  IS WS-FILE-STATUS.
           SELECT PAY-ADVICE-FILE ASSIGN TO 'PAY-ADVICE.DAT'
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           STATUS  IS WS-FILE-STATUS.
           SELECT SALARY-SUMMARY-FILE ASSIGN TO 'SALARY-SUMMARY.DAT'
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

      * ---------------------------------------------------------
      * EMPLOYEE-FILE now carries a header record + spaced/aligned
      * columns instead of one unbroken digit string per line.
      * The data fields themselves are unchanged (PIC 9) so the
      * later READ / COMPUTE logic still works exactly as before.
      * ---------------------------------------------------------
       FD EMPLOYEE-FILE.
       01 EMPLOYEE-HEADER-RECORD.
           05 FILLER                    PIC X(70) VALUE
              'EMP-ID   EMP-NAME                BASIC-SALARY   ALLOWA
      -       'NCES'.
       01 EMPLOYEE-DATA.
           05 EMP-ID                        PIC X(5).
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 EMP-NAME                      PIC X(20).
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 EMP-BASIC-SALARY              PIC 9(6)V99.
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 ALLOWANCES                    PIC 9(5)V99.

      * ---------------------------------------------------------
      * PAY-ADVICE-FILE: header row + edited (comma/decimal) money
      * columns so it reads like a payslip table, not raw digits.
      * ---------------------------------------------------------
       FD PAY-ADVICE-FILE.
       01 PAY-ADVICE-HEADER-RECORD.
           05 FILLER                    PIC X(90) VALUE
              'EMP-ID   EMP-NAME                  GROSS-PAY      NHIF
      -       '        PAYE          NET-PAY'.
       01 EMPLOYEE-PAY-ADVICE-RECORD.
           05 ADVICE-EMP-ID                 PIC X(5).
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 ADVICE-EMP-NAME               PIC X(20).
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 GROSS-PAY                     PIC ZZZ,ZZ9.99.
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 NHIF                          PIC ZZ,ZZ9.99.
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 PAYE                          PIC ZZZ,ZZ9.99.
           05 FILLER                        PIC X(3) VALUE SPACES.
           05 NET-PAY                       PIC ZZZ,ZZ9.99.

      * ---------------------------------------------------------
      * SALARY-SUMMARY-FILE: header row + one edited totals row.
      * ---------------------------------------------------------
       FD SALARY-SUMMARY-FILE.
       01 SALARY-SUMMARY-HEADER-RECORD.
           05 FILLER                    PIC X(90) VALUE
              'TOTAL-EMP   TOTAL-GROSS        TOTAL-NHIF        TOTAL
      -       '-PAYE         TOTAL-NET'.
       01 TOTALS.
           05 TOTAL-EMP                    PIC ZZ9.
           05 FILLER                       PIC X(4) VALUE SPACES.
           05 SUM-TOTAL-GROSS              PIC ZZZ,ZZZ,ZZ9.99.
           05 FILLER                       PIC X(4) VALUE SPACES.
           05 SUM-TOTAL-NHIF               PIC ZZ,ZZZ,ZZ9.99.
           05 FILLER                       PIC X(4) VALUE SPACES.
           05 SUM-TOTAL-PAYE               PIC ZZ,ZZZ,ZZ9.99.
           05 FILLER                       PIC X(4) VALUE SPACES.
           05 SUM-TOTAL-NET                PIC ZZ,ZZZ,ZZ9.99.

       WORKING-STORAGE SECTION.
       01 WS-EMPLOYEE-DETAILS            OCCURS 3 TIMES 
                                   INDEXED BY WS-INDEX.
           05 WS-EMP-ID                   PIC X(5).
           05 WS-EMP-NAME                 PIC X(20).
           05 WS-EMP-BASIC-SALARY         PIC 9(6)V99.
           05 WS-ALLOWANCES               PIC 9(5)V99.

       01 WS-NHIF                        PIC 9(5)V99.
       01 WS-PAYE                        PIC 9(6)V99.
       01 WS-NET-PAYE                    PIC 9(6)V99.
       01 WS-GROSS-PAY                   PIC 9(6)V99.
       
       01 WS-EMP-COUNT                PIC 9(3) VALUE 0.
       01 WS-TOTAL-GROSS              PIC 9(9)V99 VALUE 0.
       01 WS-TOTAL-NHIF               PIC 9(8)V99 VALUE 0.
       01 WS-TOTAL-PAYE               PIC 9(8)V99 VALUE 0.
       01 WS-TOTAL-NET                PIC 9(8)V99 VALUE 0.
       01 WS-FILE-STATUS              PIC X(2).
       01 WS-EOS-FLAG                    PIC X VALUE 'N'.
       01 WS-PARTITIONER              PIC X(60) VALUE ALL '='.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN OUTPUT EMPLOYEE-FILE
           WRITE EMPLOYEE-HEADER-RECORD

           PERFORM VARYING WS-EMP-COUNT FROM 1 BY 1 
                 UNTIL WS-EMP-COUNT > 3
              DISPLAY 'Enter employee ID: '
              ACCEPT WS-EMP-ID(WS-EMP-COUNT)
              DISPLAY 'Enter employee name: '
              ACCEPT WS-EMP-NAME(WS-EMP-COUNT)
              DISPLAY 'Enter basic salary: '
              ACCEPT WS-EMP-BASIC-SALARY(WS-EMP-COUNT)
              DISPLAY 'Enter allowances: '
              ACCEPT WS-ALLOWANCES(WS-EMP-COUNT)

              MOVE WS-EMP-ID(WS-EMP-COUNT) TO EMP-ID
              MOVE WS-EMP-NAME(WS-EMP-COUNT) TO EMP-NAME
              MOVE WS-EMP-BASIC-SALARY(WS-EMP-COUNT) TO EMP-BASIC-SALARY
              MOVE WS-ALLOWANCES(WS-EMP-COUNT) TO ALLOWANCES

              WRITE EMPLOYEE-DATA
              DISPLAY 'RECORD ADDED SUCCESSFULLY'
           END-PERFORM.

           CLOSE EMPLOYEE-FILE.
           
           OPEN INPUT EMPLOYEE-FILE
           OPEN OUTPUT PAY-ADVICE-FILE
           OPEN OUTPUT SALARY-SUMMARY-FILE

           WRITE PAY-ADVICE-HEADER-RECORD
           WRITE SALARY-SUMMARY-HEADER-RECORD

           MOVE 0 TO WS-EMP-COUNT
           MOVE 'N' TO WS-EOS-FLAG

      * Skip the header record we just wrote to EMPLOYEE-FILE
           READ EMPLOYEE-FILE
              AT END
                 MOVE 'Y' TO WS-EOS-FLAG
           END-READ.

           PERFORM UNTIL WS-EOS-FLAG = 'Y'
              READ EMPLOYEE-FILE
                 AT END
                    MOVE 'Y' TO WS-EOS-FLAG
                 NOT AT END
                    ADD 1 TO WS-EMP-COUNT
                    
      * Calculate based on file inputs
                    COMPUTE WS-GROSS-PAY = EMP-BASIC-SALARY + ALLOWANCES
                    COMPUTE WS-NHIF = WS-GROSS-PAY * 0.025
                    COMPUTE WS-PAYE = (WS-GROSS-PAY - WS-NHIF) * 0.10
                    COMPUTE WS-NET-PAYE = WS-GROSS-PAY - WS-NHIF -
                     WS-PAYE

                    
                    ADD WS-GROSS-PAY TO WS-TOTAL-GROSS
                    ADD WS-NHIF      TO WS-TOTAL-NHIF
                    ADD WS-PAYE      TO WS-TOTAL-PAYE
                    ADD WS-NET-PAYE  TO WS-TOTAL-NET

      * Write individual pay advice
                    MOVE EMP-ID      TO ADVICE-EMP-ID
                    MOVE EMP-NAME    TO ADVICE-EMP-NAME
                    MOVE WS-GROSS-PAY TO GROSS-PAY
                    MOVE WS-NHIF     TO NHIF
                    MOVE WS-PAYE     TO PAYE
                    MOVE WS-NET-PAYE TO NET-PAY

                    WRITE EMPLOYEE-PAY-ADVICE-RECORD
                    DISPLAY 'PAY ADVICE RECORD WRITTEN FOR: ' EMP-NAME
                    
      * Optional Display of individual logs
                    DISPLAY 'ID: ' EMP-ID' | Gross: ' WS-GROSS-PAY 
                            ' | Net: ' WS-NET-PAYE
              END-READ
           END-PERFORM.
           
      * Write final totals directly into the Summary File
           MOVE WS-EMP-COUNT  TO TOTAL-EMP
           MOVE WS-TOTAL-GROSS TO SUM-TOTAL-GROSS
           MOVE WS-TOTAL-NHIF  TO SUM-TOTAL-NHIF
           MOVE WS-TOTAL-PAYE  TO SUM-TOTAL-PAYE
           MOVE WS-TOTAL-NET   TO SUM-TOTAL-NET
           WRITE TOTALS.

           CLOSE EMPLOYEE-FILE.
           CLOSE PAY-ADVICE-FILE.
           CLOSE SALARY-SUMMARY-FILE.
           
           DISPLAY WS-PARTITIONER.
           DISPLAY '--- PROCESS COMPLETE: DATA REFRESHED ---'.
           DISPLAY 'Total Employees Processed: ' WS-EMP-COUNT.
           DISPLAY 'Total Net Remitted       : ' WS-TOTAL-NET.
           DISPLAY WS-PARTITIONER.
           STOP RUN.