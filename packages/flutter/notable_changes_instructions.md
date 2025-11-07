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

2.  **Get Author's and Reviewers' Full Names:** For each author and reviewer login, get their full name for the report.

    ```shell
    gh api users/<LOGIN> --jq .name
    ```

    *Note: If a user does not have a public name, use their login instead.*

3.  **Get PR Diff:** Get the code diff, which will be used to write an accurate, one-sentence summary of the change.

    ```shell
    gh pr diff <PR_NUMBER>
    ```

4.  **Check for Visual Media:** Check the PR body for images or video clips that can be embedded in the report.

    ```shell
    gh pr view <PR_NUMBER> --json body -q ".body"
    ```

## Phase 3: First-Time Contributor Verification (EXTREMELY CRITICAL)

This is a multi-step, critical process to accurately identify contributors whose *first ever* commit to this repository landed this week. Errors in this section are highly visible and reflect poorly on the team. **Proceed with extreme caution and do not trust automated checks alone.**

1.  **Get All Unique Authors This Week:** Get a list of all unique author names and emails from the specified date range.
    ```shell
    git log --since="<START_DATE>" --until="<END_DATE>" --pretty=format:"%an <%ae>" | sort -u
    ```
2.  **Check `known_authors.md`:** Before checking the full git history, check if the author is already listed in the `known_authors.md` file. If they are, they are **not** a first-time contributor.
3.  **Automated Check for First Commit Date:** For any author *not* in `known_authors.md`, perform an automated check to find the date of their very first commit. **This is a preliminary check and is not guaranteed to be accurate.** An author may have multiple emails or names associated with their git commits, so it is most reliable to use their GitHub login.
    First, get the author's GitHub login from one of their PRs.
    ```shell
    gh pr view <PR_NUMBER> --json author -q '.author.login'
    ```
    Then, use the login to find the first commit.
    ```shell
    git log --author="<LOGIN>" --reverse --pretty=format:"%ci" | head -n 1
    ```
4.  **Secondary Automated Check (More Reliable):** As a more reliable secondary check, use the `gh search` command to look for commits from the author before the reporting period.
    ```shell
    gh search commits --author-date "..<START_DATE>" --author="<LOGIN>" --repo "flutter/flutter"
    ```
    If this command returns any commits, the author is **not** a first-time contributor.
5.  **Manual Verification (ULTIMATE SOURCE OF TRUTH):** The automated checks above can be unreliable. **If there is any doubt, you must manually verify the author's history.** This can be done by visiting their GitHub profile and looking at their contribution history to the `flutter/flutter` repository. If you are an AI agent, you must ask the user to perform this manual verification.
6.  **Verify First-Time Status:** Compare the commit date to the start of the reporting window. If the date is within the window, and all checks (including manual verification) confirm it, the author is a **first-time contributor**. If it is before the window, they are an existing contributor who was missing from `known_authors.md`.
7.  **Get PR for First Contribution:** For each verified first-time contributor, find the commit hash and PR number of their first contribution to write the summary.
    ```shell
    # Get the commit hash and subject line for their first commit
    git log --author="<LOGIN>" --reverse --pretty=format:"%H - %s" | head -n 1
    ```
    Extract the PR number from the subject line (e.g., the number in `(#12345)`). This ensures you are crediting the correct work.


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
    *   **Write an impactful summary.** Do not just repeat the PR title. Based on the PR description and code diff, write a brief, human-readable sentence that explains the *benefit* or *impact* of the change. The tone should be celebratory but accurate.
        *   **Good Example:** "Windows developers will see smoother UIs and fewer deadlocks thanks to a new high-resolution timer implementation in the Win32 runloop. 🚀"
        *   **Bad Example:** "This PR updates the runloop to use a new timer." (This is bland and just repeats the "what".)
    *   List the author and reviewers in a sub-bullet:
        *   `*   Authored by [Full Name](https://github.com/login) and reviewed by [Reviewer 1](...), [Reviewer 2](...).`
    *   Add 1-2 relevant emojis sparingly and naturally to add personality.
    *   **Consolidate related changes.** If multiple PRs address the same issue (e.g., parts of a larger migration), group them into a single bullet point. List all relevant PR numbers and credit all authors and reviewers involved.
    *   **Find and Embed Visual Media.** If a PR includes a helpful image or video, embed it directly in the report under the relevant change. Use standard Markdown for images (`![alt text](URL)`) and `<video>` tags for videos (`<video src="URL" controls></video>`). **CRITICAL: Double-check that the asset URL comes from the correct PR to avoid misattribution.**
4.  **Add First-Time Contributor Section:**
    *   Create a final section titled "First-time Contributors".
    *   Add a welcoming message.
    *   List each verified first-time contributor with a link to their GitHub profile. For each new contributor, add a brief mention of their first contribution, linking to the relevant PR: `- [Full Name](https://github.com/login), for [#PR_NUMBER](LINK_TO_PR), which [description of change].`

## Phase 5: Housekeeping and Finalization

1.  **Update `known_authors.md` (MANDATORY):**
    *   For **every unique author** who contributed this week (both new and existing), add their full name and GitHub login to the `known_authors.md` file if they are not already listed. **This is not just for first-time contributors.**
    *   Use the format: `- [Full Name](https://github.com/login)`
    *   Retrieve the correct login using `gh pr view <PR_NUMBER> --json author -q '.author.login'`. Do not guess.
    *   After adding new authors, ensure the file is alphabetized and contains no duplicates. You can do this with the following command:
        ```shell
        sort -u -o known_authors.md known_authors.md
        ```

2.  **Final Audit and Validation (CRITICAL):**
    *   Read through the entire generated `notable_changes_YYYY-MM-DD.md` file one last time.
    *   **Do not trust cached or previously gathered information.** Re-verify a sample of the data against the primary sources (`git` and `gh`) to ensure absolute accuracy.
    *   **Checklist for Final Validation:**
        1.  **PR-Author-Reviewer Accuracy:** For at least 3-4 notable changes, re-run `gh pr view <PR_NUMBER> --json author,reviews` to confirm the author and reviewers are correct.
        2.  **First-Time Contributor Accuracy:** If you identified any first-time contributors, re-run `git log --author="..." --reverse` for them to prove their first commit is within the report window. Verify the PR number associated with that commit.
        3.  **Name and Handle Accuracy:** For a sample of authors/reviewers, re-run `gh api users/<LOGIN>` to ensure names are correct.
        4.  **Media Asset Correctness:** For every embedded image or video, confirm the URL belongs to the PR it is listed under. **Do not skip this step.**
        5.  **Typos and Formatting:** Read the entire document for clarity, tone, and simple typos.

3.  **Commit (With Permission):**
    *   Stage both the new `notable_changes_YYYY-MM-DD.md` and the updated `known_authors.md`.
    *   **CRITICAL:** Ask the user for explicit permission before creating a commit.
    *   If permission is granted, use a descriptive commit message like: `docs: Create weekly notable changes report for YYYY-MM-DD`.