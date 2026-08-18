       IDENTIFICATION DIVISION.
       PROGRAM-ID. validate.

       DATA DIVISION.
       LINKAGE SECTION. 
       01 LS-AGE          PIC 9(3).
       01 LS-VALID-FLAG   PIC X.
       PROCEDURE DIVISION USING LS-AGE, LS-VALID-FLAG.
           IF LS-AGE >= 18 AND LS-AGE<=100
           MOVE 'Y' TO LS-VALID-FLAG
           ELSE
           MOVE 'N' TO LS-VALID-FLAG
           END-IF
           MOVE 999 TO LS-AGE
           GOBACK.
           