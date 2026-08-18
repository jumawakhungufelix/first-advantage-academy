STUDENT RESULTS PIPELINE - SORT / MERGE / CONTROL BREAK
=========================================================

Files
-----
SORT-RESULTS.CBL     Part A - sorts RESULTS.DAT -> RANKED.DAT
MERGE-RESULTS.CBL    Part B - merges RANKED.DAT + RESIT-RESULTS.DAT -> COMBINED.DAT
REPORT-RESULTS.CBL   Part C - control-break report on COMBINED.DAT
RESULTS.DAT          30-record main results file (fixed-width test data)
RESIT-RESULTS.DAT    8-record resit file, already sorted (given sample data)

RESULTS.DAT contains the assignment's 14 sample records plus 16 more
records I generated in the same style/distribution to reach the full
30 the brief describes, since only the sample was included here. If
your lab folder's real RESULTS.DAT differs, drop it in alongside these
programs (same fixed-width layout below) before running Part A -
nothing in the code depends on the specific names.

Record layout (all three files, 24 bytes/line, LINE SEQUENTIAL):
  cols 1-20   SR-NAME    PIC X(20), space-padded
  col  21     SR-GRADE   PIC X          (A, B, or C)
  cols 22-24  SR-MARKS   PIC 9(3), zero-padded

How to compile & run (GnuCOBOL)
--------------------------------
  cobc -x -o sort-results   SORT-RESULTS.CBL
  cobc -x -o merge-results  MERGE-RESULTS.CBL
  cobc -x -o report-results REPORT-RESULTS.CBL

  ./sort-results      # RESULTS.DAT -> RANKED.DAT
  ./merge-results     # RANKED.DAT + RESIT-RESULTS.DAT -> COMBINED.DAT
  ./report-results    # prints the grouped report to screen

All three compiled and ran cleanly under GnuCOBOL 3.1.2, and I checked
the output independently in Python against the 7 test cases:
  - RANKED.DAT: A-grade block first, marks strictly non-ascending
    within each grade.
  - COMBINED.DAT: 38 records, resit students genuinely interleaved
    (not appended), same A-then-B-then-C / descending-marks order.
  - Report: each grade average printed once right after its group,
    last group (C) printed too, overall average 66.39 across all 38
    students - matches (sum of marks) / (count) exactly.

The one thing I changed from the brief's literal wording
---------------------------------------------------------
The Technical Requirements say to code:
    ON DESCENDING KEY SR-GRADE, ON DESCENDING KEY SR-MARKS

I didn't use that. SR-GRADE is a letter (PIC X), and COBOL sorts
letters by their character code - A=65, B=66, C=67. A literal
DESCENDING key on that field sorts C, then B, then A, because C has
the highest code. That's the opposite of what the brief actually
asks for a few lines earlier: "GRADE descending (A before B before
C)" - and it's the opposite of what test case 1 checks for
(RANKED.DAT must begin with the A-grade students).

Since A < B < C alphabetically, an ASCENDING key on SR-GRADE is what
actually produces A-before-B-before-C. So both SORT-RESULTS.CBL and
MERGE-RESULTS.CBL use:
    ON ASCENDING KEY SR-GRADE, ON DESCENDING KEY SR-MARKS

I left a comment at that line in both files explaining why, in case
you want to walk through it Wednesday - it's a good one to be able to
explain, since it's exactly the kind of thing "verify each stage's
output" in the brief is pushing you to catch.

Everything else follows the brief as written: INPUT-OUTPUT SECTION
before FILE-CONTROL, FILE STATUS on every file, RESULTS-FILE/
RANKED-FILE never opened manually in Part A, no INPUT PROCEDURE on
the MERGE, WS-PREV-GRADE primed before the Part C loop, and the final
group's average printed explicitly after AT END.
