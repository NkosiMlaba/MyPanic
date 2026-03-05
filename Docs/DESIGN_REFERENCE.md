# MyPanic — Design Reference

## Brand Identity

**Product Name:** MyPanic
**Tagline:** *Smart, Connected Safety for Women. Stay Loud, Stay Safe.*
**Mission:** Prevent danger before it happens.
**Target User:** Women — in everyday situations: rides, meet-ups, transit, public spaces, campuses.

---

## Logo & App Icon

The official logo consists of three elements stacked vertically:
1. **Hugging Heart icon** — a heart shape (light pink `#EFB2BA`) with a darker pink (`#E58090`) curved embrace element at the bottom, symbolising protection and emotional support for GBV survivors
2. **"MyPanic" wordmark** — bold sans-serif in primary pink (`#E58090`), conveying urgency and personal ownership
3. **Tagline** — "STAY LOUD. STAY SAFE." in small-caps, dark charcoal (`#605757`)

Vector logo: `Docs/logo.svg`
App launcher icon (`ic_launcher.png` / `AppIcon`) is in the platform asset directories.

### Logo Usage Rules
- Keep upright — do not rotate
- Maintain 3:4 aspect proportion — do not stretch or squash
- Place on solid or neutral background only

---

## Color Scheme

### App Theme (Flutter `app_theme.dart`) — **Dark Theme**

| Role | Name | Hex | Flutter |
|---|---|---|---|
| **Primary** | Primary Red | `#E53935` | `Color(0xFFE53935)` |
| **Primary Dark** | Dark Red | `#B71C1C` | `Color(0xFFB71C1C)` |
| **Secondary** | Accent Orange | `#FF6F00` | `Color(0xFFFF6F00)` |
| **Background** | Background Dark | `#0D0D0D` | `Color(0xFF0D0D0D)` |
| **Surface** | Surface Dark | `#1A1A1A` | `Color(0xFF1A1A1A)` |
| **Card** | Card Dark | `#252525` | `Color(0xFF252525)` |
| **Text Primary** | White | `#FFFFFF` | `Color(0xFFFFFFFF)` |
| **Text Secondary** | Light Grey | `#B0B0B0` | `Color(0xFFB0B0B0)` |
| **Text Muted** | Mid Grey | `#757575` | `Color(0xFF757575)` |

### Status / Semantic Colors

| Role | Name | Hex | Flutter |
|---|---|---|---|
| Success | Green | `#4CAF50` | `Color(0xFF4CAF50)` |
| Warning | Yellow | `#FFC107` | `Color(0xFFFFC107)` |
| Error | Red | `#F44336` | `Color(0xFFF44336)` |
| Info | Blue | `#2196F3` | `Color(0xFF2196F3)` |

### Special Mode

| Mode | Background |
|---|---|
| **Stealth Mode** (Alert Active Screen) | `#000000` (pure black) |

---

### Brand / Marketing Color Palette (from Brand Guidelines)

These colors apply to the physical product, social media, and marketing materials — **not** the app UI.

| Role | Hex | Description |
|---|---|---|
| Warm Grey | `#A69D9C` | Neutral tone |
| Dark Charcoal | `#605757` | Text / tagline |
| Blush Background | `#FEEEE` | Page / card background |
| Light Pink | `#EFB2BA` | Heart icon, soft accents |
| Primary Pink | `#E58090` | Logo wordmark, primary brand color |

### Proposal / Presentation Color Palette (PowerPoint theme2.xml)

These are the colors used in the original pitch deck:

| Role | Hex | Swatch |
|---|---|---|
| Dark Primary | `#0E2841` | Deep Navy |
| Light Background | `#E8E8E8` | Off-white Grey |
| Accent 1 | `#156082` | Steel Blue |
| Accent 2 | `#E97132` | Vibrant Orange |
| Accent 3 | `#196B24` | Forest Green |
| Accent 4 | `#0F9ED5` | Cyan Blue |
| Accent 5 | `#A02B93` | Deep Magenta |
| Accent 6 | `#4EA72E` | Lime Green |

---

## Typography

### Brand Typefaces (Marketing / Physical Product)

| Role | Font | Notes |
|---|---|---|
| Primary | **Inter** | Clean, modern sans-serif for all digital and print |
| Secondary | **Poppins** | Geometric sans-serif for headings and pull quotes |

Use font family variants when primary fonts don't suit the content.

### Typography (App)

The app uses Material3 default typography. Key scale from `app_theme.dart`:

| Style | Size | Weight | Usage |
|---|---|---|---|
| `displayLarge` | 72px | Bold | Hero / panic trigger |
| `displayMedium` | 48px | Bold | Large headings |
| `displaySmall` | 36px | Bold | Section headings |
| `headlineLarge` | 28px | SemiBold | Screen titles |
| `headlineMedium` | 24px | SemiBold | Card headings |
| `headlineSmall` | 20px | SemiBold | Sub-headings |
| `bodyLarge` | 18px | Regular | Primary body text |
| `bodyMedium` | 16px | Regular | Secondary text |
| `bodySmall` | 14px | Regular | Captions / muted |

