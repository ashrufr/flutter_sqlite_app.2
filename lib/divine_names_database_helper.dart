import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DivineNamesDatabase {
  // Singleton instance
  static final DivineNamesDatabase _instance = DivineNamesDatabase._internal();
  static Database? _database;

  // Database and table name constants
  static const String DATABASE_NAME = 'names.db';
  static const String TABLE_NAME = 'divine_names';
  
  // Column names
  static const String COLUMN_ID = 'id';
  static const String COLUMN_ARABIC_NAME = 'arabic_name';
  static const String COLUMN_ENGLISH_NAME = 'english_name';
  static const String COLUMN_DESCRIPTION = 'description';

  // Factory constructor
  factory DivineNamesDatabase() => _instance;

  // Internal constructor
  DivineNamesDatabase._internal();

  // Database getter
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), DATABASE_NAME);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $TABLE_NAME(
          $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
          $COLUMN_ARABIC_NAME TEXT NOT NULL,
          $COLUMN_ENGLISH_NAME TEXT NOT NULL,
          $COLUMN_DESCRIPTION TEXT NOT NULL
        )
      ''');
      
      // Insert initial data
      await _insertInitialData(db);
    } catch (e) {
      print('Error creating database: $e');
      throw Exception('Failed to create database: $e');
    }
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        // For future schema changes
        // Currently just recreate the table if needed
        await db.execute('DROP TABLE IF EXISTS $TABLE_NAME');
        await _onCreate(db, newVersion);
      }
    } catch (e) {
      print('Error upgrading database: $e');
      throw Exception('Failed to upgrade database: $e');
    }
  }

  // Insert initial data with the 99 names of Allah
  Future<void> _insertInitialData(Database db) async {
    try {
      // Create a batch for efficient insertion
      Batch batch = db.batch();

      // List of the 99 names of Allah with Arabic, English transliteration, and description
      final List<Map<String, dynamic>> divineNames = [
        {
          COLUMN_ARABIC_NAME: 'الله',
          COLUMN_ENGLISH_NAME: 'Allah',
          COLUMN_DESCRIPTION: 'The Greatest Name, referring to the One True God, the Almighty.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرحمن',
          COLUMN_ENGLISH_NAME: 'Ar-Rahman',
          COLUMN_DESCRIPTION: 'The Most Compassionate, The Beneficent, The One who has plenty of mercy for believers and non-believers in this world, and especially for the believers in the hereafter.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرحيم',
          COLUMN_ENGLISH_NAME: 'Ar-Raheem',
          COLUMN_DESCRIPTION: 'The Most Merciful, The One who has plenty of mercy for the believers on the Day of Judgment.',
        },
        {
          COLUMN_ARABIC_NAME: 'الملك',
          COLUMN_ENGLISH_NAME: 'Al-Malik',
          COLUMN_DESCRIPTION: 'The King, The Sovereign Lord, The One with complete dominion, the One whose dominion is clear from imperfection.',
        },
        {
          COLUMN_ARABIC_NAME: 'القدوس',
          COLUMN_ENGLISH_NAME: 'Al-Quddus',
          COLUMN_DESCRIPTION: 'The Holy, The Pure, The One who is pure from any imperfection and clear from children and adversaries.',
        },
        {
          COLUMN_ARABIC_NAME: 'السلام',
          COLUMN_ENGLISH_NAME: 'As-Salam',
          COLUMN_DESCRIPTION: 'The Peace, The Source of Peace, The One who is free from every imperfection.',
        },
        {
          COLUMN_ARABIC_NAME: 'المؤمن',
          COLUMN_ENGLISH_NAME: 'Al-Mu\'min',
          COLUMN_DESCRIPTION: 'The Granter of Security, The One who gives tranquility and calm after fear.',
        },
        {
          COLUMN_ARABIC_NAME: 'المهيمن',
          COLUMN_ENGLISH_NAME: 'Al-Muhaymin',
          COLUMN_DESCRIPTION: 'The Guardian, The Protector, The One who witnesses the saying and deeds of His creatures.',
        },
        {
          COLUMN_ARABIC_NAME: 'العزيز',
          COLUMN_ENGLISH_NAME: 'Al-Aziz',
          COLUMN_DESCRIPTION: 'The Mighty, The Almighty, The One who cannot be harmed or abased.',
        },
        {
          COLUMN_ARABIC_NAME: 'الجبار',
          COLUMN_ENGLISH_NAME: 'Al-Jabbar',
          COLUMN_DESCRIPTION: 'The Compeller, The One that nothing happens in His dominion except that which He willed.',
        },
        {
          COLUMN_ARABIC_NAME: 'المتكبر',
          COLUMN_ENGLISH_NAME: 'Al-Mutakabbir',
          COLUMN_DESCRIPTION: 'The Supreme, The Majestic, The One who is clear from the attributes of the creatures and from resembling them.',
        },
        {
          COLUMN_ARABIC_NAME: 'الخالق',
          COLUMN_ENGLISH_NAME: 'Al-Khaliq',
          COLUMN_DESCRIPTION: 'The Creator, The One who brings everything from non-existence to existence.',
        },
        {
          COLUMN_ARABIC_NAME: 'البارئ',
          COLUMN_ENGLISH_NAME: 'Al-Bari\'',
          COLUMN_DESCRIPTION: 'The Maker, The Evolver, The One who created all creatures with distinct differences and perfect wisdom.',
        },
        {
          COLUMN_ARABIC_NAME: 'المصور',
          COLUMN_ENGLISH_NAME: 'Al-Musawwir',
          COLUMN_DESCRIPTION: 'The Fashioner, The Bestower of Form, The One who forms His creatures in different pictures.',
        },
        {
          COLUMN_ARABIC_NAME: 'الغفار',
          COLUMN_ENGLISH_NAME: 'Al-Ghaffar',
          COLUMN_DESCRIPTION: 'The Forgiver, The All-Forgiving, The One who forgives the sins of His slaves repeatedly.',
        },
        {
          COLUMN_ARABIC_NAME: 'القهار',
          COLUMN_ENGLISH_NAME: 'Al-Qahhar',
          COLUMN_DESCRIPTION: 'The Subduer, The Irresistible, The One who has subdued all creation to His command and will.',
        },
        {
          COLUMN_ARABIC_NAME: 'الوهاب',
          COLUMN_ENGLISH_NAME: 'Al-Wahhab',
          COLUMN_DESCRIPTION: 'The Bestower, The One who is Generous in giving without any return and without a need to give.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرزاق',
          COLUMN_ENGLISH_NAME: 'Ar-Razzaq',
          COLUMN_DESCRIPTION: 'The Provider, The Sustainer, The One who creates and provides all the needs of those He created.',
        },
        {
          COLUMN_ARABIC_NAME: 'الفتاح',
          COLUMN_ENGLISH_NAME: 'Al-Fattah',
          COLUMN_DESCRIPTION: 'The Opener, The Judge, The One who opens for His slaves the closed worldly and religious matters.',
        },
        {
          COLUMN_ARABIC_NAME: 'العليم',
          COLUMN_ENGLISH_NAME: 'Al-Alim',
          COLUMN_DESCRIPTION: 'The All-Knowing, The Omniscient, The One who knows everything and whose knowledge encompasses all things.',
        },
        {
          COLUMN_ARABIC_NAME: 'القابض',
          COLUMN_ENGLISH_NAME: 'Al-Qabid',
          COLUMN_DESCRIPTION: 'The Constrictor, The Withholder, The One who constricts and restricts the sustenance of whomever He wills.',
        },
        {
          COLUMN_ARABIC_NAME: 'الباسط',
          COLUMN_ENGLISH_NAME: 'Al-Basit',
          COLUMN_DESCRIPTION: 'The Expander, The Releaser, The One who expands and increases the sustenance of whomever He wills.',
        },
        {
          COLUMN_ARABIC_NAME: 'الخافض',
          COLUMN_ENGLISH_NAME: 'Al-Khafid',
          COLUMN_DESCRIPTION: 'The Abaser, The One who lowers and abases whoever He wills by His power and authority.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرافع',
          COLUMN_ENGLISH_NAME: 'Ar-Rafi',
          COLUMN_DESCRIPTION: 'The Exalter, The Elevator, The One who raises and elevates whoever He wills by His power and authority.',
        },
        {
          COLUMN_ARABIC_NAME: 'المعز',
          COLUMN_ENGLISH_NAME: 'Al-Mu\'izz',
          COLUMN_DESCRIPTION: 'The Bestower of Honor, The One who gives esteem to whoever He wills, hence there is no one to degrade Him.',
        },
        {
          COLUMN_ARABIC_NAME: 'المذل',
          COLUMN_ENGLISH_NAME: 'Al-Mudhill',
          COLUMN_DESCRIPTION: 'The Humiliator, The One who degrades and humiliates whoever He wills.',
        },
        {
          COLUMN_ARABIC_NAME: 'السميع',
          COLUMN_ENGLISH_NAME: 'As-Sami',
          COLUMN_DESCRIPTION: 'The All-Hearing, The One who hears all things that are heard by His eternal hearing without an ear, instrument or organ.',
        },
        {
          COLUMN_ARABIC_NAME: 'البصير',
          COLUMN_ENGLISH_NAME: 'Al-Basir',
          COLUMN_DESCRIPTION: 'The All-Seeing, The One who sees all things that are seen by His eternal seeing without a pupil or any other instrument.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحكم',
          COLUMN_ENGLISH_NAME: 'Al-Hakam',
          COLUMN_DESCRIPTION: 'The Judge, The Arbitrator, The One who judges between His creatures with justice and has no judge over His rule.',
        },
        {
          COLUMN_ARABIC_NAME: 'العدل',
          COLUMN_ENGLISH_NAME: 'Al-Adl',
          COLUMN_DESCRIPTION: 'The Just, The One who is entitled to do what He does, with perfect justice in His judgment.',
        },
        {
          COLUMN_ARABIC_NAME: 'اللطيف',
          COLUMN_ENGLISH_NAME: 'Al-Latif',
          COLUMN_DESCRIPTION: 'The Subtle One, The Most Gentle, The One who is kind to His slaves and endows upon them blessings from where they do not expect.',
        },
        {
          COLUMN_ARABIC_NAME: 'الخبير',
          COLUMN_ENGLISH_NAME: 'Al-Khabir',
          COLUMN_DESCRIPTION: 'The All-Aware, The One who knows the truth of things, with deep knowledge of inner realities and secrets.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحليم',
          COLUMN_ENGLISH_NAME: 'Al-Halim',
          COLUMN_DESCRIPTION: 'The Forbearing, The Clement, The One who delays the punishment for those who deserve it, and then might forgive them.',
        },
        {
          COLUMN_ARABIC_NAME: 'العظيم',
          COLUMN_ENGLISH_NAME: 'Al-Azim',
          COLUMN_DESCRIPTION: 'The Magnificent, The Great One, The One who possesses greatness in all aspects - in His epithets, words, deeds, and laws.',
        },
        {
          COLUMN_ARABIC_NAME: 'الغفور',
          COLUMN_ENGLISH_NAME: 'Al-Ghafur',
          COLUMN_DESCRIPTION: 'The All-Forgiving, The One who forgives a lot, with perfect forgiveness and conceals the sins of His slaves.',
        },
        {
          COLUMN_ARABIC_NAME: 'الشكور',
          COLUMN_ENGLISH_NAME: 'Ash-Shakur',
          COLUMN_DESCRIPTION: 'The Appreciative, The Grateful, The One who gives abundant rewards for little deeds and appreciates acts of obedience from His slaves.',
        },
        {
          COLUMN_ARABIC_NAME: 'العلي',
          COLUMN_ENGLISH_NAME: 'Al-Ali',
          COLUMN_DESCRIPTION: 'The Most High, The Exalted, The One who is clear from the attributes of the creation; has the attributes of perfect greatness and highness.',
        },
        {
          COLUMN_ARABIC_NAME: 'الكبير',
          COLUMN_ENGLISH_NAME: 'Al-Kabir',
          COLUMN_DESCRIPTION: 'The Most Great, The One who is absolutely perfect in His essence, attributes, names, and actions - supremely great in all aspects.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحفيظ',
          COLUMN_ENGLISH_NAME: 'Al-Hafiz',
          COLUMN_DESCRIPTION: 'The Preserver, The Guardian, The One who protects whatever and whoever He wills to protect and preserves them from loss, injury or decreasing.',
        },
        {
          COLUMN_ARABIC_NAME: 'المقيت',
          COLUMN_ENGLISH_NAME: 'Al-Muqit',
          COLUMN_DESCRIPTION: 'The Nourisher, The Sustainer, The One who provides the creation with sustenance and everything needed for existence.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحسيب',
          COLUMN_ENGLISH_NAME: 'Al-Hasib',
          COLUMN_DESCRIPTION: 'The Reckoner, The One who gives the satisfaction, and grants sufficiency to His slaves; He knows their deeds, statements, and rewards them.',
        },
        {
          COLUMN_ARABIC_NAME: 'الجليل',
          COLUMN_ENGLISH_NAME: 'Al-Jalil',
          COLUMN_DESCRIPTION: 'The Majestic, The Sublime, The One who is attributed with greatness of Power and Glory; who is clear from having undesirable characteristics.',
        },
        {
          COLUMN_ARABIC_NAME: 'الكريم',
          COLUMN_ENGLISH_NAME: 'Al-Karim',
          COLUMN_DESCRIPTION: 'The Generous, The Bountiful, The One who is Most Generous, giving abundantly in countless ways without need for return or compensation.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرقيب',
          COLUMN_ENGLISH_NAME: 'Ar-Raqib',
          COLUMN_DESCRIPTION: 'The Watchful, The Observer, The One who oversees His creation in all of their doings through His perfect knowledge.',
        },
        {
          COLUMN_ARABIC_NAME: 'المجيب',
          COLUMN_ENGLISH_NAME: 'Al-Mujib',
          COLUMN_DESCRIPTION: 'The Responsive, The Answerer, The One who responds to the supplications and answers the prayers of those who call upon Him.',
        },
        {
          COLUMN_ARABIC_NAME: 'الواسع',
          COLUMN_ENGLISH_NAME: 'Al-Wasi',
          COLUMN_DESCRIPTION: 'The All-Encompassing, The Vast, The One who is ample in His forgiveness, knowledge, mercy and sustenance; all-encompassing in all aspects.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحكيم',
          COLUMN_ENGLISH_NAME: 'Al-Hakim',
          COLUMN_DESCRIPTION: 'The Wise, The All-Wise, The One who is correct in His doings, makes the right judgments and puts everything in its rightful place.',
        },
        {
          COLUMN_ARABIC_NAME: 'الودود',
          COLUMN_ENGLISH_NAME: 'Al-Wadud',
          COLUMN_DESCRIPTION: 'The Loving, The Affectionate, The One who loves His righteous servants and His righteous servants love Him.',
        },
        {
          COLUMN_ARABIC_NAME: 'المجيد',
          COLUMN_ENGLISH_NAME: 'Al-Majid',
          COLUMN_DESCRIPTION: 'The Glorious, The Most Magnificent, The One who is the Most Glorious and Majestic, who deserves praise and glory due to His magnificent qualities.',
        },
        {
          COLUMN_ARABIC_NAME: 'الباعث',
          COLUMN_ENGLISH_NAME: 'Al-Ba\'ith',
          COLUMN_DESCRIPTION: 'The Resurrector, The One who resurrects the dead on the Day of Judgment for reward and punishment.',
        },
        {
          COLUMN_ARABIC_NAME: 'الشهيد',
          COLUMN_ENGLISH_NAME: 'Ash-Shahid',
          COLUMN_DESCRIPTION: 'The Witness, The One who witnesses and knows everything even what is inside people\'s hearts and minds.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحق',
          COLUMN_ENGLISH_NAME: 'Al-Haqq',
          COLUMN_DESCRIPTION: 'The Truth, The One who truly exists, whose existence and divinity are true; everything about Him is true.',
        },
        {
          COLUMN_ARABIC_NAME: 'الوكيل',
          COLUMN_ENGLISH_NAME: 'Al-Wakil',
          COLUMN_DESCRIPTION: 'The Trustee, The Disposer of Affairs, The One who provides and is relied upon for all matters and needs.',
        },
        {
          COLUMN_ARABIC_NAME: 'القوي',
          COLUMN_ENGLISH_NAME: 'Al-Qawiyy',
          COLUMN_DESCRIPTION: 'The Most Strong, The Strong, The One who is perfect in strength and power; who is never affected by weakness.',
        },
        {
          COLUMN_ARABIC_NAME: 'المتين',
          COLUMN_ENGLISH_NAME: 'Al-Matin',
          COLUMN_DESCRIPTION: 'The Firm, The Steadfast, The One with extreme power which is never affected by weakness or inability.',
        },
        {
          COLUMN_ARABIC_NAME: 'الولي',
          COLUMN_ENGLISH_NAME: 'Al-Waliyy',
          COLUMN_DESCRIPTION: 'The Protector, The Supporter, The One who supports and protects the believers and gives them victory.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحميد',
          COLUMN_ENGLISH_NAME: 'Al-Hamid',
          COLUMN_DESCRIPTION: 'The Praiseworthy, The One who is praised and deserves to be praised for His perfect attributes and actions.',
        },
        {
          COLUMN_ARABIC_NAME: 'المحصي',
          COLUMN_ENGLISH_NAME: 'Al-Muhsi',
          COLUMN_DESCRIPTION: 'The Counter, The One who knows the count of everything, even to the smallest detail, nothing escapes His knowledge.',
        },
        {
          COLUMN_ARABIC_NAME: 'المبدئ',
          COLUMN_ENGLISH_NAME: 'Al-Mubdi',
          COLUMN_DESCRIPTION: 'The Originator, The Initiator, The One who created all creatures without any previous example.',
        },
        {
          COLUMN_ARABIC_NAME: 'المعيد',
          COLUMN_ENGLISH_NAME: 'Al-Mu\'id',
          COLUMN_DESCRIPTION: 'The Restorer, The Reproducer, The One who brings back creatures after their death for judgment.',
        },
        {
          COLUMN_ARABIC_NAME: 'المحيي',
          COLUMN_ENGLISH_NAME: 'Al-Muhyi',
          COLUMN_DESCRIPTION: 'The Giver of Life, The One who gives life to the dead; brings to life those who deserve it.',
        },
        {
          COLUMN_ARABIC_NAME: 'المميت',
          COLUMN_ENGLISH_NAME: 'Al-Mumit',
          COLUMN_DESCRIPTION: 'The Bringer of Death, The Causer of Death, The One who renders the living dead at their appointed time.',
        },
        {
          COLUMN_ARABIC_NAME: 'الحي',
          COLUMN_ENGLISH_NAME: 'Al-Hayy',
          COLUMN_DESCRIPTION: 'The Ever-Living, The One who has the perfect life that is neither preceded by non-existence nor followed by vanishing.',
        },
        {
          COLUMN_ARABIC_NAME: 'القيوم',
          COLUMN_ENGLISH_NAME: 'Al-Qayyum',
          COLUMN_DESCRIPTION: 'The Self-Subsisting, The One who sustains and protects all that exists; who is perfectly independent and sustains all others.',
        },
        {
          COLUMN_ARABIC_NAME: 'الواجد',
          COLUMN_ENGLISH_NAME: 'Al-Wajid',
          COLUMN_DESCRIPTION: 'The Finder, The Perceiver, The Self-Sufficient, The One who finds everything He wants and wills at the time He wills it.',
        },
        {
          COLUMN_ARABIC_NAME: 'الماجد',
          COLUMN_ENGLISH_NAME: 'Al-Majid',
          COLUMN_DESCRIPTION: 'The Noble, The Illustrious, The One who is Majid by His actions and His generosity, who is noble and abundant in goodness.',
        },
        {
          COLUMN_ARABIC_NAME: 'الواحد',
          COLUMN_ENGLISH_NAME: 'Al-Wahid',
          COLUMN_DESCRIPTION: 'The One, The Unique, The One who is single and alone, having no partner in His essence, attributes, or actions.',
        },
        {
          COLUMN_ARABIC_NAME: 'الأحد',
          COLUMN_ENGLISH_NAME: 'Al-Ahad',
          COLUMN_DESCRIPTION: 'The One, The Indivisible, The One who is unique in His oneness, who has no partner in His essence, attributes or actions.',
        },
        {
          COLUMN_ARABIC_NAME: 'الصمد',
          COLUMN_ENGLISH_NAME: 'As-Samad',
          COLUMN_DESCRIPTION: 'The Eternal, The Absolute, The Independent, The One who doesn\'t need the creation, while all of creation is in need of Him.',
        },
        {
          COLUMN_ARABIC_NAME: 'القادر',
          COLUMN_ENGLISH_NAME: 'Al-Qadir',
          COLUMN_DESCRIPTION: 'The Able, The Capable, The One with complete power and ability to do everything without any aid or support.',
        },
        {
          COLUMN_ARABIC_NAME: 'المقتدر',
          COLUMN_ENGLISH_NAME: 'Al-Muqtadir',
          COLUMN_DESCRIPTION: 'The Powerful, The Dominant, The One with perfect power who prevails over all of creation.',
        },
        {
          COLUMN_ARABIC_NAME: 'المقدم',
          COLUMN_ENGLISH_NAME: 'Al-Muqaddim',
          COLUMN_DESCRIPTION: 'The Expediter, The Promoter, The One who brings forward whatever/whoever He wills from His creatures.',
        },
        {
          COLUMN_ARABIC_NAME: 'المؤخر',
          COLUMN_ENGLISH_NAME: 'Al-Mu\'akhkhir',
          COLUMN_DESCRIPTION: 'The Delayer, The Retarder, The One who puts back or delays whatever/whoever He wills from His creatures.',
        },
        {
          COLUMN_ARABIC_NAME: 'الأول',
          COLUMN_ENGLISH_NAME: 'Al-Awwal',
          COLUMN_DESCRIPTION: 'The First, The One whose existence is without beginning; who exists before all others.',
        },
        {
          COLUMN_ARABIC_NAME: 'الآخر',
          COLUMN_ENGLISH_NAME: 'Al-Akhir',
          COLUMN_DESCRIPTION: 'The Last, The One whose existence is without end; who continues to exist after all others cease to exist.',
        },
        {
          COLUMN_ARABIC_NAME: 'الظاهر',
          COLUMN_ENGLISH_NAME: 'Az-Zahir',
          COLUMN_DESCRIPTION: 'The Manifest, The Evident, The One who manifests Himself through His signs and creation.',
        },
        {
          COLUMN_ARABIC_NAME: 'الباطن',
          COLUMN_ENGLISH_NAME: 'Al-Batin',
          COLUMN_DESCRIPTION: 'The Hidden, The Imperceptible, The One who is hidden from vision though He is apparent by His effects.',
        },
        {
          COLUMN_ARABIC_NAME: 'الوالي',
          COLUMN_ENGLISH_NAME: 'Al-Wali',
          COLUMN_DESCRIPTION: 'The Governor, The Patron, The One who owns, manages and governs all affairs of creation.',
        },
        {
          COLUMN_ARABIC_NAME: 'المتعالي',
          COLUMN_ENGLISH_NAME: 'Al-Muta\'ali',
          COLUMN_DESCRIPTION: 'The Most Exalted, The Supreme, The One who is high above the creation and above any imperfection.',
        },
        {
          COLUMN_ARABIC_NAME: 'البر',
          COLUMN_ENGLISH_NAME: 'Al-Barr',
          COLUMN_DESCRIPTION: 'The Beneficent, The Source of Goodness, The One who treats His creatures with kindness and never breaks His promises.',
        },
        {
          COLUMN_ARABIC_NAME: 'التواب',
          COLUMN_ENGLISH_NAME: 'At-Tawwab',
          COLUMN_DESCRIPTION: 'The Ever-Returning, The One who grants repentance to whoever He wills and accepts their repentance.',
        },
        {
          COLUMN_ARABIC_NAME: 'المنتقم',
          COLUMN_ENGLISH_NAME: 'Al-Muntaqim',
          COLUMN_DESCRIPTION: 'The Avenger, The One who victoriously prevails over His enemies and punishes them for their wickedness.',
        },
        {
          COLUMN_ARABIC_NAME: 'العفو',
          COLUMN_ENGLISH_NAME: 'Al-Afuww',
          COLUMN_DESCRIPTION: 'The Pardoner, The One who pardons and forgives sins and disregards the offenses of His servants.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرؤوف',
          COLUMN_ENGLISH_NAME: 'Ar-Ra\'uf',
          COLUMN_DESCRIPTION: 'The Compassionate, The Most Kind, The One who has the perfect attribute of kindness and mercy to His creatures.',
        },
        {
          COLUMN_ARABIC_NAME: 'مالك الملك',
          COLUMN_ENGLISH_NAME: 'Malik-ul-Mulk',
          COLUMN_DESCRIPTION: 'The Owner of All Sovereignty, The King of Kings, The One who possesses the entire dominion and has full authority over it.',
        },
        {
          COLUMN_ARABIC_NAME: 'ذو الجلال والإكرام',
          COLUMN_ENGLISH_NAME: 'Dhul-Jalal wal-Ikram',
          COLUMN_DESCRIPTION: 'The Lord of Majesty and Bounty, The One who is worthy of being glorified and not denied, and is to be obeyed and not disobeyed.',
        },
        {
          COLUMN_ARABIC_NAME: 'المقسط',
          COLUMN_ENGLISH_NAME: 'Al-Muqsit',
          COLUMN_DESCRIPTION: 'The Equitable, The Just, The One who acts and judges with fairness and justice in all situations.',
        },
        {
          COLUMN_ARABIC_NAME: 'الجامع',
          COLUMN_ENGLISH_NAME: 'Al-Jami',
          COLUMN_DESCRIPTION: 'The Gatherer, The Collector, The One who gathers the creatures on the Day of Judgment for reward or punishment.',
        },
        {
          COLUMN_ARABIC_NAME: 'الغني',
          COLUMN_ENGLISH_NAME: 'Al-Ghani',
          COLUMN_DESCRIPTION: 'The Self-Sufficient, The Rich, The One who has no need for anything; free of want and need.',
        },
        {
          COLUMN_ARABIC_NAME: 'المغني',
          COLUMN_ENGLISH_NAME: 'Al-Mughni',
          COLUMN_DESCRIPTION: 'The Enricher, The One who makes rich and satisfies the necessities of His creatures; who relieves them from need.',
        },
        {
          COLUMN_ARABIC_NAME: 'المانع',
          COLUMN_ENGLISH_NAME: 'Al-Mani',
          COLUMN_DESCRIPTION: 'The Preventer, The Withholder, The One who withholds and prevents as He pleases in accordance with His wisdom.',
        },
        {
          COLUMN_ARABIC_NAME: 'الضار',
          COLUMN_ENGLISH_NAME: 'Ad-Darr',
          COLUMN_DESCRIPTION: 'The Distressor, The Afflicter, The One who can harm and bring adversity to those who deserve it.',
        },
        {
          COLUMN_ARABIC_NAME: 'النافع',
          COLUMN_ENGLISH_NAME: 'An-Nafi',
          COLUMN_DESCRIPTION: 'The Benefactor, The One who confers benefits upon His creatures and creates whatever is good for them.',
        },
        {
          COLUMN_ARABIC_NAME: 'النور',
          COLUMN_ENGLISH_NAME: 'An-Nur',
          COLUMN_DESCRIPTION: 'The Light, The One who is the source of all light, both physical and spiritual; who illuminates the hearts of believers.',
        },
        {
          COLUMN_ARABIC_NAME: 'الهادي',
          COLUMN_ENGLISH_NAME: 'Al-Hadi',
          COLUMN_DESCRIPTION: 'The Guide, The One who shows the right path, who guides those whom He wills to the truth.',
        },
        {
          COLUMN_ARABIC_NAME: 'البديع',
          COLUMN_ENGLISH_NAME: 'Al-Badi',
          COLUMN_DESCRIPTION: 'The Originator, The Incomparable, The One who created the universe in a unique and unprecedented form.',
        },
        {
          COLUMN_ARABIC_NAME: 'الباقي',
          COLUMN_ENGLISH_NAME: 'Al-Baqi',
          COLUMN_DESCRIPTION: 'The Everlasting, The Eternal, The One whose existence has no end; who remains after all creation has perished.',
        },
        {
          COLUMN_ARABIC_NAME: 'الوارث',
          COLUMN_ENGLISH_NAME: 'Al-Warith',
          COLUMN_DESCRIPTION: 'The Ultimate Inheritor, The One who inherits everything after all creation has perished.',
        },
        {
          COLUMN_ARABIC_NAME: 'الرشيد',
          COLUMN_ENGLISH_NAME: 'Ar-Rashid',
          COLUMN_DESCRIPTION: 'The Guide to the Right Path, The Righteous Teacher, The One who directs His servants towards what is beneficial for them and guides them to the straight path.',
        },
        {
          COLUMN_ARABIC_NAME: 'الصبور',
          COLUMN_ENGLISH_NAME: 'As-Sabur',
          COLUMN_DESCRIPTION: 'The Patient One, The Most Patient, The One who does not hasten to punish the sinners and gives them time to repent.',
        },
      ];

      // Add each divine name to the batch
      for (var divineName in divineNames) {
        batch.insert(TABLE_NAME, divineName);
      }

      // Execute the batch operation
      await batch.commit(noResult: false);
      
      print('Successfully inserted all 99 divine names into the database.');
    } catch (e) {
      print('Error inserting divine names: $e');
      throw Exception('Failed to insert divine names: $e');
    }
  }

  // CRUD Operations

  // Get all divine names
  Future<List<Map<String, dynamic>>> getAllNames() async {
    try {
      final Database db = await database;
      return await db.query(TABLE_NAME, orderBy: '$COLUMN_ID ASC');
    } catch (e) {
      print('Error getting all names: $e');
      return [];
    }
  }

  // Get divine name by ID
  Future<Map<String, dynamic>?> getNameById(int id) async {
    try {
      final Database db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        TABLE_NAME,
        where: '$COLUMN_ID = ?',
        whereArgs: [id],
      );
      
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error getting name by id: $e');
      return null;
    }
  }

  // Search names by English name
  Future<List<Map<String, dynamic>>> searchByEnglishName(String query) async {
    try {
      final Database db = await database;
      return await db.query(
        TABLE_NAME,
        where: '$COLUMN_ENGLISH_NAME LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: '$COLUMN_ID ASC',
      );
    } catch (e) {
      print('Error searching by English name: $e');
      return [];
    }
  }
}

