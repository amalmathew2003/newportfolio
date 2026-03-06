# Amal Mathew — Portfolio

A modern, responsive portfolio built with **Flutter** featuring a dual-theme design system (dark neon cyberpunk / light editorial), smooth animations, and seamless navigation.

## ✨ Features

- **Dual Theme** — Dark (Neon Cyberpunk) and Light (Elegant Editorial) modes
- **Responsive Design** — Desktop and mobile layouts with adaptive navigation
- **Mesh Gradient Background** — Animated gradient blobs with blur effects
- **Scroll Animations** — FadeIn/FadeInUp with visibility detection
- **Project Showcase** — Expandable project cards with image galleries & video playback
- **CV Download** — Cross-platform (web + mobile/desktop) CV download
- **Contact Section** — Email CTA, LinkedIn & GitHub social links

## 🛠 Tech Stack

| Tool | Usage |
|------|-------|
| Flutter | Framework |
| Dart | Language |
| Provider | State management (theme toggle) |
| Google Fonts | Typography (Inter, Space Grotesk, JetBrains Mono, Playfair Display) |
| animate_do | Entry animations |
| visibility_detector | Scroll-triggered animations |
| Chewie / video_player | Project demo videos |
| url_launcher | External links |
| Dio | CV file download (mobile/desktop) |

## 🚀 Getting Started

```bash
# Clone the repository
git clone https://github.com/amalmathew2003/newportfolio.git

# Install dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Run on a connected device
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── constants/
│   └── app_colors.dart       # Design tokens
├── data/
│   ├── projects_data.dart    # Portfolio project data
│   └── social_links.dart     # Social links & personal info
├── screen/
│   ├── main_page.dart        # Root scaffold, navigation, background
│   ├── desktop_screen.dart   # Hero / landing section
│   ├── aboutme.dart          # About me section
│   ├── skills_screen.dart    # Skills marquee section
│   ├── experience_screen.dart# Work experience timeline
│   ├── projects_screen.dart  # Project cards section
│   ├── project_details_screen.dart # Individual project detail page
│   └── contactme.dart        # Contact CTA + footer
├── service/
│   ├── downloadcv.dart       # CV download (conditional import)
│   ├── download_web.dart     # Web-specific download
│   ├── download_mobile.dart  # Mobile/desktop download
│   ├── download_stub.dart    # Stub for conditional import
│   └── theme_service.dart    # Theme provider
└── widgets/
    ├── glass_card.dart       # Glassmorphism card widget
    └── gradient_button.dart  # Gradient CTA button widget
```

## 📝 License

© 2026 Amal Mathew. All rights reserved.

## 📬 Contact

- **Email:** mathewamalmathew@gmail.com
- **LinkedIn:** [Amal Mathew](https://www.linkedin.com/in/amal-mathew-1-/)
- **GitHub:** [amalmathew2003](https://github.com/amalmathew2003)
