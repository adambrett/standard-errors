---
title: Standard Errors
description: A small standard for user-facing failure messages.
draft: false
---

## Summary

Standard Errors is a small standard for user-facing failure messages.

It gives every unexpected failure clear content: what happened, what was affected, what to do next, and a stable code that support and engineering teams can search for.

A Standard Errors diagnostic includes these fields:

| Field | Required | Purpose |
| --- | --- | --- |
| Severity | Yes | The kind of failure: `Error`, `Warning`, or `Notice`. |
| Code | Yes | A stable, unique identifier for the class of problem. |
| Summary | Yes | A short statement of what failed. |
| Description | Yes | What happened and, when known, why it happened. |
| Impact | When needed | What was affected or left untouched. |
| Resolution | For errors and warnings | What the user can do next, or the best available way out. |
| Reference | No | A useful help, status, support, or runbook link. |
| Trace ID | When useful | A safe per-occurrence identifier for support and engineering. |

This standard defines what information a diagnostic contains. It does not define the visual layout, punctuation, labels, ordering, component shape, or transport format.

Use Standard Errors when something broke unexpectedly. Do not use it for normal product outcomes such as validation feedback, permission denial, quota limits, file size limits, empty states, or upgrade prompts.

---

## Specification

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

1. A diagnostic MUST describe an unexpected system failure.
2. A diagnostic MUST include a severity, code, summary, and description.
3. Severity MUST be `Error`, `Warning`, or `Notice`.
   1. `Error` means the requested operation failed.
   2. `Warning` means the operation completed with an unexpected limitation or degraded result.
   3. `Notice` means something failed outside the current operation, usually in the background.
4. The code MUST be stable, unique across the codebase, visible to the user, and easy to search for. A source search for the code SHOULD lead an engineer to the line that generated the diagnostic.
5. The summary MUST say what failed in plain language.
6. The description MUST explain what happened. The description SHOULD explain why it happened in non-technical language.
7. The impact SHOULD say what was saved, sent, charged, deleted, changed, or left untouched when that is not obvious.
8. Errors and warnings MUST include a resolution with a concrete next step, or a clear way out when the user cannot fix the issue.
9. A reference MAY link to help docs, a status page, support instructions, or a runbook the audience can access.
10. A trace ID SHOULD be included when it helps support or engineering find the specific occurrence.
11. A diagnostic MUST NOT expose stack traces, raw exception messages, secrets, tokens, private data, SQL errors, internal hostnames, or internal service names.
12. A diagnostic MUST NOT hide a known specific failure behind a generic message such as `Something went wrong`.

---

## Fields

### Severity

Use one of these values:

- `Error` - the operation failed.
- `Warning` - the operation completed, but part of it failed or degraded.
- `Notice` - a background or related failure needs attention, but not immediate action.

### Code

The code identifies the class of problem. It is for support, docs, and source search. It should be unique across the codebase so a search leads an engineer directly to the line that generated the diagnostic.

Good codes are short and stable:

```text
AUTH001
EXPORT002
PAYMENT003
```

Do not put timestamps, user IDs, environment names, or trace IDs in the code.

### Summary

The summary is a short statement of what happened.

Good:

```text
Could not save changes
```

Bad:

```text
Something went wrong
```

### Description

The description explains the failure without leaking implementation detail. It should say why the failure happened when the product knows enough to say so.

Use plain, user-friendly cause language, such as `due to a technical issue on our end`, `because the connection was interrupted`, or `because file storage did not respond in time`. Do not expose raw dependency names, stack traces, database errors, exception messages, or internal service names.

Say what happened, why it happened, and what did not happen when the user might worry about it. Keep it short.

### Impact

Impact explains the result for the user. Include it when the consequence is not obvious.

Useful impact answers questions like:

- Was anything saved, sent, charged, created, deleted, or changed?
- Is the current work safe?
- Can the user keep going with a partial result?
- Which file, account, workspace, or operation is affected?

### Resolution

Resolution tells the user what to do next.

Good resolutions are concrete:

- Retry now.
- Retry later.
- Use the partial result.
- Contact support and include this message.
- Ask an administrator to fix a dependency or setting.
- A concrete series of steps to follow or commands to run.

Do not tell the user to do something unsafe, impossible, or unrelated.

### Reference

Reference is optional, but preferred. Use it to link to help docs, support instructions, status pages, or runbooks that provide more information on the issue or resolutions.

### Trace ID

Trace ID is optional. It identifies one occurrence of the problem. It must be safe to share and copy as one value. It should be included when it helps support or engineering find the specific occurrence in logs, traces, or monitoring systems. It should not be included when it does not help or when it would be too difficult to correlate.

The **code** identifies the kind of problem. The **trace ID** identifies this instance of that problem.

---

## FAQ

### Why use Standard Errors?

Standard Errors gives users clear, calm messages, gives support a code to ask for, helps engineers search for the exact diagnostic, connects logs and traces to what the user saw, and avoids a mix of vague, scary, and inconsistent failures.

