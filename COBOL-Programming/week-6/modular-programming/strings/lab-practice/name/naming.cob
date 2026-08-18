       IDENTIFICATION DIVISION.
       PROGRAM-ID. NAME.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NAME-FILE ASSIGN TO 'NAME.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PROD-FILE ASSIGN TO 'PROD.DAT'
           ORGANIZATION IS LINE SEQUENTIAL.


       DATA DIVISION. 
       FILE SECTION. 
       FD NAME-FILE.
       01 NAME-RECORD.
           05 FIRST-NAME        PIC X(20).
           05 LAST-NAME         PIC X(20).
           05 FULL-NAME         PIC X(30).
       
       FD PROD-FILE.
       01 CSV-LINE              PIC X(30).


       WORKING-STORAGE SECTION.

       01 WS-FIRST-NAME      PIC X(20).
       01 WS-LAST-NAME       PIC X(20).
       01 WS-FULL-NAME          PIC X(30).
       01 WS-CSV-LINE           PIC X(30).
       01 WS-CHOICE             PIC X.
       01 WS-PROGRAM-CHOICE     PIC X.

       01 WS-PRODUCT.
           05 WS-ITEM           PIC X(20).
           05 WS-PRICE          PIC 9(4).
           05 WS-QTY            PIC 999.
       01 WS-COMMA-COUNT        PIC 99.

       PROCEDURE DIVISION.
           PERFORM UNTIL WS-PROGRAM-CHOICE = 'N'
           
           
           DISPLAY 'ENTER CHOICE(N/C) FOR NAME FILE AND CSV FILE: '
           ACCEPT WS-CHOICE

           IF WS-CHOICE = 'N' OR WS-CHOICE = 'n'
              OPEN OUTPUT NAME-FILE
              DISPLAY 'ENTER FIRST NAME: '
              ACCEPT WS-FIRST-NAME
              DISPLAY 'ENTER LAST NAME: '
              ACCEPT WS-LAST-NAME
              
              STRING WS-FIRST-NAME  DELIMITED BY SPACE 
                    ' ' DELIMITED BY SIZE
                    WS-LAST-NAME DELIMITED BY SPACE
                    INTO WS-FULL-NAME
   
              
   
                    MOVE WS-FIRST-NAME TO FIRST-NAME
                    MOVE WS-LAST-NAME TO LAST-NAME
                    MOVE WS-FULL-NAME TO FULL-NAME
                    
   
                    WRITE NAME-RECORD
   
   
         
   
              CLOSE NAME-FILE
   
   
   
              OPEN INPUT NAME-FILE
                 READ NAME-FILE
                    AT END
                       DISPLAY 'NO MORE RECORD'
                    NOT AT END
                       DISPLAY 'NAME IS: ' FULL-NAME
                 END-READ
   
   
              UNSTRING FULL-NAME DELIMITED BY SPACE 
              INTO FIRST-NAME ,LAST-NAME
              END-UNSTRING
   
              
   
              MOVE FIRST-NAME TO WS-FIRST-NAME
              MOVE LAST-NAME TO WS-LAST-NAME
              
              DISPLAY 'FIRST NAME: 'WS-FIRST-NAME 
              'LAST NAME:  ' WS-LAST-NAME
   
              
              CLOSE NAME-FILE
              

           ELSE
              IF WS-CHOICE = 'C' OR WS-CHOICE = 'c'
   
                 OPEN OUTPUT PROD-FILE
                 DISPLAY 'ENTER CSV LINE: '
                 ACCEPT WS-CSV-LINE
                 
                 MOVE WS-CSV-LINE TO CSV-LINE
                 WRITE CSV-LINE
                 CLOSE PROD-FILE
      
                 OPEN INPUT PROD-FILE
                 UNSTRING CSV-LINE DELIMITED BY ','
                 INTO WS-ITEM, WS-PRICE,WS-QTY

                 INSPECT WS-CSV-LINE TALLYING
                 WS-COMMA-COUNT FOR ALL ','
      
                 DISPLAY '==============================='
                 DISPLAY 'ITEM       PRICE       QUANTITY'
                 DISPLAY '--' WS-ITEM ' 'WS-PRICE ' ' WS-QTY '--'
                 DISPLAY '================================'
                 DISPLAY 'TOTAL OF 'WS-COMMA-COUNT ' COMMAS'
                 CLOSE PROD-FILE
      
      
      
                 
              ELSE
                 DISPLAY 'INVALID INPUT'
              END-IF
           END-IF
              
              PERFORM UNTIL WS-PROGRAM-CHOICE = 'N' OR
               WS-PROGRAM-CHOICE = 'Y'
                 DISPLAY 'ENTER PROGRAM CHOICE (Y/N): '
                 ACCEPT WS-PROGRAM-CHOICE
                 IF WS-PROGRAM-CHOICE = 'Y'
                    CONTINUE
                 ELSE
                    IF WS-PROGRAM-CHOICE = 'N'
                       EXIT PERFORM
                       
                    ELSE 
                       DISPLAY 'INVALID INPUT'
                       
      
                    END-IF
                 END-IF
              END-PERFORM
           END-PERFORM.
           STOP RUN.



              
   