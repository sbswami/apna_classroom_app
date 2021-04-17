import 'package:apna_classroom_app/internationalization/strings.dart';

const HI_IN = {
  // Basic
  S.APP_NAME: 'Apna Classroom',
  S.APP_N: 'Apna',

  // Design
  S.SOMETHING_WENT_WRONG: 'कुछ गलत हो गया',
  S.PROCESSING: 'प्रसंस्करण। । ।',

  // LOGIN
  S.LOGIN: 'लॉग इन करें',
  S.PHONE_NUMBER_LABEL: '10 अंकों का फोन नंबर दर्ज करें',
  S.PLEASE_ENTER_VALID_PHONE_NUMBER: 'मान्य फ़ोन नंबर दर्ज करें',
  S.LOGIN_FAILED: 'लॉगिन विफल',
  S.WRONG_PHONE_NUMBER_LIMIT_EXCEED:
      'या तो गलत फोन नंबर या आप 4 घंटे में सत्यापन की सीमा को पार कर जाते हैं। सही फोन नंबर के साथ प्रयास करें या 4 घंटे के बाद प्रयास करें',
  S.CODE_SENT: 'कोड भेजा गया',

  // Profile
  S.PROFILE: 'प्रोफ़ाइल',
  S.ENTER_YOUR_NAME: 'अपना नाम दर्ज करें',
  S.USERNAME: 'उपयोगकर्ता नाम',
  S.USERNAME_INVALID: 'आपका यूसरनेम गलत है',
  S.USERNAME_ALREADY_EXISTS: 'उपयोगकर्ता का नाम पहले से मौजूद है',
  S.NAME_INVALID: 'नाम मान्य नहीं है',
  S.RESEND_OTP: 'ओटीपी पुनः भेजें?',
  S.HIDE_MY_PHONE_NUMBER: 'मेरा फ़ोन नंबर छिपाएँ',
  S.PHONE_NUMBER: 'फ़ोन नंबर',
  S.SAVE: 'सहेजें',

  S.CAMERA: 'कैमरा',
  S.GALLERY: 'गेलरी',
  S.DELETE: 'हटाएं',

  // Home
  S.CLASSROOM: 'कक्षा',
  S.QUIZ: 'प्रश्नोत्तरी',
  S.NOTES: 'टिप्पणियाँ',

  // Notes + Quiz + Classroom
  S.ENTER_SUBJECT: 'विषय दर्ज करें',
  S.ADD_ALL_LAST_USED: 'सभी अंतिम उपयोग में जोड़ें',
  S.PUBLIC: 'जनता',
  S.PRIVATE: 'निजी',
  S.NOT_A_VALID_TITLE: 'कृपया मान्य शीर्षक दर्ज करें, चरित्र सीमा 100 तक',
  S.ADD_AT_LEAST_ONE_SUBJECT: 'कम से कम एक विषय जोड़ें!',
  S.PDF_VIEWER: 'पीडीएफ देखने वाला',
  S.IMAGE_VIEWER: 'छवि दर्शक',
  S.SEARCH: 'चने',
  S.OPEN_IMAGE: 'छवि खोलें',
  S.EDIT: 'संपादित करें',
  S.ADD_AT_LEAST_ONE_EXAM: 'पट्टे पर एक परीक्षा में जोड़ें!',
  S.SUBJECT: 'विषय',

  // Notes + Quiz
  S.OPEN_EDITOR: 'ओपन एडिटर',
  S.UPLOAD_FILE: 'फ़ाइल अपलोड करें',
  S.ACCEPTED_FORMATS: 'पीडीएफ, जेपीईजी, एमपी 4',
  S.EDITOR: 'संपादक',

  // Notes
  S.ADD_NOTES: 'नोट्स जोड़ें',
  S.ENTER_NOTES_TITLE: 'नोट्स शीर्षक दर्ज करें',
  S.NOTE_TITLE_CAN_T_BE_EMPTY: 'नोट शीर्षक, खाली नहीं हो सकता',
  S.NO_NOTES_TO_SAVE: 'बचाने के लिए नोट नहीं',
  S.NOTE_TITLE: 'नोट शीर्षक',
  S.MOVE_UP: 'बढ़ाना',
  S.MOVE_DOWN: 'नीचे की ओर',
  S.MOVE_TO_TOP: 'ऊपर की ओर ले जाएं',
  S.MOVE_TO_BOTTOM: 'नीचे की ओर ले जाएं',
  S.PLEASE_ENTER_THE_NOTE_TITLE: 'कृपया शीर्षक दर्ज करें',

  // Quiz + Exam
  S.EXAM: 'परीक्षा',
  S.ADD_EXAM: 'परीक्षा जोड़ें',
  S.ENTER_EXAM: 'परीक्षा दें',
  S.EXAM_TITLE: 'परीक्षा का शीर्षक',
  S.EXAM_INSTRUCTION: 'परीक्षा निर्देश',
  S.PLUS_QUESTION: '+ प्रश्न',
  S.MINUS_MARKING: 'माइनस मार्किंग',
  S.MINUS_MARKS_PER_QUESTION: 'प्रति प्रश्न माइनस मार्किंग',
  S.EXAM_SOLVING_TIME: 'परीक्षा का समय हल करना',
  S.EXAM_MARKS: 'परीक्षा के अंक',
  S.EXAM_PRIVACY: 'परीक्षा की गोपनीयता',
  S.DIFFICULTY_LEVEL: 'कठिनाई स्तर',
  S.THIS_FIELD_IS_REQUIRED: 'यह फ़ील्ड आवश्यक है!',
  S.EASY: 'आसान',
  S.NORMAL: 'साधारण',
  S.HARD: 'कठिन',
  S.SOLVING_TIME_HELPER_TEXT:
      'प्रत्येक प्रश्न के लिए समय समान रूप से विभाजित किया जाएगा।',
  S.EXAM_MARKS_HELPER_TEXT:
      'प्रत्येक प्रश्न के लिए अंक समान रूप से विभाजित किए जाएंगे।',
  S.PLEASE_ADD_AT_LEAST_1_QUESTION: 'कृपया कम से कम 1 प्रश्न जोड़ें',
  S.QUESTION_ADDED: 'प्रश्न जोड़ा गया',
  S.CREATE_EXAM: 'परीक्षा बनाएँ',

  // Quiz + Question
  S.QUESTION: 'सवाल',
  S.ADD_QUESTION: 'प्रश्न जोड़ें',
  S.NOT_A_VALID_QUESTION: 'कृपया मान्य प्रश्न, वर्ण सीमा 500 दर्ज करें',
  S.ADD_IMAGE: '+ छवि',
  S.IMAGE_NAME: 'छवि का नाम',
  S.PLEASE_ENTER_IMAGE_NAME: 'कृपया छवि का नाम दर्ज करें',
  S.ANSWER_TYPE: 'उत्तर प्रकार',
  S.MULTI_CHOICE: 'बहु विकल्प',
  S.SINGLE_CHOICE: 'एकल विकल्प',
  S.DIRECT_ANSWER: 'सीधा जवाब',
  S.ENTER_OPTION: 'विकल्प डालें',
  S.NOT_A_VALID_ANSWER: 'मान्य उत्तर नहीं',
  S.ENTER_ANSWER: 'उत्तर दर्ज करें',
  S.ANSWER_FORMAT: 'उत्तर प्रारूप',
  S.ANSWER_FORMAT_HINT: 'उदा। केवल संख्या',
  S.ANSWER_HINT: 'उत्तर संकेत',
  S.SOLVING_TIME: 'समय हल करना',
  S.HOUR: 'इस घंटे',
  S.MINUTE: 'मिनट',
  S.SECOND: 'दूसरा',
  S.ENTER_MARKS: 'मार्क्स दर्ज करें',
  S.ADD_SOLUTION: 'समाधान जोड़ें',
  S.PLEASE_SELECT_CORRECT_ANSWER: 'कृपया सही उत्तर का चयन करें!',
  S.PLEASE_ADD_AT_LEAST_OPTIONS: 'कृपया कम से कम 2 विकल्प जोड़ें',
  S.MARKS: 'निशान',
  S.OPTION: 'विकल्प',
  S.ANSWER: 'उत्तर',

  // Classroom
  S.ADD_CLASSROOM: 'कक्षा जोड़ें',
  S.CLASSROOM_TITLE: 'कक्षा का शीर्षक',
  S.CLASSROOM_DESCRIPTION: 'कक्षा विवरण',
  S.CLASSROOM_PRIVACY: 'कक्षा की गोपनीयता',
  S.WHO_CAN_JOIN: 'कौन शामिल हो सकता है?',
  S.ANYONE_CAN_JOIN: 'कोई भी शामिल हो सकता है!',
  S.ACCEPT_JOIN_REQUESTS: 'जुड़ने के अनुरोध स्वीकार करें!',
  S.WHO_CAN_SHARE_MESSAGES: 'संदेश कौन साझा कर सकता है?',
  S.ADMIN_ONLY: 'केवल व्यवस्थापक',
  S.ALL: 'सब',
  S.ADD_MEMBER: 'सदस्य जोड़ें',
  S.IMPORT_VIA_EXCEL: 'आयात Excel',
  S.ADMIN: 'व्यवस्थापक',
  S.SEARCH_PERSON: 'व्यक्ति खोजें',
  S.REMOVE: 'हटाना',
  S.MAKE_ADMIN: 'एडमिन बनाओ',
  S.NOT_ADMIN: 'एडमिन नहीं',
  S.MEMBERS: 'सदस्यों',
  S.GO_TO_CHAT: 'चैट पर जाएं',
  S.SCHEDULE_EXAM: 'अनुसूची परीक्षा',
  S.CLASSROOM_NOTES: 'कक्षा नोट',
  S.PUBLIC_CLASSROOMS: 'पब्लिक क्लासरूम',

  S.RUNNING_EXAM: 'परीक्षा चल रही है',
  S.UPCOMING_EXAM: 'आगामी परीक्षा',
  S.COMPLETED_EXAM: 'पूर्ण परीक्षा',

  S.VIEW_ALL_RUNNING_EXAMS: 'सभी चल रही परीक्षा देखें',
  S.VIEW_ALL_UPCOMING_EXAMS: 'सभी आगामी परीक्षाएं देखें',
  S.VIEW_ALL_COMPLETED_EXAMS: 'सभी पूर्ण परीक्षाएं देखें',

  S.JUST_NOW: 'अभी',
  S.SECONDS_AGO: 'एक सेकंड पहले',
  S.MINUTES_AGO: 'कुछ देर पहले',
  S.HOURS_AGO: 'घंंटों पहले',

  S.SEE_PUBLIC_CLASSROOMS: 'पब्लिक क्लासरूम देखें',

  // Exam Conducted
  S.SELECT_EXAM: 'परीक्षा का चयन करें',
  S.CREATE_NEW_EXAM: 'नई परीक्षा बनाएँ',
  S.RANDOM_QUESTION_EXAM: 'रैंडम प्रश्न परीक्षा',
  S.MUST_JOIN_ON_START: 'स्टार्ट पर जुड़ना होगा',
  S.DELAY_ALLOWED: "विलंबित अनुमति",
  S.MUST_FINISH_WITHIN_TIME: 'समय के भीतर खत्म करना होगा',
  S.ALLOW_RESUME_EXAM: 'परीक्षा फिर से शुरू करने की अनुमति दें',
  S.ALLOW_TO_ATTEND_MULTIPLE_TIME: 'कई बार उपस्थित होने की अनुमति दें',
  S.SCHEDULE_EXAM_FOR_LATER: 'बाद के लिए अनुसूची परीक्षा',
  S.EXAM_START_TIME: 'परीक्षा प्रारंभ समय',
  S.SELECT_START_TIME: 'प्रारंभ समय का चयन करें',
  S.CAN_EXAM_EXPIRE: 'एक्सपायर हो सकती है जांच?',
  S.EXAM_EXPIRE_TIME: 'परीक्षा का समय समाप्त',
  S.SELECT_EXPIRE_TIME: 'समय समाप्त करें का चयन करें',
  S.SHOW_SOLUTION_AND_ANSWER: 'समाधान दिखाएं और जवाब दें',
  S.CAN_ASK_DOUBT: 'संदेह पूछ सकते हैं?',
  S.PLEASE_SELECT_DATE_TIME: 'कृपया दिनांक और समय चुनें।',
  S.PLEASE_EXPIRE_TIME_AFTER_START_TIME:
      'कृपया प्रारंभ समय के बाद समय समाप्त करें का चयन करें।',
  S.JOIN: 'शामिल हों',
  S.VIEW_RESULT: 'परिणाम देख',
  S.START_TIME: 'समय शुरू',
  S.EXPIRE_TIME: 'समाप्त हुई समय सीमा',
  S.NO_EXPIRE_TIME: 'कोई समय समाप्त नहीं हुआ',
  S.SEND_REQUEST: 'अनुरोध भेजा',

  // Running Exam
  S.START: 'शुरू',
  S.SUBMIT: 'प्रस्तुत',
  S.PREVIOUS: 'पहले का',
  S.NEXT: 'अगला',
  S.CLEAR: 'स्पष्ट',
  S.CORRECT_ANSWER_IS: 'सही उत्तर है',
  S.YOU_SUBMITTED_CORRECT_ANSWER: 'सही उत्तर प्रस्तुत किया',
  S.YOU_SUBMITTED_WRONG_ANSWER: 'गलत उत्तर प्रस्तुत किया',
  S.I_HAVE_DOUBT: 'मुझे शक है',
  S.SHOW_SOLUTION: 'समाधान दिखाएं',
  S.PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT:
      'कृपया उत्तर चुनें और फिर सबमिट करें।',
  S.PLEASE_ENTER_ANSWER_AND_THEN_SUBMIT:
      'कृपया उत्तर दर्ज करें और फिर सबमिट करें।',
  S.RESULT: 'परिणाम',
  S.STARTED_AT: 'इस समय पर शुरू किया',
  S.EXAM_COMPLETED_IN: 'में पूरी परीक्षा',
  S.MINUS_MARKS: 'माइनस के निशान',
  S.MAXIMUM_MARKS: 'अधिकतम अंक',
  S.PERCENTAGE: 'प्रतिशत',
  S.WITHOUT_MINUS_MARKS: 'बिना माइनस के निशान',
  S.SHOW_ANSWERS: 'जवाब दिखाएँ',
  S.YOU_LATE: 'तुम देरी से हो',
  S.EXAM_ENDED: 'परीक्षा समाप्त हुई',
  S.OUT_OF_TIME_EXAM_WLL_BE_SAVED: 'आप समय से बाहर हैं। परीक्षा बच जाएगी।',
  S.YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW:
      'क्षमा करें, आपको इस परीक्षा के लिए देर हो चुकी है। अब आप परीक्षा में शामिल नहीं हो सकते।',
  S.EXAM_EXPIRED: 'परीक्षा समाप्त',
  S.THIS_EXAM_IS_EXPIRED: 'क्षमा करें, यह परीक्षा समाप्त हो गई है।',
  S.ATTEND_AGAIN: 'फिर से उपस्थित हों',
  S.WOULD_YOU_GIVE_EXAM_AGAIN_OLD_EXAM_DELETED:
      'क्या आप फिर से परीक्षा देना चाहेंगे? पुरानी परीक्षा को हटा दिया जाएगा।',
  S.NO: 'नहीं न',
  S.YES: 'हाँ',
  S.YOU_CAN_NOT_GIVE_EXAM_AGAIN: 'आप फिर से परीक्षा नहीं दे सकते।',
  S.RESUME_EXAM: 'परीक्षा फिर से शुरू करें',
  S.YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME:
      'आप परीक्षा को फिर से शुरू नहीं कर सकते। क्योंकि आप समय से बाहर हैं।',
  S.YOU_CAN_NOT_RESUME_EXAM: 'आप परीक्षा को फिर से शुरू नहीं कर सकते।',

  // Chat
  S.TYPE_HERE: 'यहाँ टाइप करें...',

  // Share
  S.SHARE: 'शेयर',
  S.SHARE_TO_CLASSROOM: 'कक्षा में साझा करें',
  S.SHARE_OUTSIDE: 'बाहर का हिस्सा',

  // Drawer
  S.CHANGE_LANGUAGE: 'भाषा बदलें',
  S.LOG_OUT: 'लॉग आउट',
  S.LIGHT_MODE: 'प्रकाश मोड',
  S.DARK_MODE: 'डार्क मोड',

  // Languages
  S.ENGLISH_USA: 'अंग्रेजी (यूएसए)',
  S.ENGLISH_IN: 'अंग्रेजी (भारत)',
  S.HINDI_IN: 'हिंदी भारत)',

  // Buttons
  S.CONTINUE: 'जारी रखें',
  S.OKAY: 'अच्छा जी',
  S.PLUS_ADD: '+ जोड़ें',
  S.CANCEL: 'रद्द करना',
};
