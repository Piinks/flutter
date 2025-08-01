# Instructions for Compiling the Weekly Notable Changes Report

This document outlines the comprehensive, step-by-step process for generating the weekly notable changes report for the Flutter repository. Follow these instructions carefully to ensure accuracy and efficiency.

## Phase 1: Initial Data Gathering & Curation

1.  **Fetch Latest Commits:** Ensure the local repository is up-to-date by running `git fetch`.
2.  **Get All Commits from the Last 7 Days:** Get a list of all commits that have landed in the past seven days (inclusive of today). Use the following command to get the commit hash and the subject line:

    ```shell
    git log --since="7 days ago" --pretty=format:"%H - %s"
    ```

3.  **Select Notable Commits:** From the full list, select approximately 15 notable commits. Use the following rubric for selection:
    *   **Prioritize:**
        *   Developer-Facing Features: New widgets, new properties, or new tool capabilities.
        *   Developer Experience Improvements: Better error messages, more consistent tooling.
        *   Significant Bug Fixes: Fixes for common crashes, visual glitches, or long-standing issues.
        *   Platform & Accessibility: Compatibility with new OS/tool versions (e.g., Xcode) and accessibility improvements.
        *   Architectural Significance: Changes that enable future work or represent a new direction.
    *   **De-prioritize (Generally Exclude):**
        *   Routine dependency rolls (e.g., Skia, Dart SDK).
        *   Minor documentation typos or formatting changes.
        *   CI/testing infrastructure tweaks that don't affect developers.
        *   Internal code refactoring that doesn't change behavior or API.
        *   Tool, Web, and platform-specific changes unless they are highly significant.
4.  **Extract PR Numbers:** For each selected notable commit, extract the pull request number from the commit message (e.g., the number in `(#12345)`).

## Phase 2: Detailed Information Retrieval

For each selected notable PR, gather the following information using the `gh` CLI tool.

1.  **Get Author and Approved Reviewers:** Use the following precise command to get the PR author and a list of reviewers who explicitly approved the change.

    ```shell
    gh pr view <PR_NUMBER> --json author,reviews -q '{author: .author.login, reviewers: [.reviews[] | select(.state=="APPROVED") | .author.login]}'
    ```

2.  **Get Author's Full Name:** For each author and reviewer login, get their full name for the report.

    ```shell
    gh api users/<LOGIN> --jq .name
    ```

    *Note: If a user does not have a public name, use their login instead.*

3.  **Get PR Diff:** Get the code diff, which will be used to write an accurate, one-sentence summary of the change.

    ```shell
    gh pr diff <PR_NUMBER>
    ```

## Phase 3: First-Time Contributor Analysis (CRITICAL)

This is a multi-step process to accurately identify contributors whose *first ever* commit landed this week.

1.  **Get All Unique Authors This Week:** Get a list of all unique author names and emails from the last 7 days.

    ```shell
    git log --since="7 days ago" --pretty=format:"%an <%ae>" | sort -u
    ```

2.  **Check `known_authors.md`:** Before checking the full git history, check if the author is already listed in the `known_authors.md` file. If they are, they are not a first-time contributor.
3.  **Find First Commit Date:** For any author *not* in `known_authors.md`, find the date of their very first commit in the repository's history.

    ```shell
    git log --author="<Full Name <email@example.com>>" --reverse --pretty=format:"%ci" | head -n 1
    ```

4.  **Verify First-Time Status:** Compare the commit date to the start of the 7-day window. If the date is within the last 7 days, the author is a **first-time contributor**.

## Phase 4: Drafting the Report

Assemble the gathered information into a new file named `notable_changes_YYYY-MM-DD.md`, where `YYYY-MM-DD` is the date the report is generated.

1.  **Add the Date Heading:**
    *   Calculate the date range for the report (today and the 6 previous days).
    *   Add a heading at the very top of the file in the format: `### MMMM DD, YYYY to MMMM DD, YYYY`.
2.  **Create the Summary:**
    *   Get the total number of commits: `git log --since="7 days ago" --oneline | wc -l`
    *   Get the current Flutter version: `flutter doctor -v` (use a reasonable upcoming version number, e.g., 3.34.0).
    *   Write a brief, engaging summary at the top of the file. Mention the total number of changes, the likely version tag, and the number of new contributors.
3.  **Format Notable Changes:**
    *   Create a section for each category (e.g., Framework, Material).
    *   For each change, use the format: `**[#PR_NUMBER](LINK_TO_PR) A CONCISE, ENGAGING TITLE**`
    *   Write a brief, human-readable, one-sentence summary of the change based on the code diff. The tone should be celebratory but accurate.
    *   List the author and reviewers in a sub-bullet:
        *   `*   Authored by [Full Name](https://github.com/login) and reviewed by [Reviewer 1](...), [Reviewer 2](...).`
    *   Add 1-2 relevant emojis sparingly and naturally to add personality.
    *   **Consolidate related changes.** If multiple PRs address the same issue (e.g., parts of a larger migration), group them into a single bullet point. List all relevant PR numbers and credit all authors and reviewers involved.
4.  **Add First-Time Contributor Section:**
    *   Create a final section titled "First-time Contributors".
    *   Add a welcoming message.
    *   List each verified first-time contributor with a link to their GitHub profile: `- [Full Name](https://github.com/login)`

## Phase 5: Housekeeping and Finalization

1.  **Update `known_authors.md`:**
    *   For every unique author who contributed this week (both new and existing), add them to the `known_authors.md` file if they are not already listed.
    *   Use the format: `- [Full Name](https://github.com/login)`
2.  **Final Audit:**
    *   Read through the entire `notable_changes_YYYY-MM-DD.md` file one last time.
    *   **Diligently check for accuracy and typos.** Ensure numbers, names, and descriptions are correct. Avoid placeholder text or embarrassing typos.
    *   Ensure the tone is appropriate and engaging.
3.  **Commit (With Permission):**
    *   Stage both the new `notable_changes_YYYY-MM-DD.md` and `known_authors.md`.
    *   **CRITICAL:** Ask the user for explicit permission before creating a commit.
    *   If permission is granted, use a descriptive commit message like: `docs: Create weekly notable changes report for YYYY-MM-DD`.
