BANKING REPORT PIPELINE - MERGE / LINAGE / CONTROL BREAK
===========================================================

Files
-----
MERGE-BANKING.CBL     Part A - merges NAIROBI-TXN.DAT + MOMBASA-TXN.DAT -> COMBINED-TXN.DAT
BANKING-REPORT.CBL    Parts B & C - paginated LINAGE report with sub-totals + grand total
NAIROBI-TXN.DAT       10-record branch file (exact sample data from the brief)
MOMBASA-TXN.DAT       8-record branch file (exact sample data from the brief)

Record layout (both branch files and COMBINED-TXN.DAT, 42 bytes/line,
LINE SEQUENTIAL):
  cols 1-5    TXN-ACCT-NO    PIC X(5)
  cols 6-25   TXN-NAME       PIC X(20), space-padded
  cols 26-33  TXN-ACCT-TYPE  PIC X(8), space-padded (CURRENT/FIXED/SAVINGS)
  cols 34-42  TXN-BALANCE    PIC 9(7)V99, zero-padded, no decimal point
              (e.g. 12500.00 is stored as 001250000)

How to compile & run (GnuCOBOL)
--------------------------------
  cobc -x -o merge-banking  MERGE-BANKING.CBL
  cobc -x -o banking-report BANKING-REPORT.CBL

  ./merge-banking      # NAIROBI-TXN.DAT + MOMBASA-TXN.DAT -> COMBINED-TXN.DAT
  ./banking-report     # writes BANKING-REPORT.LST (the paginated report)

I compiled and ran both under GnuCOBOL 3.1.2 against the exact sample
data in the brief and checked the output independently in Python
against all 8 test cases - all pass:
  - COMBINED-TXN.DAT: 18 records, genuinely interleaved by balance
    within each type (not one branch appended after the other).
  - Report: 11 pages, several page breaks land mid-group with only a
    new header printed (no false sub-total) - e.g. the CURRENT group
    breaks across pages 1 and 2.
  - CURRENT sub-total 210,500.00 / FIXED 955,000.00 / SAVINGS
    496,000.00 / GRAND TOTAL 1,661,500.00 - all match the brief
    exactly, and SAVINGS (the last group) still gets its sub-total
    printed after AT END even though it never triggers a type-change
    break.

No key-direction gotcha this time
----------------------------------
The previous SORT/MERGE assignment had a trap where "descending"
letter grades sorted backwards in ASCII. This one doesn't - CURRENT
(C) < FIXED (F) < SAVINGS (S) in plain alphabetical order matches
the business meaning and the test cases, so both MERGE-BANKING.CBL
and the ordering logic use ON ASCENDING KEY on both ACCOUNT-TYPE and
BALANCE, exactly as written in the Technical Requirements. Nothing
to second-guess there.

The one thing worth understanding for Friday's review
-------------------------------------------------------
Two completely different things can each cause a new page, and the
program keeps them strictly separate so they can never be confused:

  - AT END-OF-PAGE (on the detail-line WRITE) fires when the current
    page physically runs out of room. Its handler (PRINT-PAGE-HEADER)
    only ever prints the header - nothing about the data changed, so
    there is nothing to sub-total.
  - The control-break IF (TXN-ACCT-TYPE NOT = WS-PREV-TYPE) fires
    only when the account type genuinely changes. Its handler
    (PRINT-TYPE-SUBTOTAL) is never called from inside AT END-OF-PAGE.

That separation is exactly what makes a mid-group page turn print
only a header (test case 4) while a real type change still prints
its sub-total wherever it happens to fall on the page.

132-column layout
------------------
REPORT-LINE is PIC X(132). The detail line, both header lines, the
sub-total line, and the grand-total line all use the same column
plan so everything lines up: cols 1-42 hold the acct#/name/type
zone, cols 43-56 hold the (right-aligned, comma-edited) balance, and
the rest is right-margin FILLER. Every 05-level in every 01-group
sums to exactly 132 - documented field-by-field in the comments
above each group in BANKING-REPORT.CBL. On disk the report lines
look shorter than 132 characters because LINE SEQUENTIAL trims
trailing spaces on write (normal GnuCOBOL behavior for a print
stream) - the underlying record layout is still the full 132 bytes.
