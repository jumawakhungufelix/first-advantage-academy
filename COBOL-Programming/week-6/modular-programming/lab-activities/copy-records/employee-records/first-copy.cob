       IDENTIFICATION DIVISION.
       PROGRAM-ID. FIRST-COPY.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           COPY emprec.

       PROCEDURE DIVISION. 
           DISPLAY 'ID   NAME    DEP'.
           DISPLAY WS-EMP-ID ' 'WS-EMP-NAME  ' 'WS-DEP-CODE .
           STOP RUN.

       