---

## UI Component Patterns

### Buttons
- **Primary (ElevatedButton):** Background `#E53935`, white text, `12px` border radius, `32px` horizontal / `16px` vertical padding, `18px` semibold font
- **Text Button:** `#E53935` foreground, `16px` medium font

### Cards
- Background: `#252525`
- Elevation: 4
- Border radius: `16px`

### Inputs
- Background fill: `#252525`
- No border (default), focused border: `2px` solid `#E53935`
- Border radius: `12px`
- Padding: `16px` on all sides

### App Bar
- Background: `#0D0D0D`
- No elevation
- Centered title, `20px` semibold white

---

## About the Brand

MyPanic exists at the intersection of preparedness and empowerment. The brand embodies **durability, clarity, and action** — safety should be easy, accessible, and backed by compassion.

Paired with the **Isibani Foundation**, MyPanic addresses gender-based violence (GBV), mental health, and community wellness through workshops, online resources, and support networks.

**Brand voice:** Bold, supportive, relentlessly dedicated to creating environments where everyone feels safe.

---

## Product Overview

### MyPanic Whistle Keychain (Physical Product)
A compact silicone whistle keychain — fully mechanical, waterproof, shock-resistant, and durable. Works instantly without charging. Suitable for students, professionals, children, and the elderly.

### MyPanic App
A dark-first, high-contrast mobile app (Flutter — Android & iOS) providing:

**Core MVP Features**
- Instant SOS (manual tap + Bluetooth Clip trigger)
- Trusted Contacts module (add/edit, SMS fallback, push alerts)
- Live Tracking Session (real-time location link for responders)
- Ride Track (monitor route deviation, long stops, unusual movement)
- Safety Trails (pre-register meet-ups with check-in escalation)
- Incident Vault (secure logs: screenshots, notes, session metadata)
- Automatic Escalation Logic (sensor fusion: GPS + accelerometer + BLE disconnect)

**Innovative Features (V1/V1.1)**
- Auto Snatch Detection (motion + BLE state inference)
- Nearby Sister Awareness (silent proximity alert to nearby opted-in users)

**Planned (Post-MVP)**
- Driver/ride risk scoring
- SafePoint Network integration
- Risk heatmaps

### MyPanic Clip Alarm (Hardware)
A discreet wearable Bluetooth panic trigger:

| Spec | Detail |
|---|---|
| Siren | 110–120 dB |
| Connectivity | BLE (Bluetooth Low Energy) |
| Activation | Single/double press |
| Feedback | Haptic + LED |
| QR Code | Links to user's emergency profile |
| Weight | < 30g |
| Battery | 12-month life |
| Form | Keychain clip (bag/clothing) |

### SafePoint Network
Partnering with local establishments to create verified safe havens.

---

## Development Roadmap

| Phase | Duration | Deliverable |
|---|---|---|
| A — Planning & Spec | 2 weeks | Functional spec docs |
| B — Hardware Design & Prototyping | 6 weeks | Prototype PCBs, initial firmware |
| C — App MVP Development | 8 weeks (parallel) | Beta app (Android first, then iOS) |
| D — Hardware Integration | 6 weeks | Firmware v0.9 |
| E — Local Fabrication | 4 weeks | 5–10 prototype units |
| F — Testing & Validation | 6 weeks | Test reports, UX feedback |
| G — Iteration & Quality | 4 weeks | Release candidate MVP |
| H — Pilot Deployment | 8 weeks | Pilot performance report |

**Total:** ~6 months from start to pilot launch

---

## Competitive Landscape

| Competitor | Gap |
|---|---|
| Panic Apps (Namola, Gauteng E-Panic) | Works only within their app, limited accountability |
| Personal Alarms (Birdie, Woke) | No digital escalation or community |
| Ride Safety (Uber/Bolt Share Trip) | No persistent monitoring or community intelligence |
| Life360 | Family tracking, not threat-response oriented |

**Differentiation:** Memory, intelligence, community — proactive + reactive in one ecosystem.

---

## Key Values

- Prevention-first design
- Safety Vault (profiles, info, meet-up data)
- Community Intelligence (anonymous reports)
- Hardware + Software integration (affordable clip triggers loud alarm + digital SOS)
- Partner Dashboard + Safe Spaces (SafePoint Network)

---

---

## Contact

| Channel | Handle / Address |
|---|---|
| Email | mypanic1@gmail.com |
| Facebook | MyPanic Enactus |
| Instagram | my_panic |
| TikTok | MyPanic |

---

## Document History

| Version | Date | Notes |
|---|---|---|
| v1 | January 2026 | Product Definition & Scope (initial) |
| — | 2026 | Pitch deck: *MyPanic Proposal.pptx* |
| v2 | March 2026 | Updated with Brand Guidelines PDF: official logo, brand color palette, typefaces (Inter/Poppins), contact info, product scope (physical whistle + Isibani Foundation) |
