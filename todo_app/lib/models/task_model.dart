class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final List<String> tags;
  final int attachments;
  final int comments;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.tags = const [],
    this.attachments = 0,
    this.comments = 0,
    this.isCompleted = false,
  });

  // Copy with method for immutable updates
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    List<String>? tags,
    int? attachments,
    int? comments,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      comments: comments ?? this.comments,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Sample data
List<Task> getSampleTasks() {
  final now = DateTime.now();
  return [
    Task(
      id: '1',
      title: 'Favorite UX Book',
      description:
          'Lean UX: Applying Lean Principles to Improve User Experience.',
      category: 'Work',
      date: now,
      tags: ['UX', 'Research', 'UI'],
      attachments: 3,
      comments: 2,
    ),
    Task(
      id: '2',
      title: '2024 Fashion Trend',
      description: "Men's Casual Dress",
      category: 'Personal',
      date: now,
      tags: ['Fashion', 'Lifestyle'],
      attachments: 0,
      comments: 4,
    ),
    Task(
      id: '3',
      title: 'Webflow Web Design',
      description: 'Follow the modern Styles',
      category: 'Work',
      date: now,
      tags: ['Design', 'Web'],
      attachments: 2,
      comments: 0,
    ),
    Task(
      id: '4',
      title: 'Smart Home UX/UI Project',
      description: 'Interview with Stake Holders',
      category: 'Work',
      date: now,
      tags: ['UX', 'Project'],
      attachments: 4,
      comments: 6,
    ),
    Task(
      id: '5',
      title: 'Morning Meditation',
      description: 'Start the day with 10 minutes of mindfulness',
      category: 'Health',
      date: now.add(const Duration(days: 1)),
      tags: ['Wellness'],
      attachments: 0,
      comments: 0,
      isCompleted: true,
    ),
    Task(
      id: '6',
      title: 'Team Standup Meeting',
      description: 'Weekly sync with the development team',
      category: 'Work',
      date: now.add(const Duration(days: 2)),
      tags: ['Meeting'],
      attachments: 1,
      comments: 3,
    ),
  ];
}
