import 'package:flutter/material.dart';
import '../../config/app_theme.dart';

class QuizPlayScreen extends StatefulWidget {
  final Map<String, dynamic>? quizData;

  const QuizPlayScreen({super.key, this.quizData});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> userAnswers = {}; // Index Soal -> Index Jawaban
  late List<Map<String, dynamic>> questions;

  // Question Repository
  final Map<String, List<Map<String, dynamic>>> questionBank = {
    'quiz1': [
      {
        'question': 'Apa fungsi utama User Interface (UI)?',
        'options': ['Mengatur database', 'Menghubungkan user dengan sistem', 'Mengelola server', 'Menjalankan API'],
        'answerIndex': 1,
      },
      {
        'question': 'Manakah yang termasuk elemen visual dalam UI?',
        'options': ['Algoritma', 'Warna dan Tipografi', 'Koneksi Database', 'Struktur JSON'],
        'answerIndex': 1,
      },
      // ... (Using just a subset here for brevity in this chunk, or include all if needed to be safe, but the instruction is to handle dynamic loading. I'll include the full list for quiz1 again plus quiz2)
      // Re-including the full list for quiz 1 to ensure no data loss
      {
        'question': 'Apa perbedaan utama UI dan UX?',
        'options': ['UI adalah logika, UX adalah tampilan', 'UI adalah tampilan, UX adalah pengalaman', 'Tidak ada perbedaan', 'UX hanya untuk mobile'],
        'answerIndex': 1,
      },
       {
        'question': 'Prinsip desain "Consistency" berarti...',
        'options': ['Desain harus selalu berubah', 'Elemen serupa harus terlihat dan berfungsi sama', 'Menggunakan warna sebanyak mungkin', 'Meniru aplikasi lain persis'],
        'answerIndex': 1,
      },
       {
        'question': 'Tools populer untuk desain UI/UX adalah...',
        'options': ['Visual Studio Code', 'Figma', 'Postman', 'DBeaver'],
        'answerIndex': 1,
      },
    ],
    'quiz2': [
      {
        'question': 'Apa bahasa pemrograman utama untuk Flutter?',
        'options': ['Java', 'Kotlin', 'Dart', 'Swift'],
        'answerIndex': 2,
      },
      {
        'question': 'Widget di Flutter bersifat...',
        'options': ['Mutable', 'Immutable', 'Dynamic', 'Static'],
        'answerIndex': 1,
      },
      {
        'question': 'Perintah untuk membuat project baru adalah...',
        'options': ['flutter run', 'flutter create', 'flutter build', 'flutter doctor'],
        'answerIndex': 1,
      },
      {
        'question': 'StatelessWidget digunakan ketika...',
        'options': ['UI perlu berubah dinamis', 'UI statis dan tidak berubah', 'Membutuhkan animasi kompleks', 'Mengelola state global'],
        'answerIndex': 1,
      },
      {
        'question': 'Hot Reload berfungsi untuk...',
        'options': ['Restart aplikasi full', 'Melihat perubahan kode secara instan tanpa restart', 'Menghapus cache', 'Mengupdate database'],
        'answerIndex': 1,
      },
    ],
  };
  
  // Default questions if ID matches nothing
  final List<Map<String, dynamic>> defaultQuestions = [
    {
      'question': 'Contoh Soal Default?',
      'options': ['Opsi A', 'Opsi B', 'Opsi C', 'Opsi D'],
      'answerIndex': 0,
    }
  ];

