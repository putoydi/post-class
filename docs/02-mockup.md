# Mockup and wireframes

The visual plan for this app. Your wireframes answered what goes where; the
mockup shows what it looks like.

## Mockup

The complete application mockup is available here:

[View the full mockup PDF](assets/mockups.pdf)

## Wireframes

The complete wireframe and screen-flow document is available here:

[View the full wireframes PDF](assets/wireframes.pdf)

NOTE: This was the early, unrevised, initial topic version of the program. It is
far different from the current version of the application and the Mockups

## Screens

### Auth Screen

The Auth Screen is the first screen shown to users who are not signed in. It contains forms for both login and account registration.

Users can:
- Sign in using their email and password.
- Switch to the sign-up form.
- Create an account using their first name, last name, email, and password.

After successful authentication, the user is taken to the Postboard.

### Postboard

The Postboard is the main home screen of the application. It shows the latest post from each joined classroom that currently has at least one post.

Users can:
- Open a classroom by selecting one of the displayed class cards.
- Switch to the Classes view using the bottom navigation.
- Open their profile.
- Create or join a classroom.

Selecting a class opens its Classboard.

### Classes Screen

The Classes screen shows all classrooms that the user has joined, including classrooms that do not yet have any posts.

Users can:
- Open a classroom.
- Create a new classroom.
- Join an existing classroom using a class code.

Selecting a classroom opens its Classboard.

### Classboard

The Classboard is the discussion area for a specific classroom. It displays all posts made in that class together with their replies.

Users can:
- Create a new post.
- Reply to an existing post.
- Edit their own posts.
- Edit their own replies.
- View posts and replies made by other classroom members.

Edited content is marked with an `edited` indicator.

### Create Class

The Create Class screen allows a user to create a new classroom by entering a class name.

After creation:
- A unique six-character class code is generated.
- The creator is automatically added as a member of the classroom.
- The new class becomes available in the user's Classes screen.

### Join Class

The Join Class screen allows users to enter a classroom's six-character class code.

If the code is valid:
- The user is added to the classroom.
- The classroom appears in the user's Classes screen.
- The user can open its Classboard and participate in the discussion.

### Profile Screen

The Profile screen displays the signed-in user's account information.

Users can:
- View their name and account details.
- Sign out of the application.

Signing out returns the user to the Auth Screen.