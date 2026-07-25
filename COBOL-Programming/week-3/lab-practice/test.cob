       IDENTIFICATION DIVISION. 
       PROGRAM-ID. TEST-EXAMPLE.

       DATA DIVISION. 
       WORKING-STORAGE SECTION.
       01 WS-GRADE PIC X.
           88 PASSED-EXCELLENT      VALUE 'A'.
           88 PASSED                 VALUE 'B'.
           88 GOOD                    VALUE 'C'.
           88 BELOW-AVERAGE           VALUE 'D'.
           88 FAILED                  VALUE 'E'.
       01 WS-NAME               PIC X(30).
       01 WS-DISPLAY-RESULT     PIC X(30).
       
       PROCEDURE DIVISION .
           DISPLAY 'Enter comment: '.
           ACCEPT WS-GRADE.

           EVALUATE TRUE
              WHEN PASSED-EXCELLENT
                 MOVE 'Result; Escellent' TO WS-DISPLAY-RESULT
              WHEN PASSED
                 MOVE 'ResultS; PASSED' TO WS-DISPLAY-RESULT
              WHEN GOOD
                 MOVE 'ResultS; GOOD' TO WS-DISPLAY-RESULT
              WHEN BELOW-AVERAGE
                 MOVE 'Result; BELOW AVERAGE' TO WS-DISPLAY-RESULT
              WHEN FAILED
                 MOVE 'Resulta; FAILED' TO WS-DISPLAY-RESULT
           END-EVALUATE.
           DISPLAY WS-DISPLAY-RESULT.
           DISPLAY 'THE ACTUAL RESULT STORED IN LETTER: ' WS-GRADE.

           STOP RUN.
