# BUAD 405 Applied Econometrics - Summer '26

This is the course R Project. You will use this **same project** for every tutorial and assignment this term - do not create a new project each week.

Full setup instructions: see the setup guide PDF shared alongside this project, or follow the quick version below.

## First-time setup

1.  Open this project on Posit Cloud.
2.  Run `00_setup.R` [ONCE]{.underline} (click **Source**). It installs and loads every R package used across the course.
3.  You're ready for `scripts/tutorial01_starter.R`.

## Folder structure

| Folder / file | What it's for |
|------------------------------------|------------------------------------|
| `00_setup.R` | Run once at the start of the course. Installs/loads all required packages. |
| `data/` | Datasets and codebooks provided by your TA. Read from these files - don't edit them. |
| `scripts/` | Your working scripts, one subfolder per tutorial (e.g. `scripts/tutorial02/`). |
| `output/figures/` | Plots you save from your scripts, organised by tutorial subfolder. |
| `output/tables/` | Summary tables or exports you save from your scripts, organised by tutorial subfolder. |
| `submissions/tutorials/` | Your renamed, final tutorial scripts, ready for submission. |
| `submissions/assignments/` | Your renamed, final assignment scripts, ready for submission. |

## Each new tutorial

Your TA will share a new starter script separately (it can't be added to a project you've already downloaded). When you get it:

1.  Create `scripts/tutorialNN/` and put the new starter script there.
2.  Create matching `output/figures/tutorialNN/` and `output/tables/tutorialNN/` folders for anything you save.
3.  Work through the tutorial, comparing your output against the TA's expected-outputs reference as you go.

## Submitting work

Make a **renamed copy** of your finished script - don't rename your working file in `scripts/`.

| Type       | File name pattern            | Goes in                    |
|------------|------------------------------|----------------------------|
| Tutorial   | `tutorial01_yourname_ID.R`   | `submissions/tutorials/`   |
| Assignment | `assignment01_yourname_ID.R` | `submissions/assignments/` |

Use lowercase, no spaces, and your name exactly as it appears on the class roster.

## Working from home

Everything lives on Posit Cloud, not on one computer. Log in to **posit.cloud** from any device, open this project from your project list, and continue exactly where you left off - nothing to re-upload or sync.
