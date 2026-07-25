       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROL-BATCH.
       AUTHOR FELIX-JUMA.

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
       FD EMPLOYEE-FILE.
       01 EMPLOYEE-DATA         OCCURS 5 TIMES INDEXED BY WS-INDEX.
           05 EMP-ID                        PIC X(5).
           05 EMP-NAME                      PIC X(20).
           05 EMP-BASIC-SALARY              PIC 9(6)V99.
           05 ALLOWANCES                    PIC 9(5)V99.
       FD PAY-ADVICE-FILE.
       01 EMPLOYEE-PAY-ADVICE-RECORD.
           05 ADVICE-EMP-ID                        PIC X(5).
           05 ADVICE-EMP-NAME                      PIC X(20).
           05 GROSS-PAY                       PIC 9(6)V99.
           05 NHIF                             PIC 9(5)V99.
           05 PAYE                             PIC 9(6)V99.
           05 NET-PAY                          PIC 9(6)V99.
       FD SALARY-SUMMARY-FILE.
       01 TOTALS.
           05 TOTAL-EMP                    PIC 999 VALUE ZERO.
           05 SUM-TOTAL-GROSS              PIC 9(9)V99 VALUE ZERO.
           05 SUM-TOTAL-NHIF               PIC 9(8)V99 VALUE ZERO.
           05 SUM-TOTAL-PAYE               PIC 9(8)V99 VALUE ZERO.
           05 SUM-TOTAL-NET                PIC 9(8)V99 VALUE ZERO.

       WORKING-STORAGE SECTION.
       
       01 WS-EMP-COUNT                PIC 9(3) VALUE 1.
       01 WS-TOTAL-GROSS              PIC 9(9)V99 VALUE 0.
       01 WS-TOTAL-NHIF               PIC 9(8)V99 VALUE 0.
       01 WS-TOTAL-PAYE               PIC 9(8)V99 VALUE 0.
       01 WS-TOTAL-NET                PIC 9(8)V99 VALUE 0.
       01 WS-FILE-STATUS              PIC X(2).
       01 WS-EOS-FLAG                    PIC X VALUE 'N'.


       PROCEDURE DIVISION.
           OPEN I-O EMPLOYEE-FILE.
           OPEN OUTPUT PAY-ADVICE-FILE.
           OPEN OUTPUT SALARY-SUMMARY-FILE.

           PERFORM VARYING WS-EMP-COUNT FROM 1 BY 1
                  UNTIL WS-EMP-COUNT > 5
              DISPLAY 'Enter employee ID: '
              ACCEPT EMP-ID(WS-EMP-COUNT)
              DISPLAY 'Enter employee name: '
              ACCEPT EMP-NAME(WS-EMP-COUNT)
              DISPLAY 'Enter basic salary: '
              ACCEPT EMP-BASIC-SALARY(WS-EMP-COUNT)
              DISPLAY 'Enter allowances: '
              ACCEPT ALLOWANCES(WS-EMP-COUNT)

           WRITE EMPLOYEE-DATA
              READ EMPLOYEE-FILE

              AT END 
                 MOVE 'Y' TO WS-EOS-FLAG
              NOT AT END 
                 MOVE EMP-ID(WS-EMP-COUNT ) TO ADVICE-EMP-ID
                 MOVE EMP-NAME(WS-EMP-COUNT) TO ADVICE-EMP-NAME
                 COMPUTE GROSS-PAY = 
              EMP-BASIC-SALARY(WS-EMP-COUNT) + ALLOWANCES(WS-EMP-COUNT)
             COMPUTE NHIF = GROSS-PAY * 0.25
                  COMPUTE PAYE = 
                  (GROSS-PAY - NHIF) *0.1
                  COMPUTE NET-PAY = 
           GROSS-PAY - NHIF - PAYE
                WRITE EMPLOYEE-PAY-ADVICE-RECORD

                ADD WS-EMP-COUNT TO TOTAL-EMP

                 ADD GROSS-PAY TO SUM-TOTAL-GROSS
                 ADD NHIF TO SUM-TOTAL-NHIF
                 ADD PAYE TO SUM-TOTAL-PAYE
                 ADD NET-PAY TO SUM-TOTAL-NET

              WRITE TOTALS

              END-READ    

              

              IF WS-FILE-STATUS NOT = '00'
                 DISPLAY 'FAILED TO WRITE RECORD. STATUS: ' 
                          WS-FILE-STATUS
              ELSE 
                 DISPLAY 'RECORD SAVED SUCCESSFULLY'
              END-IF

           END-PERFORM.
           STOP RUN.

           
           

           



              

           


