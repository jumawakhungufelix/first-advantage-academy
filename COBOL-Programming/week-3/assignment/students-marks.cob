       IDENTIFICATION DIVISION. 
       PROGRAM-ID. STUDENT-MARKS.

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       01 WS-STREAM-NAME                PIC X(20).
       01 WS-STUDENT-MARKS               PIC 9(3)V99.
       01 WS-TAOTAL-MARKS                PIC 9(5)V99    VALUE ZERO.
       01 WS-AVERAGE-MAKS                PIC 9(5)V99.
       01 WS-HIGHEST                     PIC 9(3)V99.
       01 WS-LOWEST                      PIC 9(3)V99.
       01 WS-COUNTER                     PIC 99        VALUE 1.
       01 WS-PARTITIONER                 PIC X(40)      VALUE ALL '='.
       

       PROCEDURE DIVISION .
           

           PERFORM VARYING WS-COUNTER FROM 1 BY 1
           UNTIL WS-COUNTER > 10

           
           DISPLAY 'Enter student marks: ' WS-COUNTER
           ACCEPT WS-STUDENT-MARKS

           

           ADD WS-STUDENT-MARKS TO WS-TAOTAL-MARKS

           IF WS-COUNTER = 1
              MOVE WS-STUDENT-MARKS TO WS-HIGHEST
              MOVE WS-STUDENT-MARKS TO WS-LOWEST
           ELSE
      
                 IF WS-STUDENT-MARKS > WS-HIGHEST
                  MOVE WS-STUDENT-MARKS TO WS-HIGHEST
                 ELSE 
                    MOVE WS-HIGHEST TO WS-AVERAGE-MAKS
                 END-IF
      
                 IF WS-STUDENT-MARKS < WS-LOWEST 
                  MOVE WS-STUDENT-MARKS  TO WS-LOWEST
      
                  ELSE
                    MOVE WS-LOWEST TO WS-AVERAGE-MAKS
                 END-IF
           END-IF

           
           END-PERFORM

                 

           
         

           

           COMPUTE WS-AVERAGE-MAKS = WS-TAOTAL-MARKS / 10.

           DISPLAY WS-PARTITIONER.
           DISPLAY '             STUDENT MARKS PROCESSOR             '.
           DISPLAY WS-PARTITIONER.
           
           DISPLAY WS-PARTITIONER.

           DISPLAY 'TOTAL MARKS:             ' WS-TAOTAL-MARKS.
           DISPLAY 'AVERAGE MARKS:            'WS-AVERAGE-MAKS.
           DISPLAY 'THE HIGHEST :              'WS-HIGHEST.
           DISPLAY 'THE LOWEST :              'WS-LOWEST.
           DISPLAY WS-PARTITIONER.