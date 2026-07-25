        IDENTIFICATION DIVISION.
        PROGRAM-ID. GRADING-SYSTEM.

        DATA DIVISION. 
        WORKING-STORAGE SECTION.
        01 WS-STUDENT-NAME            PIC X(30)      VALUE SPACES.
        01 WS-STUDENT-ID              PIC 9(8)       VALUE ZERO.
        01 WS-MARK                    PIC 9(3)       VALUE ZERO.
        01 WS-GRADE                   PIC X(1)       VALUE SPACES.

        PROCEDURE DIVISION.
        MAIN-PARA.
        DISPLAY 'Enter student name: ' WITH NO ADVANCING.
           ACCEPT WS-STUDENT-NAME.
        DISPLAY 'Enter student id : ' WITH NO ADVANCING.
           ACCEPT WS-STUDENT-ID.
        DISPLAY 'Enter student marks: ' WITH NO ADVANCING.
           ACCEPT WS-MARK.
        EVALUATE TRUE
        WHEN WS-MARK >= 70
           MOVE 'A' TO WS-GRADE
        
        WHEN WS-MARK >=60
              MOVE 'B' TO WS-GRADE
        WHEN WS-MARK >= 50
              MOVE 'C' TO WS-GRADE
        WHEN WS-MARK >= 40
              MOVE 'D' TO WS-GRADE
        WHEN WS-MARK < 40
              MOVE 'E' TO WS-GRADE

           
        END-EVALUATE.
        DISPLAY 'HELLO ' WS-STUDENT-NAME 'STUDENT ID ' WS-STUDENT-ID ', YOUR GRADE IS ' WS-GRADE.



