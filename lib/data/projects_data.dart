/// Centralized project data — update once, reflected everywhere.
class ProjectData {
  final String index;
  final String title;
  final String category;
  final String githubUrl;
  final List<String> thumbnailUrls;
  final List<String> galleryUrls;
  final String? videoUrl;
  final String description;
  final List<String> techStack;

  const ProjectData({
    required this.index,
    required this.title,
    required this.category,
    required this.githubUrl,
    required this.thumbnailUrls,
    required this.galleryUrls,
    this.videoUrl,
    required this.description,
    required this.techStack,
  });
}

const List<ProjectData> portfolioProjects = [
  ProjectData(
    index: "01",
    title: "Voice Notes",
    category: "AI • Voice Note App",
    githubUrl: "https://github.com/amalmathew2003/note-app/blob/main/README.md",
    thumbnailUrls: [
      "assets/images/voice_notes_dashboard.png",
      "assets/images/voice_notes_input.png",
      "assets/images/voice_notes_editor.png",
      "assets/images/voice_notes_translation.png",
      "assets/images/voice_notes_splash.png",
    ],
    galleryUrls: [
      "assets/images/voice_notes_dashboard.png",
      "assets/images/voice_notes_input.png",
      "assets/images/voice_notes_editor.png",
      "assets/images/voice_notes_translation.png",
      "assets/images/voice_notes_splash.png",
    ],
    videoUrl: "assets/video/VN.mp4",
    techStack: [
      "Flutter",
      "Hive",
      "GroqAI",
      "speech_to_text",
      "flutter_tts",
      "translator",
      "flutter_local_notifications",
      "google_fonts",
    ],
    description:
        "Voice Notes is a cross-platform Flutter workspace built to capture thoughts by speech instead of typing. Speak an idea and it's transcribed live with speech_to_text, then handed to Groq's openai/gpt-oss-20b model to generate a clean, structured, bulleted note automatically.\n\n"
        "Notes can be translated on demand into English, Malayalam, Kannada, Hindi, Tamil, or Telugu, and read back aloud with flutter_tts — complete with a route observer that halts playback the moment you navigate away. Everything is organized with categories, custom folders, pinning, favorites, and per-note colors across a searchable masonry grid, backed by a fast offline Hive database.\n\n"
        "Key Features:\n"
        "* Real-time voice-to-text note capture\n"
        "* AI note generation and summarization via Groq\n"
        "* Six-language on-demand translation\n"
        "* Text-to-speech playback with smart auto-stop\n"
        "* Folders, categories, pinning, favorites & color themes\n"
        "* Soft-delete Trash with restore/permanent-delete\n"
        "* Timezone-aware scheduled reminders with custom sounds",
  ),
  ProjectData(
    index: "02",
    title: "Travel Tracker",
    category: "GPS • Fitness Tracking",
    githubUrl: "https://github.com/amalmathew2003/travelapp/blob/main/README.md",
    thumbnailUrls: [
      "assets/images/travel_tracker_dashboard.png",
      "assets/images/travel_tracker_map.png",
      "assets/images/travel_tracker_history.png",
      "assets/images/travel_tracker_achievements.png",
      "assets/images/travel_tracker_analytics.png",
      "assets/images/travel_tracker_splash.png",
    ],
    galleryUrls: [
      "assets/images/travel_tracker_dashboard.png",
      "assets/images/travel_tracker_map.png",
      "assets/images/travel_tracker_history.png",
      "assets/images/travel_tracker_achievements.png",
      "assets/images/travel_tracker_analytics.png",
      "assets/images/travel_tracker_splash.png",
    ],
    videoUrl: "assets/video/travalApp.mp4",
    techStack: [
      "Flutter",
      "Geolocator",
      "flutter_map",
      "Hive",
      "flutter_background_service",
      "fl_chart",
      "confetti",
      "audioplayers",
    ],
    description:
        "Travel Tracker is a real-time fitness and travel tracking app for Walking, Running, Cycling, and Driving. It records distance, elapsed time, current/max speed, and estimated calorie burn using geolocator's GPS stream, while flutter_map renders the route live on OpenStreetMap/CartoDB/Esri tiles.\n\n"
        "Map tiles only load during active tracking or preview — a lazy-rendering approach that keeps battery and data usage low. A persistent foreground service (flutter_background_service) keeps recording the route even when the app is minimized or the screen is locked, and completed trips are saved to a local Hive database.\n\n"
        "Key Features:\n"
        "* Real-time GPS distance, speed & calorie tracking\n"
        "* Lazy map tile rendering to save battery and data\n"
        "* Background location tracking with persistent notification\n"
        "* Animated distance analytics via fl_chart\n"
        "* Gamified milestone badges (1–100km) with confetti & sound\n"
        "* On-device trip history with CSV/JSON export",
  ),
  ProjectData(
    index: "03",
    title: "Motion Guard",
    category: "Security • Anti-Theft Utility",
    githubUrl: "https://github.com/amalmathew2003/MotionDetectionApp/blob/main/README.md",
    thumbnailUrls: [
      "assets/images/motion_guard_dashboard.png",
      "assets/images/motion_guard_live_sensor.png",
      "assets/images/motion_guard_detection_history.png",
      "assets/images/motion_guard_settings.png",
    ],
    galleryUrls: [
      "assets/images/motion_guard_dashboard.png",
      "assets/images/motion_guard_live_sensor.png",
      "assets/images/motion_guard_detection_history.png",
      "assets/images/motion_guard_settings.png",
    ],
    techStack: [
      "Flutter",
      "sensors_plus",
      "flutter_background_service",
      "flutter_local_notifications",
      "audioplayers",
      "permission_handler",
    ],
    description:
        "Motion Guard turns any smartphone into a physical anti-theft security system. It runs a background isolate that continuously reads the accelerometer via sensors_plus and computes a real-time motion magnitude vector, checked against a user-configurable sensitivity threshold on every sample.\n\n"
        "Cross that threshold and an alarm fires instantly — whether the app is foregrounded, minimized, or the screen is off — powered by a persistent flutter_background_service isolate. A pulsing status orb reflects live state (standby/armed/alarm) alongside live X/Y/Z sensor bars.\n\n"
        "Key Features:\n"
        "* Background accelerometer monitoring via an isolate-based service\n"
        "* Live status orb with X/Y/Z sensor visualization\n"
        "* 50-event breach history log with magnitude & timestamp\n"
        "* Adjustable sensitivity (2.0–7.0) with selectable alarm tones",
  ),
];