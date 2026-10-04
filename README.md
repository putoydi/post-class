<!--
  This is your project's front page. Replace every placeholder below.
  It is the first thing your instructor and any future employer will read, and
  the live link in it is how your project gets opened for grading.

  New here? Read START-HERE.md first. Delete this comment when you are done.
-->

# Post-Class

> A forum application for students and teachers with respective class discussions to promote transparency and better communication in and out of the classroom.

**Live demo:** https://putoydi.github.io/post-class/ <!-- GitHub Pages is set up already; replace if you host elsewhere -->
**Demo video:** `docs/demo.mp4` (link it here once it exists)
**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University
**Author:** Gil M. Miranda III

This repository lives in the author's own GitHub account and is public on
purpose. There is no `student.json` here and there should not be one: see
`docs/06-security-and-privacy.md` for what a public repo means for secrets and
personal data.

---

## Screenshots

Put two or three real screenshots at phone size in `docs/assets/`, then replace
this paragraph with them:

```markdown
| Home | Detail | Add |
| --- | --- | --- |
| ![Home](docs/assets/screen-home.png) | ![Detail](docs/assets/screen-detail.png) | ![Add](docs/assets/screen-add.png) |
```

A repo without screenshots reads as abandoned, whatever the code says.

## What it does

- Lets users register, log in, and maintain their own account profile.
- Lets users create classrooms with unique six-character codes or join existing classrooms using a code.
- Provides a shared Classboard where class members can create posts and reply to discussions.
- Allows users to edit their own posts and replies, with edited content clearly marked.
- Shows the latest post from each joined class on the Postboard while keeping empty classes available in the Classes screen.

## Built with

| | |
| --- | --- |
| Framework | Flutter (Dart) |
| State | `setState` |
| Storage / Backend | Supabase |
| Database | PostgreSQL through Supabase |
| Authentication | Supabase Auth |
| Other packages | `supabase_flutter` for authentication and database access; `google_fonts` for typography |

## Running it yourself

```bash
flutter pub get
flutter run -d web-server --web-port 8080

Then open http://localhost:8080. Requires Flutter (run `flutter --version` and
put yours here).

### Environment variables

This project does not currently require a local `.env` file.

The Supabase project URL and publishable client key are configured directly in the Flutter application. The publishable key is intended for client-side use and is protected by Supabase Row Level Security policies.

No Supabase `service_role` key, database password, or other server-side secret is included in the repository.

## Privacy and secrets

Post-Class stores user account information such as email address, first name, last name, classroom memberships, posts, and replies in Supabase.

The application does not use a local `.env` file. The Supabase project URL and publishable client key are used by the Flutter client, while access to classroom data is protected on the backend using Supabase Row Level Security policies. No `service_role` key, database password, or other server-side secret is included in the repository.

All sample data, screenshots, and demo materials used for submission should avoid real personal information and should use test accounts or non-sensitive example content.

## Project documentation

| Document | |
| --- | --- |
| [Proposal](docs/01-proposal.md) | the problem, the users, the scope |
| [Mockup and wireframes](docs/02-mockup.md) | what it looks like, and the screen flow |
| [Design system](docs/03-design-system.md) | colors, type, spacing, components |
| [Weekly reports](docs/04-weekly-reports.md) | what happened each week |
| [Demo video](docs/05-demo-video.md) | the recording and what it shows |
| [Start here](START-HERE.md) | how this repo works (delete once you have read it) |
| [Security and privacy](docs/06-security-and-privacy.md) | the checklist, filled in |

## Status and what is next

The core MVP is working. Users can register and log in, create or join classrooms, view only the classes they belong to, create posts, reply to posts, edit their own content, and see the latest post from each joined class on the Postboard.

Known limitations include the lack of password reset, notifications, post deletion, nested replies, and advanced moderation. These were intentionally left out to keep the project focused on the main classroom communication workflow.

If development continued, the next improvements would be notifications for new posts and replies, better account recovery, improved moderation tools, and additional UI polish for larger screens.

## Credits

- Packages: see `pubspec.yaml`
- Backend and authentication: Supabase
- Fonts: Google Fonts through the `google_fonts` Flutter package
- Icons: Flutter Material Icons
- UI design, mockups, and application concept: Gil Miranda III
- AI assistance: ChatGPT by OpenAI was used for Supabase integration, database and Row Level Security design, debugging, feature implementation, and deployment guidance. See [AI-USAGE.md](AI-USAGE.md) for details.

## AI use

[![Built with AI assistance](https://img.shields.io/badge/built%20with-AI%20assistance-0b5fff)](AI-USAGE.md)

This project was developed with substantial assistance from ChatGPT by OpenAI, particularly for Supabase integration, database and Row Level Security logic, debugging, feature implementation, and GitHub Pages deployment.

See [AI-USAGE.md](AI-USAGE.md) for the full record of AI-assisted work, corrections, and authorship.

## Licence

MIT, see [LICENSE](LICENSE).
