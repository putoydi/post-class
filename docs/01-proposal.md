# Proposal

## The problem, in one sentence

Post-Class addresses unclear and fragmented communication between students and professors by providing one dedicated classroom forum for announcements, questions, and discussions.

## Who it is for

Post-Class is intended for students, teachers, professors, and school communities that need a simple place for class communication.

The goal is to reduce confusion caused by having announcements and questions spread across multiple platforms such as Canvas, Microsoft Teams, and Facebook Messenger. :chatgpt-content-reference{index="0"}

## Core features

- User account registration and login.
- Create a classroom with a unique class code.
- Join an existing classroom using its class code.
- A Classes screen showing all classrooms the logged-in user has joined.
- A Postboard showing only the latest post from each joined classroom that has at least one post.
- A Classboard for each classroom containing the complete post and reply feed.
- Shared classroom posts and one-level replies visible to all members of the same classroom.
- Users can edit their own posts and replies.
- A profile screen showing the current user's account information and logout option.

The original proposal identified account setup, class creation, class joining, Postboard, and Classboard as the main MVP features. :chatgpt-content-reference{index="1"}

## Out of scope, and why

The following features were intentionally left out of the final MVP:

- **Student and professor account roles** — the project was revised so that all users are treated equally as classroom members because the application is designed as an open classroom communication forum. :chatgpt-content-reference{index="2"}
- **Private messaging** — classroom communication was prioritized over one-to-one messaging.
- **Notifications** — considered as a possible stretch goal, but the working core features were prioritized first.
- **Nested replies** — replies were limited to one level to keep the discussion structure simple and achievable within the project timeframe.
- **Post and reply deletion** — editing was prioritized as the more useful content-management feature for the MVP.
- **Advanced moderation** — not required for the core classroom communication workflow.
- **Class status/cancellation feature** — this was originally considered as a stretch feature but became less important after the project shifted toward discussion and announcements. :chatgpt-content-reference{index="3"}

## Data the app remembers, and where it is saved

The application uses Supabase for authentication and PostgreSQL database storage.

| Data | Important fields | Storage |
| --- | --- | --- |
| User account | user ID, email | Supabase Auth |
| Profile | user ID, first name, last name | `profiles` table |
| Classroom | class ID, class name, class code, creator ID | `classes` table |
| Classroom membership | class ID, user ID, joined date | `class_members` table |
| Post | post ID, class ID, author ID, content, created/updated dates | `posts` table |
| Reply | reply ID, post ID, author ID, content, created/updated dates | `replies` table |

All users who belong to the same classroom see the same classroom posts and replies, while each user only sees classrooms that they have joined. This matches the shared-data behavior described in the original proposal. :chatgpt-content-reference{index="4"} :chatgpt-content-reference{index="5"}

## Risks

### Unauthorized classroom access

The main security risk identified in the proposal was that an authenticated user might try to read or write content belonging to a classroom they had not joined.

This was addressed using Supabase Row Level Security policies. Access to classroom data, posts, and replies is restricted using the logged-in user's classroom membership. Users can also only edit content they authored. :chatgpt-content-reference{index="6"}

### Dependence on network and Supabase

The application's core features require internet access because authentication, classrooms, posts, and replies are stored remotely in Supabase.

If Supabase is unavailable or the device has no connection, the main communication features cannot load or update until connectivity is restored.

### Email authentication limits

Supabase's default authentication email service has rate limits. This became noticeable during multi-user testing when several users registered within a short period.

For the academic demonstration, the project was configured and tested with this limitation in mind.

## Changes since the last version

### 2026-09 - Removed account roles

The earlier concept separated users into Student and Professor/Teacher roles. This was removed because Post-Class works better as an open classroom forum where every account can post and reply equally. :chatgpt-content-reference{index="7"}

### 2026-09 - Replaced the class-status dashboard with Postboard

The earlier version focused more heavily on class status information. The design changed to a Postboard that shows the latest post from each joined classroom because announcements and discussions became the main purpose of the application. :chatgpt-content-reference{index="8"}

### 2026-09 - Added a dedicated Classboard

A separate Classboard was introduced so each classroom could have its own complete timeline of posts and replies rather than only appearing as a status card. :chatgpt-content-reference{index="9"}

### 2026-10-04 - Chose Supabase as the final backend

The proposal originally left Firebase as a fallback if Supabase became too difficult within the available time. Supabase was successfully implemented for authentication, PostgreSQL storage, and Row Level Security, so Firebase was not needed. :chatgpt-content-reference{index="10"}

### 2026-10-04 - Finalized the MVP around shared classroom communication

The final version includes authentication, profiles, classroom creation and joining, membership filtering, shared posts and replies, editing, and a Postboard that displays the latest post from each classroom. Stretch features such as private messaging, notifications, roles, and class status were left out so the core application could be completed and tested reliably.