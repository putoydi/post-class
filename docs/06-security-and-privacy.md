# Security and privacy

This repository is public. The security and privacy setup below reflects the final Post-Class implementation.

**Last checked:** 2026-10-04

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Account email | Supabase Auth | The account owner and Supabase authentication service |
| First and last name | Supabase `profiles` table | Authenticated users, as required to display post and reply authors |
| Classroom information | Supabase `classes` table | Users who are members of that classroom |
| Classroom membership | Supabase `class_members` table | Authorized classroom members |
| Posts | Supabase `posts` table | Members of the classroom containing the post |
| Replies | Supabase `replies` table | Members of the classroom containing the related post |

Post-Class does not store passwords directly. Password authentication is handled by Supabase Auth.

## Secrets

- Values my app needs at run time:
  - Supabase project URL
  - Supabase publishable client key
- Where they live locally: the Supabase project URL and publishable key are currently configured in the Flutter client rather than in a `.env` file.
- Where the deploy workflow gets them: no separate GitHub Actions repository secrets are currently required for these values because they are included in the Flutter web client configuration.
- Anything my deployed web build carries that a visitor could read, and why that is acceptable: the Supabase project URL and publishable client key can be present in the deployed client. The publishable key is intended for client-side use and does not provide unrestricted database access. Database access is controlled by Supabase Row Level Security policies.
- No Supabase `service_role` key, database password, or other server-side secret should be included in the repository or deployed Flutter application.

## What protects the data on the service side

Supabase Row Level Security (RLS) is enabled for the application's database tables.

The main access rules are:

- Authenticated users can access classroom information only when they are members of that classroom.
- Classroom membership is used to determine whether a user may read classroom posts and replies.
- A user creating a post or reply must be authenticated and must belong to the related classroom.
- Users may edit only posts and replies that they authored.
- Creating a classroom automatically adds its creator as a classroom member.
- Joining a classroom is performed using the classroom's unique code.
- Profile data is associated with the authenticated Supabase user ID.

These policies prevent a user from gaining access to another classroom simply by supplying or guessing its database ID.

## Checklist

- [ ] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed — **Not applicable: this project does not currently use a `.env` file**
- [ ] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [x] No service account file, keystore or Supabase `service_role` key is intentionally included in the repo
- [x] Supabase RLS policies have been written and tested
- [ ] No real personal data appears in sample data, screenshots, or the demo video
- [ ] No course or university login credentials appear anywhere in the repository
- [ ] Anyone whose personal data appears in testing gave permission

No server-side secret key was intentionally added to the application. If a secret is discovered during the final repository check, it should be revoked and replaced before submission.