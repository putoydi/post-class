# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.

## 1. How I used AI

### 2026-10-04 - Supabase authentication integration

- **Tool:** ChatGPT
- **What I asked for:** I asked for help connecting my existing Flutter login and signup interface to Supabase Authentication without rebuilding the UI I had already made.
- **What it gave back:** ChatGPT provided the Supabase Flutter authentication methods for signing up and signing in, including `signUp()` and `signInWithPassword()`. It also suggested storing the user's first name and last name as account metadata and handling authentication errors using snackbars.
- **What I kept, what I changed, and why:** I kept the Supabase authentication logic and integrated it into my existing `AuthScreen`. I kept my original visual design, controllers, and navigation structure instead of replacing the screen with a generated one. I also tested the authentication using multiple accounts to confirm that invalid credentials were rejected and valid users could log in.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - Creating and joining classrooms with Supabase

- **Tool:** ChatGPT
- **What I asked for:** I asked for help implementing the Create Class and Join Class features using Supabase, including automatically generating a unique six-character class code and making sure users only saw classes they had joined.
- **What it gave back:** ChatGPT suggested the `classes` and `class_members` database structure, SQL functions for creating a class and joining through a class code, and Row Level Security policies for restricting access based on membership.
- **What I kept, what I changed, and why:** I kept the database structure and RPC-based approach because it made the Flutter code simpler and ensured class creation and membership happened together. I connected the functions to my existing Create Class and Join Class modals instead of replacing those interfaces. I tested the feature using two separate accounts and confirmed that the second account initially saw no classes, then saw the shared classroom only after joining with the correct code.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - User profiles and real logout behavior

- **Tool:** ChatGPT
- **What I asked for:** I asked for help replacing the hardcoded profile name with the currently logged-in user's real name and making the Logout button actually sign the user out of Supabase.
- **What it gave back:** ChatGPT provided a query to retrieve the current user's first and last name from the `profiles` table and used `Supabase.instance.client.auth.signOut()` before navigating back to the authentication screen.
- **What I kept, what I changed, and why:** I kept the database lookup and real sign-out logic while preserving my original Profile screen design. I tested the feature with two different accounts and confirmed that each account showed its own name and that logging out correctly ended the Supabase session.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - Shared Classboard posts and replies

- **Tool:** ChatGPT
- **What I asked for:** I asked for help turning my Classboard mockup into a real shared forum where members of the same classroom could create posts and reply to them.
- **What it gave back:** ChatGPT suggested the `posts` and `replies` tables, their relationships to users and classrooms, Row Level Security policies, and Flutter code for loading posts, creating new posts, and adding one-level replies.
- **What I kept, what I changed, and why:** I kept the database design and one-level reply structure because nested Reddit-style comments were outside the scope of my MVP. I kept the visual structure of my existing Classboard and replaced its hardcoded example content with real Supabase data. I tested the feature between two accounts and confirmed that posts and replies made by one user were immediately visible to the other classroom member after refreshing.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - Dynamic Postboard showing the latest classroom post

- **Tool:** ChatGPT
- **What I asked for:** I asked for help replacing the sample Postboard data with real Supabase data while keeping the requirement that only the latest post from each joined classroom should appear.
- **What it gave back:** ChatGPT provided logic that loads the user's joined classes, retrieves posts from those classes ordered from newest to oldest, stores only the first post found for each class, and excludes classrooms that do not have any posts.
- **What I kept, what I changed, and why:** I kept the latest-post selection logic because it matched my original project requirement. I retained my sticky-note Postboard design and only replaced the fake course data with real Supabase data. I also tested the behavior by creating an empty class and confirmed that it appeared in the Classes screen but did not appear in the Postboard until it had a post.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - Editing posts and replies

