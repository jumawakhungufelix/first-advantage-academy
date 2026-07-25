       IDENTIFICATION DIVISION.
       PROGRAM-ID. FILES.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OPTIONAL INPUT-FILE ASSIGN TO 'INPUT.DAT'
                 ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OPTIONAL OUTPUT-FILE ASSIGN TO 'OUTPUT.DAT'
                 ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION. 
       FILE SECTION. 

       FD INPUT-FILE.
       01 INPUT-RECORD          PIC X(80).

       FD OUTPUT-FILE.
       01 OUTPUT-RECORD         PIC X(80).

       WORKING-STORAGE SECTION. 
       01 WS-EOF-FLAG           PIC X VALUE 'N'.
       01 WS-RECORD-COUNT       PIC 9(5) VALUE ZERO.

       PROCEDURE DIVISION.
           OPEN INPUT INPUT-FILE 
           OPEN OUTPUT OUTPUT-FILE 

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
              READ INPUT-FILE 
                 AT END
                    MOVE 'Y' TO WS-EOF-FLAG
                 NOT AT END
                    MOVE INPUT-RECORD TO OUTPUT-RECORD 
                    WRITE OUTPUT-RECORD 
                    ADD 1 TO WS-RECORD-COUNT 
              END-READ
           END-PERFORM
   
              CLOSE INPUT-FILE 
              CLOSE OUTPUT-FILE 
              DISPLAY 'Records copied : 'WS-RECORD-COUNT.
   