### Is this an API error format?

No. It is for messages shown to people. APIs, logs, metrics, traces, and exceptions may carry the same code or trace ID, but they are separate formats.

### Should validation errors use Standard Errors?

No. Validation feedback is a normal product outcome. Use ordinary field or form guidance instead.

### Should permission errors use Standard Errors?

Usually no. If the permission system is working as designed, explain the policy in normal product language. Use Standard Errors only when the system failed in an unexpected way.

### Do notices replace status messages?

No. Notices are only for unexpected failures outside the current operation.

### Does Standard Errors define the layout?

No. A CLI, web app, mobile app, modal, toast, banner, or dialog can present the fields however it needs to. Keep the same meaning and make the message easy to copy or screenshot.

### What makes a code good?

A good code is stable, unique, and searchable. When an engineer searches for the code, they should find the place that generated the diagnostic.

---

## Examples

These examples show the same content contract in different surfaces. They are not required layouts.

### CLI: error

```text
Error: EXPORT001 - Could not create export

The export did not finish because file storage did not respond in time.

No export file was created. Project records and attached files were not downloaded.

Wait a few minutes, then run the export again. If it keeps failing, contact support and include this message.

Reference: https://www.example.com/help/export-failed
Trace ID: req_01HX7J3Q9R6W4N2Z0K5M8B1C2D
```

### CLI: warning

```text
------------------------------------------------------------------------
Warning: EXPORT002 - Export completed without attachments
------------------------------------------------------------------------

The export file was created, but attachments could not be added because file storage did not respond before the export finished.

The export includes project records. Attached files are missing.

To resolve:

  * Use this export if you only need project records.
  * Wait a few minutes, then run the export again.
  * If attachments are still missing, contact support and include this message.

------------------------------------------------------------------------
Reference: https://www.example.com/help/export-attachments
Trace ID: req_01HX7J3Q9R6W4N2Z
------------------------------------------------------------------------
```

### Web

This modal puts the user-facing message first and keeps the support identifiers in a quiet footer.

<figure class="ui-example ui-example-web">
  <div class="web-stage">
    <section class="ui-card ui-card-modal" aria-labelledby="web-example-title">
      <button class="ui-close" type="button" aria-label="Close">×</button>
      <h4 id="web-example-title">Unable to connect your account</h4>
      <p class="ui-status">Error · account.connection.unavailable</p>
      <p>Your changes were saved, but we could not connect your account due to a technical issue on our end. Please try connecting again.</p>
      <p>If the issue keeps happening, contact Customer Care. You can also read the <a href="https://www.example.com/help/account-connection">account connection help</a>.</p>
      <div class="ui-actions">
        <button type="button" class="ui-button ui-button-secondary">Cancel</button>
        <button type="button" class="ui-button ui-button-primary">Try Again</button>
      </div>
      <footer class="ui-trace">Trace ID: web-8fa4-7c21</footer>
    </section>
  </div>
</figure>

### Mobile

This mobile notice uses a compact in-app card instead of a modal.

<figure class="ui-example ui-example-mobile">
  <div class="phone-shell">
    <div class="phone-screen">
      <section class="mobile-alert" aria-labelledby="mobile-example-title">
        <div class="mobile-alert__meta">
          <span class="mobile-badge">Notice</span>
          <span>sync/offline/not-sent</span>
        </div>
        <h4 id="mobile-example-title">Saved on this phone</h4>
        <p>Your changes are safe here, but they have not synced because the connection dropped before upload finished.</p>
        <p>Keep the app open to try again. If sync does not finish, contact support and include this message. You can also check <a href="https://www.example.com/help/mobile-sync">sync help</a>.</p>
        <footer class="ui-trace">Trace ID: SNC-94217</footer>
      </section>
    </div>
  </div>
</figure>

### Desktop GUI

This desktop banner fits into the app surface and pairs the action with the support detail.

<figure class="ui-example ui-example-desktop">
  <div class="desktop-window">
    <div class="desktop-bar">
      <span></span>
      <span></span>
      <span></span>
    </div>
    <section class="desktop-banner" aria-labelledby="desktop-example-title">
      <div class="desktop-banner__heading">
        <h4 id="desktop-example-title">Backup finished without project media</h4>
        <span class="desktop-severity">Warning</span>
      </div>
      <p class="desktop-meta">Backup.Media.Partial</p>
      <p>The project backup was created, but the app could not copy media files because the media drive stopped responding.</p>
      <p>The backup includes project settings and timelines. Video and audio files are missing. For more help, see <a href="https://www.example.com/help/project-backups">project backup help</a>.</p>
      <footer class="desktop-footer">
        <button type="button" class="ui-button ui-button-primary">Run Backup Again</button>
        <span class="ui-trace">Trace ID: backup-78244.12</span>
      </footer>
    </section>
  </div>
</figure>