- **Tool:** ChatGPT
- **What I asked for:** I asked for help adding editing to posts and replies so that only the original author could edit their own content and other users could see that the content had been changed.
- **What it gave back:** ChatGPT used the existing `updated_at` fields and suggested Edit buttons that only appear when the current user's ID matches the content's `author_id`. It also provided logic for comparing `created_at` and `updated_at` and displaying an `edited` indicator when they differ.
- **What I kept, what I changed, and why:** I kept the author-only editing approach because it matched the permissions I wanted and worked with the Row Level Security policies already in place. I did not add deletion or version history because those were not necessary for the MVP. I tested editing using both accounts and confirmed that users could only edit their own posts and replies while everyone could see the updated content.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### 2026-10-04 - Deploying the Flutter app with GitHub Pages

- **Tool:** ChatGPT
- **What I asked for:** I asked for help deploying the Flutter project as a live web application using my existing GitHub repository so that the project could be opened through a URL.
- **What it gave back:** ChatGPT explained how Flutter Web builds work, how to use the `/post-class/` base path for a GitHub project page, and how to create a GitHub Actions workflow that builds the Flutter web application and deploys `build/web` to GitHub Pages automatically.
- **What I kept, what I changed, and why:** I kept the GitHub Actions approach because it allows the application to rebuild and redeploy automatically whenever I push updates to the repository. I created the required `.github/workflows/deploy.yml` structure and used the repository-specific base path. I also kept the `--no-tree-shake-icons` option after the normal release build failed during icon font subsetting.
- **Commit:** [https://github.com/putoydi/post-class/commit/849a9fb](https://github.com/putoydi/post-class/commit/849a9fb)

## 2. Where the AI got it wrong

### Case 1 - Outdated Supabase email confirmation instructions

- **What it gave me:** ChatGPT initially told me to disable the `Confirm Email` option through a specific path in the Supabase Authentication dashboard so that newly created accounts could log in immediately during development.
- **What was wrong with it:** The dashboard instructions did not match the current Supabase interface I was using. When I opened the Email provider settings, the `Confirm Email` option was not present where ChatGPT said it would be. Following the instructions literally would have meant changing unrelated authentication settings or wasting time looking for an option in the wrong place.
- **What I did instead:** I checked the actual Supabase dashboard myself and showed the current settings to ChatGPT. Instead of changing unrelated options, I kept the authentication code able to handle both cases: an account receiving a session immediately or requiring email confirmation. I then continued testing the real signup and login flow rather than depending on the outdated dashboard instructions.
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)

### Case 2 - Postboard did not refresh from every navigation path

