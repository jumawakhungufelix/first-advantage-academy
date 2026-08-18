      *****************************************************************
      * PROGRAM:  BANKING-REPORT.CBL
      * PART B:   Read COMBINED-TXN.DAT with a control break on
      *           ACCOUNT-TYPE. Write a paginated report using
      *           LINAGE: a page header on every page, and an
      *           account-type sub-total whenever the type changes.
      * PART C:   A page turn in the MIDDLE of a type group must
      *           print ONLY the new page header - never a sub-total.
      *           The sub-total fires solely on a genuine type change
      *           or the final AT END. Grand total prints once, after
      *           every record is processed.
      *
      * KEY DESIGN POINT: two entirely separate triggers write to
      * this report, and they must never be conflated:
      *   - AT END-OF-PAGE (on the detail WRITE)  -> PRINT-PAGE-HEADER
      *     only. This is a physical "ran out of room" event and has
      *     nothing to do with the data's grouping.
      *   - TXN-ACCT-TYPE NOT = WS-PREV-TYPE (in the control-break
      *     IF) -> PRINT-TYPE-SUBTOTAL. This is a business "the group
      *     changed" event and has nothing to do with the page.
      * PRINT-PAGE-HEADER is never called from inside the sub-total
      * logic, and PRINT-TYPE-SUBTOTAL is never called from inside
      * AT END-OF-PAGE - that separation is what makes test case 4
      * (mid-group page break, no false sub-total) pass.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKING-REPORT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT COMBINED-FILE ASSIGN TO "COMBINED-TXN.DAT"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-COMBINED-STATUS.

           SELECT REPORT-FILE ASSIGN TO "BANKING-REPORT.LST"
               FILE STATUS IS WS-REPORT-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  COMBINED-FILE.
       01  COMBINED-RECORD.
           05  TXN-ACCT-NO         PIC X(5).
           05  TXN-NAME            PIC X(20).
           05  TXN-ACCT-TYPE       PIC X(8).
           05  TXN-BALANCE         PIC 9(7)V99.

      * LINAGE: 8 lines make up the page body; the footing area
      * starts at line 6 (so lines 1-5 are available for automatic
      * detail WRITEs before AT END-OF-PAGE fires); 2 blank lines at
      * the physical top of every page, 1 at the bottom. Tight enough
      * to force several pages, and at least one mid-group break,
      * against the 18-record sample data - confirmed by test run.
       FD  REPORT-FILE
           LINAGE IS 8 LINES
               WITH FOOTING AT 6
               LINES AT TOP 2
               LINES AT BOTTOM 1.
       01  REPORT-LINE                 PIC X(132).

       WORKING-STORAGE SECTION.
       01  WS-COMBINED-STATUS      PIC XX.
       01  WS-REPORT-STATUS        PIC XX.

       01  WS-EOF-SWITCH           PIC X VALUE "N".
           88  WS-EOF                      VALUE "Y".

       01  WS-PREV-TYPE            PIC X(8).

       01  WS-TYPE-TOTAL           PIC 9(9)V99.
       01  WS-GRAND-TOTAL          PIC 9(10)V99.
       01  WS-PAGE-NUM             PIC 9(3).

      *---------------------------------------------------------------
      * Detail line. 132 columns, every field/FILLER accounted for:
      *   1-5 acct no, 6-8 gap, 9-28 name, 29-31 gap, 32-39 type,
      *   40-42 gap, 43-56 balance (edited), 57-132 unused right
      *   margin. 5+3+20+3+8+3+14+76 = 132.
      *---------------------------------------------------------------
       01  WS-DETAIL-LINE.
           05  WS-D-ACCT-NO        PIC X(5).
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  WS-D-NAME           PIC X(20).
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  WS-D-ACCT-TYPE      PIC X(8).
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  WS-D-BALANCE        PIC ZZZ,ZZZ,ZZ9.99.
           05  FILLER              PIC X(76) VALUE SPACES.

      * Header lines share the same column plan as the detail line
      * (1-42 is the acct/name/type zone, 43-56 the balance zone) so
      * everything lines up under the same ruler.
       01  WS-HEADER-LINE-1.
           05  FILLER              PIC X(45) VALUE SPACES.
           05  FILLER              PIC X(24) VALUE
               "NATIONAL BANKING REPORT".
           05  FILLER              PIC X(53) VALUE SPACES.
           05  FILLER              PIC X(5)  VALUE "PAGE ".
           05  WS-H1-PAGE-NUM      PIC ZZ9.
           05  FILLER              PIC X(2)  VALUE SPACES.

       01  WS-HEADER-LINE-2.
           05  FILLER              PIC X(5)  VALUE "ACCT#".
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  FILLER              PIC X(20) VALUE
               "ACCOUNT HOLDER NAME".
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  FILLER              PIC X(8)  VALUE "TYPE".
           05  FILLER              PIC X(3)  VALUE SPACES.
           05  FILLER              PIC X(14) JUSTIFIED RIGHT VALUE
               "BALANCE".
           05  FILLER              PIC X(76) VALUE SPACES.

      * Sub-total and grand-total lines: label sits in the
      * acct-no/name zone (cols 1-31), balance lines up exactly
      * under the detail balance column (cols 43-56).
       01  WS-SUBTOTAL-LINE.
           05  FILLER              PIC X(9)  VALUE SPACES.
           05  WS-ST-LABEL         PIC X(22) VALUE SPACES.
           05  FILLER              PIC X(11) VALUE SPACES.
           05  WS-ST-BALANCE       PIC ZZZ,ZZZ,ZZ9.99.
           05  FILLER              PIC X(76) VALUE SPACES.

      * WS-GT-BALANCE is 16 columns (vs. 14 for the sub-total) because
      * WS-GRAND-TOTAL is PIC 9(10)V99 per the field spec - one more
      * comma-group than WS-TYPE-TOTAL's PIC 9(9)V99, so FILLER after
      * it drops from 76 to 74 to keep the line at exactly 132:
      * 9+22+11+16+74 = 132.
       01  WS-GRANDTOTAL-LINE.
           05  FILLER              PIC X(9)  VALUE SPACES.
           05  WS-GT-LABEL         PIC X(22) VALUE "GRAND TOTAL:".
           05  FILLER              PIC X(11) VALUE SPACES.
           05  WS-GT-BALANCE       PIC Z,ZZZ,ZZZ,ZZ9.99.
           05  FILLER              PIC X(74) VALUE SPACES.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           PERFORM INITIALIZE-REPORT.
           PERFORM READ-COMBINED-FILE.

      * Prime the previous-type field with the FIRST record's type
      * before the control-break loop starts.
           IF NOT WS-EOF
               MOVE TXN-ACCT-TYPE TO WS-PREV-TYPE
           END-IF.

           PERFORM UNTIL WS-EOF
               IF TXN-ACCT-TYPE NOT = WS-PREV-TYPE
                   PERFORM PRINT-TYPE-SUBTOTAL
                   PERFORM RESET-TYPE-TOTAL
                   MOVE TXN-ACCT-TYPE TO WS-PREV-TYPE
               END-IF
               PERFORM WRITE-DETAIL-LINE
               PERFORM READ-COMBINED-FILE
           END-PERFORM.

      * The last account-type group never fires a type-change break -
      * print its sub-total explicitly after AT END, then the grand
      * total once, after every record has been processed.
           PERFORM PRINT-TYPE-SUBTOTAL.
           PERFORM PRINT-GRAND-TOTAL.
           PERFORM CLOSE-REPORT.

           STOP RUN.

       INITIALIZE-REPORT.
           OPEN INPUT COMBINED-FILE.
           IF WS-COMBINED-STATUS NOT = "00"
               DISPLAY "ERROR OPENING COMBINED-TXN.DAT, FILE STATUS: "
                   WS-COMBINED-STATUS
               MOVE 1 TO RETURN-CODE
               STOP RUN
           END-IF.

           OPEN OUTPUT REPORT-FILE.
           IF WS-REPORT-STATUS NOT = "00"
               DISPLAY "ERROR OPENING REPORT FILE, FILE STATUS: "
                   WS-REPORT-STATUS
               MOVE 1 TO RETURN-CODE
               STOP RUN
           END-IF.

           MOVE 0 TO WS-PAGE-NUM.
           MOVE 0 TO WS-TYPE-TOTAL.
           MOVE 0 TO WS-GRAND-TOTAL.

      * Print the first page's header manually - AT END-OF-PAGE only
      * fires on overflow, never for the very first page.
           PERFORM PRINT-PAGE-HEADER.

       READ-COMBINED-FILE.
           READ COMBINED-FILE
               AT END
                   SET WS-EOF TO TRUE
               NOT AT END
                   IF WS-COMBINED-STATUS NOT = "00"
                       DISPLAY "READ ERROR, FILE STATUS: "
                           WS-COMBINED-STATUS
                   END-IF
           END-READ.

       WRITE-DETAIL-LINE.
           MOVE TXN-ACCT-NO   TO WS-D-ACCT-NO.
           MOVE TXN-NAME      TO WS-D-NAME.
           MOVE TXN-ACCT-TYPE TO WS-D-ACCT-TYPE.
           MOVE TXN-BALANCE   TO WS-D-BALANCE.
           WRITE REPORT-LINE FROM WS-DETAIL-LINE
               AT END-OF-PAGE
                   PERFORM PRINT-PAGE-HEADER
           END-WRITE.
           ADD TXN-BALANCE TO WS-TYPE-TOTAL.
           ADD TXN-BALANCE TO WS-GRAND-TOTAL.

      * Fires only on a genuine ACCOUNT-TYPE change or the final
      * AT END - never from AT END-OF-PAGE.
       PRINT-TYPE-SUBTOTAL.
           IF WS-TYPE-TOTAL > 0
               MOVE SPACES TO WS-ST-LABEL
               STRING WS-PREV-TYPE DELIMITED BY SPACE
                   " SUB-TOTAL:" DELIMITED BY SIZE
                   INTO WS-ST-LABEL
               END-STRING
               MOVE WS-TYPE-TOTAL TO WS-ST-BALANCE
               WRITE REPORT-LINE FROM WS-SUBTOTAL-LINE
                   AT END-OF-PAGE
                       PERFORM PRINT-PAGE-HEADER
               END-WRITE
           END-IF.

       RESET-TYPE-TOTAL.
           MOVE 0 TO WS-TYPE-TOTAL.

       PRINT-GRAND-TOTAL.
           MOVE WS-GRAND-TOTAL TO WS-GT-BALANCE.
           WRITE REPORT-LINE FROM WS-GRANDTOTAL-LINE
               AT END-OF-PAGE
                   PERFORM PRINT-PAGE-HEADER
           END-WRITE.

      * Called at the very start of the report AND automatically by
      * every AT END-OF-PAGE on the WRITE statements above. Only ever
      * prints the header - never a sub-total.
       PRINT-PAGE-HEADER.
           ADD 1 TO WS-PAGE-NUM.
           MOVE WS-PAGE-NUM TO WS-H1-PAGE-NUM.
           WRITE REPORT-LINE FROM WS-HEADER-LINE-1.
           WRITE REPORT-LINE FROM WS-HEADER-LINE-2.

       CLOSE-REPORT.
           CLOSE COMBINED-FILE.
           CLOSE REPORT-FILE.
