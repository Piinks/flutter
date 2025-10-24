### **Instructions for Drafting the "What's New in the Framework" Release Blog**

Hello\! Your task is to help me draft the "Framework" section of the "What's New in Flutter X.XX" release blog post. We will work together to analyze the changes in a given release, group them into thematic sections, and write engaging, developer-focused content.

**Your primary goal is to create a narrative that tells the story of the framework's evolution in this release, not just to list changes.**

Please follow this process step-by-step:

**Phase 1: Setup and Analysis**

1. **Request Inputs:** To begin, please ask me for the following information:
   * The **previous stable release tag** (e.g., `3.32.0`).
   * The **new stable release tag** we are documenting (e.g., `3.35.0`).
   * A link to a **previous release blog post** to use as a style and tone reference.
2. **Identify Themes:** Once you have the tags, analyze the commit log between them (`git log --oneline <old_tag>..<new_tag>`). Your goal is to identify high-level themes and potential sections for the blog post. Propose a list of these themes to me for approval. Examples of themes include:
   * Accessibility Improvements
   * Material & Cupertino Updates
   * Performance Enhancements
   * Desktop & Multi-Window Support
   * Scrolling & Navigation
   * Text Input

**Phase 2: Iterative Content Creation**

3. **Draft Thematic Sections:** For each theme I approve, you will draft the content for that section.
   * Search the commit log for relevant PRs.
   * **Critically Analyze Each PR:** Before writing about a change, it is crucial to understand its true impact. Do not rely on the PR title alone. Use `gh pr view <PR_NUMBER> --json title,body,files` to thoroughly review its description and the list of changed files. This will help you accurately determine if the change is a user-facing feature, a testing utility, an internal refactor, or something else, ensuring it is described correctly in the blog post.
   * Verify that the selected change has not been reverted and was landed in the release.
     1. For each PR, run `git log --grep "Revert.*#<pr_number>"` to check for reverts.
     2. If a revert commit is found, the original PR has been reverted. You must then check if the change was landed again in a subsequent "reland" PR. The revert commit message or the original PR's discussion on GitHub might mention the reland PR.
     3. If you find a reland PR, verify that it was merged before the release cutoff date/tag using `gh pr view <PR_NUMBER> --json mergeCommit` and `git merge-base --is-ancestor <MERGE_COMMIT> <RELEASE_TAG>`.
     4. If the reland was included in the release, update the blog post to reference the reland PR number.
     5. If the original PR was reverted and not relanded within the release, it must be excluded from the blog post.
   * Group related changes into a cohesive narrative.
   * Draft the section in the terminal for my review.
4. **Draft Breaking Changes and Deprecations Section:** After drafting the thematic sections, you will create a dedicated "Deprecations and Breaking Changes" section.
   * Consult the official Flutter breaking changes documentation at [https://docs.flutter.dev/release/breaking-changes](https://docs.flutter.dev/release/breaking-changes) for a list of potential changes.
   * For each item on the list, use `git log --grep "<keyword>"` and `gh pr list --search "<keyword> in:title"` to find the corresponding pull request. If provided with a specific PR number, use that directly.
   * If a PR is found, verify that it was included in the release using the same process described in step 3\.
   * Use `git diff <old_tag>..<new_tag> -- lib/ | grep -E '^\\+' | grep '@Deprecated'` to find any new deprecations that may not be on the official list.
   * Draft a clear and concise summary of each verified breaking change and deprecation, including links to migration guides where available.
5. **Incorporate Feedback:** I will review each draft and provide feedback. You will incorporate my feedback and present a revised draft. We will repeat this until I approve the section.
6. **Manage the Release Document:**
   * After I approve the *first* section, create a new file at the root of the repository named `X-XX-release.md` (e.g., `3-38-release.md`).
   * For each *subsequent* approved section, you will add it to this document.
7. **Deduplicate Content:** This is a critical step. Before adding a new section to the document, you **must** read the existing content of the file. If a specific change or PR is already mentioned in a previous section, you must handle the duplication by proposing one of the following:
   * Keep the original mention and remove the duplicate from the new section.
   * Move the mention from the old section to the new one if it fits the narrative better there.
   * Merge the content in a way that makes sense.

**Phase 3: Finalization**

7. **Holistic Review:** Once all commit-based sections have been drafted and added to the document, you will perform a final review of the entire framework section. Propose a revised version that includes:
   * A compelling introduction.
   * A concluding summary.
   * Adjustments to section headers, flow, and narrative to ensure the entire piece tells a great story.
8. **Special Announcements:** If I have any announcements that are not based on specific commits (like the plan to unbundle UI libraries), you will help me draft this content with careful attention to my phrasing and add it to the document in an appropriate location.

**Guiding Principles to Follow Throughout:**

*   **Be Specific and Explicit:** When describing changes, especially breaking changes, avoid vague language. For example, instead of saying "related components," explicitly list all the affected widgets, classes, or APIs.
*   **Write a Narrative:** Do not simply list commits or create bulleted lists of changes. Your primary goal is to group related changes and explain *why* they are important to developers. Weave the updates into a compelling story about the framework's evolution in the release.
*   **Use Inclusive Language:** Avoid using "we" or "our team" to foster a sense of community ownership. Instead of "We added a feature," try "A new feature is available" or describe the change from the developer's perspective.
*   **Use Sentence Case for Titles:** All headings and subheadings must use sentence case (e.g., "Material and Cupertino updates"), not title case. This is the Google-wide standard.
*   **Use Descriptive Links:** Link text must be descriptive of the destination, which is critical for accessibility. Avoid generic links like "click here." Instead of "[Read more here](link)", use "[Read the full documentation on X](link)".
*   **Maintain a Consistent Point of View:** Choose a consistent point of view (e.g., "you," "developers") and stick with it. Avoid mixing different perspectives.
*   **Use Present Tense:** Describe changes in the present tense (e.g., "This release adds...") rather than the future or past tense, unless absolutely necessary.
*   **Be Concise:** Eliminate unnecessary words and phrases. The writing should be direct and to the point.
*   **Tone:** The tone should be professional, engaging, and developer-focused, matching the style of the reference blog post: [https://medium.com/flutter/whats-new-in-flutter-3-32-40c1086bab6e](https://medium.com/flutter/whats-new-in-flutter-3-32-40c1086bab6e)
*   **Reference PRs, Not Hashes:** All changes should be attributed to their pull request number (e.g., `[#123456]`), not their commit hash.
*   **Delicate Messaging:** For sensitive topics or major strategic announcements, pay close attention to my feedback on phrasing to ensure the message is communicated clearly and carefully.
*   **Formatting:** Use Markdown for clean formatting, with clear headers and sub-headers for each section.

To start this process next time, I will simply say:

"Hello\! I need your help drafting the framework section for the next Flutter release blog. Please follow the detailed instructions you have for this task."
