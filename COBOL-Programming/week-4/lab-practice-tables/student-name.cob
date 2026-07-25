       IDENTIFICATION DIVISION.
       PROGRAM-ID. STUDENT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 WS-NAME-TABLE.
           10 WS-NAME        PIC X(20) OCCURS 5 TIMES
                                      INDEXED BY WS-IDX.

       01 WS-TARGET-NAME     PIC X(20).
       01 WS-NAME-FOUND      PIC x VALUE 'N'.
       01 WS-NAME-ENTRY         PIC X(20).

       PROCEDURE DIVISION.
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 10
               DISPLAY 'Enter name '   WS-IDX ':'
               ACCEPT WS-NAME(WS-IDX)
           END-PERFORM.
    
           DISPLAY 'Enter name to search for : '
           ACCEPT WS-TARGET-NAME.
    
           SEARCH ALL WS-NAME-ENTRY
               AT END
                  DISPLAY 'Name not found'
               WHEN WS-NAME(WS-IDX) = WS-TARGET-NAME
                  DISPLAY 'Found at position 'WS-IDX
               END-SEARCH.

           STOP RUN.