- **What it gave me:** ChatGPT gave me code that refreshed the Postboard after returning from a Classboard opened through the Postboard itself.
- **What was wrong with it:** The same refresh behavior was initially missing when a Classboard was opened through the Classes tab. This meant a user could open a class from Classes, create a new post, return, and then switch to Postboard while still seeing the old latest post until another refresh happened.
- **What I did instead:** I reviewed the navigation flow and changed the Classes-tab `Navigator.push()` call to `await` the Classboard screen. After returning, I called the same `_refreshData()` method used elsewhere. This made the Postboard update correctly regardless of which screen was used to open the Classboard.
- **Commit:** [https://github.com/putoydi/post-class/commit/b123941](https://github.com/putoydi/post-class/commit/b123941)

### Case 3 - Forcing a 430-pixel web layout did not create a real mobile experience

- **What it gave me:** ChatGPT suggested wrapping the Flutter web application in a `ConstrainedBox` with a maximum width of about 430 pixels so that the deployed version would always look like a mobile application on desktop browsers.
- **What was wrong with it:** After testing it, I noticed that the change only made the application visually narrow. It did not make a desktop browser behave like a touchscreen or actually reproduce a mobile device environment. It also made the web deployment less natural because the application was being artificially constrained instead of remaining responsive.
- **What I did instead:** I removed the forced mobile-width wrapper and restored the normal responsive Flutter web layout. For demonstrations where I need to show the mobile presentation, I can use the browser's device emulation tools instead of changing the application's actual layout behavior.
- **Commit:** [https://github.com/putoydi/post-class/commit/2ea026e](https://github.com/putoydi/post-class/commit/2ea026e)

## 3. Who wrote what

### Written by me

- **File:** `lib/theme/app_colors.dart` and `lib/theme/app_theme.dart`
- **Commit:** [https://github.com/putoydi/post-class/commit/68bfd45](https://github.com/putoydi/post-class/commit/68bfd45)
- **What it does and why it is built this way:** I created the visual theme and color system for the application based on my own design system. The colors are separated into reusable constants so the same background, sticky-note, header, text, and accent colors can be used consistently across multiple screens. I also used a shared Flutter theme instead of styling every text element independently so the interface would remain visually consistent and easier to maintain.

- **File:** `lib/widgets/class_card.dart`
- **Commit:** [https://github.com/putoydi/post-class/commit/78a43b9](https://github.com/putoydi/post-class/commit/78a43b9)
- **What it does and why it is built this way:** I wrote the reusable classroom card used for displaying classroom information in the application. It accepts values such as the class name, class code, colors, latest post, and tap action instead of hardcoding one specific classroom. I built it as a reusable widget because the same type of classroom information appears repeatedly, and keeping the layout in one widget avoids duplicating the same UI code.

- **File:** `lib/widgets/custom_input_field.dart` and `lib/widgets/primary_button.dart`
- **Commit:** [https://github.com/putoydi/post-class/commit/68bfd45](https://github.com/putoydi/post-class/commit/68bfd45)
- **What it does and why it is built this way:** I created reusable input and button widgets for forms such as Login, Sign Up, Create Class, and Join Class. The input widget centralizes the appearance of text fields, including placeholder text, icons, and password hiding. The button widget keeps the main action buttons visually consistent. I used reusable components because these controls appear on several screens and I did not want to repeat their styling every time.

- **File:** `lib/screens/auth_screen.dart`
- **Commit:** [https://github.com/putoydi/post-class/commit/78a43b9](https://github.com/putoydi/post-class/commit/78a43b9)
- **What it does and why it is built this way:** I built the original authentication screen layout and the toggle between Login and Sign Up before the Supabase logic was added. The screen changes which fields are visible depending on whether the user is logging in or registering, while keeping both states in the same screen. I chose this design because the two forms share most of the same layout and navigation, so a toggle is simpler than maintaining two separate screens.

- **File:** `lib/screens/postboard_screen.dart` and `lib/screens/classboard_screen.dart` (original UI structure)
- **Commit:** [https://github.com/putoydi/post-class/commit/78a43b9](https://github.com/putoydi/post-class/commit/78a43b9)
- **What it does and why it is built this way:** I created the original visual structure for the Postboard, Classes view, and Classboard based on my project mockups. The Postboard used sticky-note style cards to represent classes, while the Classboard used a separate header, class information banner, and content area. Later, the hardcoded sample data was replaced with Supabase data, but the basic screen design and visual organization remained based on the UI I had already built.

### The AI-written part I understand best

- **File:** `lib/screens/postboard_screen.dart`
- **Commit:** [https://github.com/putoydi/post-class/commit/48903a9](https://github.com/putoydi/post-class/commit/48903a9)
- **What it does and why we kept it:** The AI-assisted part I understand best is the logic that loads the Postboard from Supabase. The code first retrieves the classes visible to the logged-in user. Row Level Security already limits this result to classes the user belongs to. It then gets the posts belonging to those class IDs and orders them from newest to oldest. Because the posts are already sorted, the code keeps only the first post it encounters for each class, which becomes that class's latest post. Classes without any posts are not added to the Postboard, so they still appear in the Classes screen but not in the main feed. We kept this implementation because it directly matches the requirement that the Postboard show only one latest post per joined class while keeping the full post history inside the Classboard.