  @override
  void initState() {
    super.initState();
    final quizId = widget.quizData?['id'] ?? 'quiz1';
    // Load questions based on ID, populate with full list for Quiz 1 if it was truncated above in real implementation, 
    // but here I defined the bank. 
    // optimizing: I will put the FULL 15 questions back for quiz1 below to be safe as per user request for "banyak soal".
    
    if (quizId == 'quiz1') {
       questions = [
        {
          'question': 'Apa fungsi utama User Interface (UI)?',
          'options': ['Mengatur database', 'Menghubungkan user dengan sistem', 'Mengelola server', 'Menjalankan API'],
          'answerIndex': 1,
        },
        {
          'question': 'Manakah yang termasuk elemen visual dalam UI?',
          'options': ['Algoritma', 'Warna dan Tipografi', 'Koneksi Database', 'Struktur JSON'],
          'answerIndex': 1,
        },
        {
          'question': 'Apa perbedaan utama UI dan UX?',
          'options': ['UI adalah logika, UX adalah tampilan', 'UI adalah tampilan, UX adalah pengalaman', 'Tidak ada perbedaan', 'UX hanya untuk mobile'],
          'answerIndex': 1,
        },
        {
          'question': 'Prinsip desain "Consistency" berarti...',
          'options': ['Desain harus selalu berubah', 'Elemen serupa harus terlihat dan berfungsi sama', 'Menggunakan warna sebanyak mungkin', 'Meniru aplikasi lain persis'],
          'answerIndex': 1,
        },
        {
          'question': 'Tools populer untuk desain UI/UX adalah...',
          'options': ['Visual Studio Code', 'Figma', 'Postman', 'DBeaver'],
          'answerIndex': 1,
        },
        {
          'question': 'Apa itu Wireframe?',
          'options': ['Kerangka dasar desain (low-fidelity)', 'Hasil akhir desain (high-fidelity)', 'Kode program frontend', 'Database schema'],
          'answerIndex': 0,
        },
        {
          'question': 'Warna "Merah" dalam UI biasanya mengindikasikan...',
          'options': ['Sukses', 'Informasi Netral', 'Bahaya atau Error', 'Tautan/Link'],
          'answerIndex': 2,
        },
        {
          'question': 'Apa tujuan dari Usability Testing?',
          'options': ['Mencari bug pada kode', 'Menguji kemudahan penggunaan desain', 'Menguji kecepatan server', 'Menilai estetika warna'],
          'answerIndex': 1,
        },
        {
          'question': 'Istilah "White Space" dalam desain merujuk pada...',
          'options': ['Area kosong di sekitar elemen', 'Warna background harus putih', 'Ruang untuk iklan', 'Area yang salah desain'],
          'answerIndex': 0,
        },
        {
          'question': 'Tipografi Sans-Serif biasanya memberikan kesan...',
          'options': ['Klasik dan Tradisional', 'Modern dan Bersih', 'Rumit dan Dekoratif', 'Kuno'],
          'answerIndex': 1,
        },
        {
          'question': 'Apa itu "Responsive Design"?',
          'options': ['Desain yang merespons suara', 'Desain yang menyesuaikan ukuran layar perangkat', 'Desain dengan animasi cepat', 'Desain statis'],
          'answerIndex': 1,
        },
        {
          'question': 'Ukuran target sentuh minimal yang disarankan untuk mobile adalah...',
          'options': ['10x10 px', '20x20 px', '44x44 px (atau 48dp)', '100x100 px'],
          'answerIndex': 2,
        },
        {
          'question': 'Hukum "Hick\'s Law" menyatakan bahwa...',
          'options': ['Warna mempengaruhi emosi', 'Waktu, keputusan meningkat dengan banyaknya pilihan', 'Pengguna tidak membaca, mereka memindai', 'Jarak target mempengaruhi waktu gerak'],
          'answerIndex': 1,
        },
        {
          'question': 'Prototyping fase "High-Fidelity" berarti...',
          'options': ['Sketsa kasar di kertas', 'Desain yang sangat mirip produk akhir', 'Hanya struktur wireframe', 'Diagram alur pengguna'],
          'answerIndex': 1,
        },
        {
          'question': 'Call to Action (CTA) button sebaiknya...',
          'options': ['Tersembunyi', 'Berwarna pudar', 'Menonjol dan jelas', 'Sama dengan teks biasa', 'Tidak perlu ada'],
          'answerIndex': 2,
        },
      ];
    } else {
      questions = questionBank[quizId] ?? defaultQuestions;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.quizData?['title'] ?? 'Quiz Review 01';
    final currentQ = questions[currentQuestionIndex];
    final totalQuestions = questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: const [
                 Icon(Icons.timer_outlined, color: Colors.white, size: 20),
                 SizedBox(width: 4),
                 Text(
                   "15:00",
                   style: TextStyle(
                     color: Colors.white, 
                     fontWeight: FontWeight.bold
                   ),
                 ),
              ],
            )
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Top Navigation Bar (Question Numbers)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: totalQuestions,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isCurrent = index == currentQuestionIndex;
                final isAnswered = userAnswers.containsKey(index);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentQuestionIndex = index;
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent 
                          ? AppTheme.primaryColor 
                          : (isAnswered ? Colors.green : Colors.white),
                      border: Border.all(
                        color: isCurrent || isAnswered 
                            ? Colors.transparent 
                            : Colors.grey[400]!,
                      ),
                    ),
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                        color: isCurrent || isAnswered 
                            ? Colors.white 
                            : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Soal Nomor ${currentQuestionIndex + 1} / $totalQuestions",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Question Text
                  Text(
                    currentQ['question'],
                    style: const TextStyle(
                      fontSize: 16, // Sedikit lebih kecil agar muat banyak teks jika panjang
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Options
                  ...List.generate(currentQ['options'].length, (optIndex) {
                    final isSelected = userAnswers[currentQuestionIndex] == optIndex;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppTheme.primaryColor.withOpacity(0.1) 
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        ),
                      ),
                      child: RadioListTile<int>(
                        value: optIndex,
                        groupValue: userAnswers[currentQuestionIndex],
                        activeColor: AppTheme.primaryColor,
                        title: Text(
                          currentQ['options'][optIndex],
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected 
                                ? AppTheme.primaryColor 
                                : Colors.black87,
                            fontWeight: isSelected 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            userAnswers[currentQuestionIndex] = val!;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol Kembali
                if (currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                         currentQuestionIndex--;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black54,
                      side: const BorderSide(color: Colors.black12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Soal Sebelumnya"),
                  )
                else
                   const SizedBox(width: 10), // Placeholder agar layout seimbang

                // Tombol Selanjutnya / Selesai
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex < totalQuestions - 1) {
                      setState(() {
                        currentQuestionIndex++;
                      });
                    } else {
                      _calculateAndShowResult();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentQuestionIndex == totalQuestions - 1 
                        ? Colors.green 
                        : AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 0,
                  ),
                  child: Text(
                    currentQuestionIndex == totalQuestions - 1 
                        ? "Selesai" 
                        : "Soal Selanjutnya",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _calculateAndShowResult() {
    int correctCount = 0;
    questions.asMap().forEach((index, q) {
      if (userAnswers[index] == q['answerIndex']) {
        correctCount++;
      }
    });

    double score = (correctCount / questions.length) * 100;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: score >= 70 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                ),
                child: Icon(
                  score >= 70 ? Icons.emoji_events : Icons.warning_amber_rounded,
                  size: 48,
                  color: score >= 70 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Quiz Selesai!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Nilai Kamu: ${score.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 8),
              Text(
                "Benar $correctCount dari ${questions.length} soal",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close Dialog
                    Navigator.pop(context); // Close Screen
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                  child: const Text("Tutup", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
