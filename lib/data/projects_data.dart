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
    category: "AI • Productivity",
    githubUrl: "https://github.com/amalmathew2003/note-app",
    thumbnailUrls: [
      "assets/images/VN1bg.png",
      "assets/images/VN2bg.png",
      "assets/images/VN3bg.png",
    ],
    galleryUrls: [
      "assets/images/vn1full.png",
      "assets/images/VN1bg.png",
      "assets/images/VN2bg.png",
      "assets/images/VN3bg.png",
    ],
    videoUrl: "assets/video/VN.mp4",
    techStack: ["Flutter", "Dart", "Firebase", "Audio", "UI/UX"],
    description:
        "The Smart Voice Note App is a Flutter-Firebase based mobile application developed to provide users with a simple, reliable, and efficient way to record, store, and manage voice notes. The primary goal of the application is to help users capture ideas, reminders, meetings, and personal notes instantly through audio, without the need for typing. The app emphasizes usability, performance, and clean architecture while maintaining a modern and intuitive user interface.\n\n"
        "In today's fast-paced environment, users often need a quick way to save thoughts or information. This application addresses that requirement by offering a seamless one-tap recording experience combined with organized storage and smooth playback functionality. The app is designed to work offline, ensuring that users can access their recordings anytime without depending on network connectivity.\n\n"
        "Key Features:\n"
        "* One-tap high-quality audio recording\n"
        "* Automatic organization with date and time labels\n"
        "* View a list of recorded notes with timestamps\n"
        "* Play, pause, and control audio playback\n"
        "* Delete recordings when no longer needed\n"
        "The application follows a clean and minimal UI approach, making it accessible for users of all age groups. From recording to playback, every interaction is designed to be intuitive and responsive.",
  ),
  ProjectData(
    index: "02",
    title: "Travel Tracker",
    category: "Mobile App • Flutter",
    githubUrl: "https://github.com/amalmathew2003/travelapp",
    thumbnailUrls: [
      "assets/images/travalappfull.png",
      "assets/images/travalapp.png",
      "assets/images/travalapp2.png",
    ],
    galleryUrls: [
      "assets/images/travalappfull.png",
      "assets/images/travalapp.png",
      "assets/images/travalapp2.png",
    ],
    videoUrl: "assets/video/travalApp.mp4",
    techStack: ["Flutter", "Dart", "Google Maps", "Provider", "REST API"],
    description:
        "The Travel Tracker App is a Flutter-based mobile application developed to help users track and record their travel activities in real time. The app allows users to monitor their location movements during a journey and maintain a record of travel routes and trips. It focuses on accurately capturing travel data while providing a simple and intuitive interface for viewing tracked information.\n\n"
        "This project emphasizes real-time location tracking, background execution, and efficient data handling. The app is designed to work continuously during travel and reliably store tracking information for later reference. Through this project, I gained hands-on experience in location services, background task handling, permission management, and building Flutter applications that operate smoothly while tracking movement over extended periods.\n\n",
  ),
  ProjectData(
    index: "03",
    title: "Motion Detection",
    category: "Mobile App • Flutter",
    githubUrl: "https://github.com/amalmathew2003/MotionDetectionApp",
    thumbnailUrls: ["assets/images/motion.png", "assets/images/motion2.png"],
    galleryUrls: ["assets/images/motion.png", "assets/images/motion2.png"],
    techStack: ["Flutter", "Dart", "Sensors Plus", "Audio Players"],
    description:
        "The Motion Detection App is a Flutter-based mobile application designed to detect physical movement of the device using built-in sensors such as the accelerometer, gyroscope, and proximity sensor. The application continuously monitors sensor data to identify any significant movement or orientation changes of the phone. When motion is detected, the app immediately triggers an alarm sound, making it suitable for device security, theft prevention, and motion-based alert use cases. The app is capable of running in the background, ensuring continuous monitoring even when the application is not actively in use.\n\n"
        "This project emphasizes real-time sensor data processing, background execution, and efficient system resource management. Motion detection is implemented using the sensors_plus package for accelerometer and gyroscope data, proximity_sensor for near-device detection, and audioplayers for triggering alarm sounds. Through this project, I gained hands-on experience in working with mobile sensors, managing background services, handling permissions, and building reliable Flutter applications that respond instantly to real-world physical interactions.",
  ),
];
