      *****************************************************************
      * PROGRAM:  REPORT-RESULTS.CBL
      * PART C:   Read COMBINED.DAT and produce a control-break report
      *           on GRADE. For each grade group, display every
      *           student, then the group's average marks when the
      *           grade changes. Display an overall average at the
      *           end. No SORT/MERGE is used here - COMBINED.DAT must
      *           already be in GRADE descending / MARKS descending
      *           order (Part B's job).
      *
      * Control break order, every time the grade changes:
      *     1. PRINT  the average for the group just finished
      *     2. RESET  the group total/count
      *     3. UPDATE previous-grade, then accumulate the new record
      * WS-PREV-GRADE is primed from the first record BEFORE the loop
      * starts, so the first student never triggers a false break.
      * The final grade group never gets a "grade changed" break, so
      * its average is printed explicitly after the AT END loop exits.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. REPORT-RESULTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT COMBINED-FILE ASSIGN TO "COMBINED.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  COMBINED-FILE.
       01  COMBINED-RECORD.
           05  SR-NAME             PIC X(20).
           05  SR-GRADE            PIC X.
           05  SR-MARKS            PIC 9(3).

       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS          PIC XX.

       01  WS-EOF-SWITCH           PIC X VALUE "N".
           88  WS-EOF                      VALUE "Y".

       01  WS-PREV-GRADE           PIC X.

       01  WS-GRADE-TOTAL          PIC 9(6).
       01  WS-GRADE-COUNT          PIC 9(3).
       01  WS-GRADE-AVERAGE        PIC 9(3)V99.

       01  WS-GRAND-TOTAL          PIC 9(7).
       01  WS-GRAND-COUNT          PIC 9(4).
       01  WS-GRAND-AVERAGE        PIC 9(4)V99.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INITIALIZE-REPORT.
           PERFORM READ-COMBINED-FILE.

      * Prime the previous-grade field with the FIRST record's grade
      * before the control-break loop starts.
           IF NOT WS-EOF
               MOVE SR-GRADE TO WS-PREV-GRADE
           END-IF.

           PERFORM UNTIL WS-EOF
               IF SR-GRADE NOT = WS-PREV-GRADE
                   PERFORM PRINT-GROUP-AVERAGE
                   PERFORM RESET-GROUP-TOTALS
                   MOVE SR-GRADE TO WS-PREV-GRADE
               END-IF
               PERFORM PROCESS-STUDENT-RECORD
               PERFORM READ-COMBINED-FILE
           END-PERFORM.

      * The last grade group never fires a grade-change break -
      * print its average explicitly after AT END.
           PERFORM PRINT-GROUP-AVERAGE.
           PERFORM PRINT-OVERALL-AVERAGE.
           PERFORM CLOSE-REPORT.

           STOP RUN.

       INITIALIZE-REPORT.
           OPEN INPUT COMBINED-FILE.
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "ERROR OPENING COMBINED.DAT, FILE STATUS: "
                   WS-FILE-STATUS
               MOVE 1 TO RETURN-CODE
               STOP RUN
           END-IF.

           MOVE 0 TO WS-GRADE-TOTAL.
           MOVE 0 TO WS-GRADE-COUNT.
           MOVE 0 TO WS-GRAND-TOTAL.
           MOVE 0 TO WS-GRAND-COUNT.

           DISPLAY " ".
           DISPLAY "STUDENT RESULTS REPORT".
           DISPLAY "======================".

       READ-COMBINED-FILE.
           READ COMBINED-FILE
               AT END
                   SET WS-EOF TO TRUE
               NOT AT END
                   IF WS-FILE-STATUS NOT = "00"
                       DISPLAY "READ ERROR, FILE STATUS: "
                           WS-FILE-STATUS
                   END-IF
           END-READ.

       PROCESS-STUDENT-RECORD.
           DISPLAY "  " SR-NAME "  GRADE: " SR-GRADE
               "  MARKS: " SR-MARKS.
           ADD SR-MARKS TO WS-GRADE-TOTAL.
           ADD 1 TO WS-GRADE-COUNT.
           ADD SR-MARKS TO WS-GRAND-TOTAL.
           ADD 1 TO WS-GRAND-COUNT.

       PRINT-GROUP-AVERAGE.
           IF WS-GRADE-COUNT > 0
               COMPUTE WS-GRADE-AVERAGE ROUNDED =
                   WS-GRADE-TOTAL / WS-GRADE-COUNT
               DISPLAY "  ---------------------------------------"
               DISPLAY "  GRADE " WS-PREV-GRADE
                   " AVERAGE MARKS: " WS-GRADE-AVERAGE
               DISPLAY " "
           END-IF.

       RESET-GROUP-TOTALS.
           MOVE 0 TO WS-GRADE-TOTAL.
           MOVE 0 TO WS-GRADE-COUNT.

       PRINT-OVERALL-AVERAGE.
           IF WS-GRAND-COUNT > 0
               COMPUTE WS-GRAND-AVERAGE ROUNDED =
                   WS-GRAND-TOTAL / WS-GRAND-COUNT
               DISPLAY "========================================"
               DISPLAY "OVERALL AVERAGE MARKS: " WS-GRAND-AVERAGE
               DISPLAY "TOTAL STUDENTS: " WS-GRAND-COUNT
           END-IF.

       CLOSE-REPORT.
           CLOSE COMBINED-FILE.
