       IDENTIFICATION DIVISION. 
       PROGRAM-ID. STUDENTS-MARKS.
       AUTHOR FELIX.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 

       FILE-CONTROL.
           SELECT OPTIONAL STUDENT-MARKS-FILE ASSIGN TO 
                                    'STUDENT-MARKS.DAT'
              ORGANIZATION IS LINE SEQUENTIAL.

           SELECT OPTIONAL RESULT-RECORD ASSIGN TO 'RESULT-RECORD.DAT'
              ORGANIZATION IS LINE SEQUENTIAL.

           SELECT OPTIONAL FAILED-RECORD ASSIGN TO 'FAILED-RECORD.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION. 

       FD STUDENT-MARKS-FILE.
       01 STUDENTS-RECORD.
           05 STUDENT-NAME            PIC X(40).
           05 STUDENT-MARKS           PIC 999.
           


       FD RESULT-RECORD.
       01 RESULTS-RECORD.
           05 RESULT-NAME            PIC X(40).
           05 RESULT-MARKS           PIC 999.

       FD FAILED-RECORD.
       01 FAILED.                   
           05 FAILED-NAME            PIC X(40).
           05 FAILED-MARKS           PIC 999.

       WORKING-STORAGE SECTION. 
       01 WS-EOF-FLAG           PIC X VALUE 'N'.
       01 WS-COUNT              PIC 9(5) VALUE 1.
       01 WS-SUM               PIC 9(6).
       01 WS-AVERAGE           PIC 9999V99.

       PROCEDURE DIVISION.

           OPEN INPUT STUDENT-MARKS-FILE.
           OPEN OUTPUT RESULT-RECORD.
           OPEN OUTPUT FAILED-RECORD.

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
              READ STUDENT-MARKS-FILE
                 AT END
                    MOVE 'Y' TO WS-EOF-FLAG
                 NOT AT END
                    ADD STUDENT-MARKS TO WS-SUM
                    ADD 1 TO WS-COUNT
                    IF STUDENT-MARKS >= 50
                       WRITE RESULTS-RECORD FROM STUDENTS-RECORD
                       ADD 1 TO WS-COUNT
                    ELSE
                       WRITE FAILED FROM STUDENTS-RECORD
                       ADD 1 TO WS-COUNT
                    END-IF
                 END-READ
           END-PERFORM.


                 CLOSE STUDENT-MARKS-FILE.
                 CLOSE RESULT-RECORD.
                 CLOSE FAILED-RECORD .


           COMPUTE WS-AVERAGE = WS-SUM / WS-COUNT.



       



