# Design system

![Design system (PDF)](assets/design-system.pdf)

## Palette

Post-Class uses a light, paper-inspired visual style with a cream background, colorful sticky-note cards, and blue interactive accents.

| Purpose | Color |
| --- | --- |
| Main background | `#FFFDD0` |
| Login / signup container | `#CEDEFF` |
| Text box | `#FFFFFF` |
| Normal text, icons, outlines | `#000000` |
| Placeholder text | `#747272` |
| Selected icon / primary accent | `#0055FF` |
| Hyperlink text | `#00AAFF` |
| Alert / destructive action | `#FF4347` |

### Sticky-note colors

| Color | Hex |
| --- | --- |
| Pink | `#FFCEE0` |
| Yellow | `#FFF080` |
| Green | `#B6EF9D` |
| Light blue | `#6ED8FA` |
| Light gray | `#F5F6F8` |
| Purple | `#C8C2FF` |

### Sticky-note header colors

| Color | Hex |
| --- | --- |
| Pink header | `#D9ADBD` |
| Green header | `#8EC577` |
| Yellow / gold header | `#CEC163` |
| Blue header | `#5AB3CF` |
| Gray header | `#BCBCBC` |
| Purple header | `#A39ED0` |

These colors are used to visually distinguish classroom cards while keeping the overall interface consistent. :chatgpt-content-reference{index="0"}

## Type scale

Post-Class uses two main font families:

- **Playfair Display** for screen headings.
- **Inter** for interface text, form fields, captions, and content.

| Style | Flutter slot | Size | Weight | Font | Used for |
| --- | --- | ---: | --- | --- | --- |
| Heading | `headlineSmall` | 24 | Regular | Playfair Display | Screen titles such as Postboard, Classboard, and Profile |
| Body | `bodyMedium` | 16 | Regular | Inter | Normal text, posts, replies, cards, and form inputs |
| Caption | `labelSmall` | 12 | Regular | Inter | Placeholder text, hints, timestamps, and secondary information |

The submitted design system defined the same 24 / 16 / 12 type hierarchy using Playfair Display and Inter. :chatgpt-content-reference{index="1"}

## Spacing

The application uses a simple spacing scale based around an 8-pixel rhythm.

| Token | Size |
| --- | ---: |
| `xs` | 4 px |
| `sm` | 8 px |
| `md` | 16 px |
| `lg` | 24 px |
| `xl` | 32 px |

General usage:

- Screen edge padding: `16 px`
- Small gaps between elements: `8 px`
- Standard list/card gaps: `8–16 px`
- Gaps between major sections: `24 px`

This keeps the layout consistent across authentication forms, Postboard cards, Classboard content, and modal forms. :chatgpt-content-reference{index="2"}

## Components

| Component | File | Main parameters | Used on |
| --- | --- | --- | --- |
| `ClassCard` | `lib/widgets/class_card.dart` | `className`, `code`, `latestPost`, `backgroundColor`, `headerColor`, `onTap` | Postboard, Classes |
| `PrimaryButton` | `lib/widgets/primary_button.dart` | `label`, `onPressed`, `backgroundColor` | Authentication, Create Class, Join Class |
| `CustomInputField` | `lib/widgets/custom_input_field.dart` | `hintText`, `controller`, `isObscure`, `prefixIcon` | Authentication, Create Class, Join Class |
| `PostTile` | `lib/widgets/post_tile.dart` | `authorName`, `timestamp`, `content`, `replyCount`, `onTap` | Postboard, Classboard |
| `EmptyState` | `lib/widgets/empty_state.dart` | `message`, `icon` | Postboard, Classboard |

These reusable components were originally defined to keep the interface visually and structurally consistent across screens. :chatgpt-content-reference{index="3"}

## Changes since the last version

### 2026-09 - Established the sticky-note visual system

The design moved toward a classroom-board visual style using a cream background and multiple pastel sticky-note colors. This made classroom cards easier to distinguish while keeping the application visually consistent.

### 2026-09 - Standardized typography

Playfair Display was kept for major screen headings, while Inter was used for interface content and smaller text. This created a clearer distinction between page titles and functional UI text.

### 2026-10-04 - Updated components for the working MVP

The original component system was retained, but the final app connected these components to real Supabase-backed data rather than static mock content.

Class cards now represent real joined classrooms, while Postboard and Classboard content is generated from database data.

### 2026-10-04 - Kept the light-only design

Dark mode was not added to the final MVP. The project remains focused on the original light, paper-inspired color palette defined in the submitted design system. :chatgpt-content-reference{index="4"}