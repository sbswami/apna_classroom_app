import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';

const HI_IN = {
  // Basic
  S.APP_NAME: 'CQN (क्लासरूम क्विज नोट्स)',
  S.APP_DESCRIPTION:
      'CQN (क्लासरूम क्विज नोट्स) ऐप ज्ञान साझा करने, छात्र और शिक्षक के बीच संवाद बनाने और ऑनलाइन परीक्षा के लिए बनाया गया है। इस एप्लिकेशन की प्रत्येक सुविधा केवल आपकी सहायता के लिए बनाई गई है, और हम आपसे प्रतिक्रिया प्राप्त करना चाहेंगे। कृपया अपनी प्रतिक्रिया सोशल मीडिया या स्टोर रेटिंग के माध्यम से साझा करें।\n\n"CQN (क्लासरूम क्विज नोट्स)" ऐप डाउनलोड करने के लिए धन्यवाद',
  S.APP_N: 'CQN',
  S.APP_VERSION: 'एप्लिकेशन वर्शन',

  // Sharing and etc things
  S.SHARING_NOTE:
      'नमस्कार, मैं इस अद्भुत एप्लिकेशन का उपयोग कर रहा हूं, और मुझे यह पसंद आया। यह ऐप छात्रों और शिक्षकों के लिए मददगार है।\nइसे अभी डाउनलोड करें!\n@${C.LINK}',

  // Design
  S.SOMETHING_WENT_WRONG: 'कुछ समस्या है',
  S.THIS_SHOULD_NOT_HAPPEN: 'ऐसा नहीं होना चाहिए, कृपया प्रतिक्रिया दें',
  S.PROCESSING: 'लोड हो रहा है . . .',
  S.NUMBER_HINT: 'उदाहरण 10',
  S.BAD_REQUEST: 'गलत अनुरोध',
  S.BAD_REQUEST_PLEASE_GIVE_US_FEEDBACK:
      'बुरा अनुरोध, कृपया हमें प्रतिक्रिया दें!',

  // Update
  S.NEW_UPDATE: 'नया अपडेट',
  S.SKIP_THIS_VERSION: 'इस वर्शन को छोड़ दें',
  S.UPDATE: 'अपडेट करें',

  // Maintenance
  S.UNDER_MAINTENANCE: 'रखरखाव जारी',
  S.UNDER_MAINTENANCE_MSG:
      'एप्लिकेशन रखरखाव के अधीन है, कृपया कुछ समय बाद वापस जांचें',

  // Empty State
  S.NOT_FOUND: 'कुछ नहीं मिला',
  S.NOT_FOUND_MSG: 'हमें कुछ नहीं मिला',
  S.CLEAR_FILTER: 'फिल्टर हटाएँ',
  S.START_CHAT: 'बातचीत शुरू कीजिए',
  S.START_CHAT_MSG: 'नोट्स, फ़ोटो, पीडीएफ, परीक्षा और बहुत कुछ साझा करें।',
  S.NO_MEDIA_MSG: 'हमें कोई भी मीडिया अपलोड नहीं मिला।',

  // LOGIN
  S.LOGIN: 'लॉग इन करें',
  S.PHONE_NUMBER_LABEL: '10 अंकों का फोन नंबर दर्ज करें',
  S.PLEASE_ENTER_VALID_PHONE_NUMBER: 'एक मान्य फ़ोन नंबर दर्ज करें',
  S.LOGIN_FAILED: 'लॉगिन विफल',
  S.WRONG_PHONE_NUMBER_LIMIT_EXCEED:
      'गलत फोन नंबर, सही फोन नंबर के साथ प्रयास करें',
  S.CODE_SENT: 'कोड भेजा है',
  S.LOGGED_IN_WITH_NEW_DEVICE: 'आपने एक नए मोबाइल के साथ लॉग इन किया है',
  S.LOGGED_OUT_FROM_THIS_DEVICE:
      'आप इस मोबाइल से लॉग आउट हैं, एक बार में केवल एक मोबाइल को लॉग इन किया जा सकता है',
  S.CODE: 'कोड',
  S.WRONG_OTP: 'गलत ओटीपी',
  S.OTP_MESSAGE: 'OTP बेमेल, कृपया पुनः प्रयास करें या OTP पुनः भेजें!',

  // Profile
  S.PROFILE: 'प्रोफ़ाइल',
  S.ENTER_YOUR_NAME: 'अपना नाम दर्ज करें',
  S.USERNAME: 'यूजरनेम',
  S.USERNAME_INVALID: 'यूजरनेम मान्य नहीं है',
  S.USERNAME_ALREADY_EXISTS: 'यूजरनेम पहले से मौजूद है',
  S.NAME_INVALID: 'नाम मान्य नहीं है',
  S.RESEND_OTP: 'ओटीपी पुनः भेजें?',
  S.HIDE_MY_PHONE_NUMBER: 'मेरा फ़ोन नंबर छिपाएँ',
  S.PHONE_NUMBER: 'फ़ोन नंबर',
  S.SAVE: 'सहेजें',

  S.CAMERA: 'कैमरा',
  S.GALLERY: 'गेलरी',
  S.DELETE: 'हटाएं',

  // Home
  S.CLASSROOM: 'क्लासरूम',
  S.QUIZ: 'प्रश्नोत्तरी',
  S.NOTES: 'नोट्स',

  // Notes + Quiz + Classroom
  S.ENTER_SUBJECT: 'विषय दर्ज करें',
  S.ADD_ALL_LAST_USED: 'सभी अंतिम उपयोग जोड़ें',
  S.PUBLIC: 'सार्वजनिक',
  S.PRIVATE: 'निजी',
  S.NOT_A_VALID_TITLE: 'कृपया एक मान्य शीर्षक दर्ज करें, अक्षर सीमा 100 तक',
  S.ADD_AT_LEAST_ONE_SUBJECT: 'कम से कम एक विषय जोड़ें!',
  S.PDF_VIEWER: 'पीडीएफ',
  S.IMAGE_VIEWER: 'छवि',
  S.SEARCH: 'खोज',
  S.OPEN_IMAGE: 'छवि खोलें',
  S.EDIT: 'संपादित करें',
  S.ADD_AT_LEAST_ONE_EXAM: 'कम से कम एक परीक्षा जोड़ें!',
  S.SUBJECT: 'विषय',
  S.ARE_YOU_SURE_YOU_WANT_TO_DELETE: 'क्या आप इसे मिटाना चाहते हैं?',
  S.ARE_YOU_SURE_YOU_WANT_TO_LEAVE:
      'क्या आप वाकई @${C.TITLE} को छोड़ना चाहते हैं?',
  S.CAN_NOT_DELETE_NOW:
      'अब इसे हटा नहीं सकते, कृपया बाद में पुनः प्रयास करें या हमें प्रतिक्रिया भेजें।',
  S.ARE_YOU_SURE_YOU_WANT_TO_EDIT: 'क्या आप वाकई संपादित करना चाहते हैं?',
  S.IMAGE: 'छवि',
  S.PDF: 'पीडीएफ',
  S.VIDEO: 'वीडियो',
  S.LEAVE: 'छोड़ें',
  S.REPORT: 'शिकायत',
  S.ENTER_YOUR_COMPLAIN: 'अपनी शिकायत दर्ज करें',
  S.REPORT_SUBMITTED_MESSAGE:
      'हमें आपकी शिकायत मिल गई है, हम जल्द से जल्द इसकी जांच और समाधान करेंगे।',
  S.ARE_YOU_SURE_YOU_WANT_TO_DISCARD: 'क्या आप वाकई इसे छोड़ना चाहते हैं?',
  S.DISCARD: 'छोड़ें',

  // Notes + Quiz
  S.OPEN_EDITOR: 'संपादक खोलें',
  S.UPLOAD_FILE: 'फ़ाइल अपलोड करें',
  S.ACCEPTED_FORMATS: 'PDF, JPEG, MP4',
  S.EDITOR: 'संपादक',
  S.UPLOAD: 'भेजें',

  // Notes
  S.ADD_NOTES: 'नोट्स जोड़ें',
  S.ENTER_NOTES_TITLE: 'नोट्स शीर्षक दर्ज करें',
  S.NOTE_TITLE_CAN_T_BE_EMPTY: 'नोट शीर्षक, खाली नहीं हो सकता',
  S.NO_NOTES_TO_SAVE: 'सहेजने के लिए कोई नोट्स नहीं',
  S.NOTE_TITLE: 'नोट्स शीर्षक',
  S.MOVE_UP: 'ऊपर ले जाएँ',
  S.MOVE_DOWN: 'नीचे ले जाएँ',
  S.MOVE_TO_TOP: 'शीर्ष पर ले जाएँ',
  S.MOVE_TO_BOTTOM: 'तल पर ले जाएँ',
  S.PLEASE_ENTER_THE_NOTE_TITLE: 'कृपया नोट्स शीर्षक दर्ज करें',
  S.NOTE_DELETE_NOTE:
      'डिलीट होने के बाद कोई भी इस नोट्स को पहुँच नहीं कर सकता है, इस नोट को क्लासरूम से भी डिलीट कर दिया जाएगा।',
  S.NOTE_LIST_DELETE_NOTE:
      'केवल आपके द्वारा बनाए गए नोट्स हटा दिए जाएंगे। डिलीट होने के बाद कोई भी इस नोट्स को पहुँच नहीं कर सकता है, इस नोट्स को क्लासरूम से भी डिलीट कर दिया जाएगा।',
  S.NOTES_ARE_DELETED_BY_CREATOR: 'नोट्स निर्माता द्वारा हटा दिए गए हैं',
  S.NOTE_EDIT_NOTE: 'सभी क्लासरूम में भी नोट्स अपडेट किए जाएंगे।',
  S.YOU_DO_NOT_HAVE_ACCESS_NOTE:
      'इस नोट तक आपकी पहुँच नहीं है। निर्माता से इस नोट को एक कक्षा में साझा करने के लिए कहें।',
  S.NOTE_DISCARD: 'क्या आप इस नोट को बिना सहेजे छोड़ना चाहते हैं?',
  S.TEXT_EDITOR_DISCARD: 'क्या आप इस पाठ को सहेजे बिना छोड़ना चाहते हैं?',

  // Quiz + Exam
  S.EXAM: 'परीक्षा',
  S.ADD_EXAM: 'परीक्षा जोड़ें',
  S.ENTER_EXAM: 'परीक्षा का नाम दर्ज करें',
  S.EXAM_TITLE: 'परीक्षा का शीर्षक',
  S.EXAM_INSTRUCTION: 'परीक्षा निर्देश',
  S.PLUS_QUESTION: '+ प्रश्न',
  S.MINUS_MARKING: 'माइनस मार्किंग',
  S.MINUS_MARKS_PER_QUESTION: 'प्रति प्रश्न माइनस मार्किंग',
  S.EXAM_SOLVING_TIME: 'परीक्षा हल करने में लगने वाला समय',
  S.EXAM_MARKS: 'परीक्षा के अंक',
  S.EXAM_PRIVACY: 'परीक्षा की गोपनीयता',
  S.DIFFICULTY_LEVEL: 'कठिनाई स्तर',
  S.THIS_FIELD_IS_REQUIRED: 'यह फ़ील्ड आवश्यक है!',
  S.EASY: 'आसान',
  S.NORMAL: 'साधारण',
  S.HARD: 'मुश्किल',
  S.SOLVING_TIME_HELPER_TEXT:
      'प्रत्येक प्रश्न के लिए समय समान रूप से विभाजित किया जाएगा।',
  S.EXAM_MARKS_HELPER_TEXT:
      'प्रत्येक प्रश्न के लिए अंक समान रूप से विभाजित होंगे।',
  S.PLEASE_ADD_AT_LEAST_1_QUESTION: 'कृपया कम से कम 1 प्रश्न जोड़ें',
  S.QUESTION_ADDED: 'प्रश्न जोड़ा गया',
  S.CREATE_EXAM: 'परीक्षा बनाएँ',
  S.EXAM_DELETE_NOTE:
      'आप इस परीक्षा पुनर्स्थापित नहीं कर पाएंगे। इस परीक्षा को हटाने से आपकी निर्धारित परीक्षा प्रभावित नहीं होगी।',
  S.EXAM_DISCARD: 'क्या आप इस परीक्षा को बिना सहेजे छोड़ देना चाहते हैं?',

  // Quiz + Question
  S.QUESTION: 'प्रश्न',
  S.ADD_QUESTION: 'प्रश्न जोड़ें',
  S.NOT_A_VALID_QUESTION: 'कृपया मान्य प्रश्न दर्ज करें, अक्षर सीमा 500 तक',
  S.ADD_IMAGE: '+ छवि',
  S.IMAGE_NAME: 'छवि का नाम',
  S.PLEASE_ENTER_IMAGE_NAME: 'कृपया छवि का नाम दर्ज करें',
  S.ANSWER_TYPE: 'उत्तर का प्रकार',
  S.MULTI_CHOICE: 'बहु विकल्प',
  S.SINGLE_CHOICE: 'एकल विकल्प',
  S.DIRECT_ANSWER: 'सीधा जवाब',
  S.ENTER_OPTION: 'विकल्प डालें',
  S.NOT_A_VALID_ANSWER: 'मान्य उत्तर नहीं',
  S.ENTER_ANSWER: 'उत्तर दर्ज करें',
  S.ANSWER_FORMAT: 'उत्तर प्रारूप',
  S.ANSWER_FORMAT_HINT: 'उदाहरण, केवल संख्या',
  S.ANSWER_HINT: 'उत्तर सहायक-सूचना',
  S.SOLVING_TIME: 'हल करने का समय',
  S.HOUR: 'घंटे',
  S.MINUTE: 'मिनट',
  S.SECOND: 'सेकंड',
  S.ENTER_MARKS: 'अंक दर्ज करें',
  S.ADD_SOLUTION: 'समाधान जोड़ें',
  S.PLEASE_SELECT_CORRECT_ANSWER: 'कृपया सही उत्तर का चयन करें!',
  S.PLEASE_ADD_AT_LEAST_OPTIONS: 'कृपया कम से कम 2 विकल्प जोड़ें',
  S.MARKS: 'अंक',
  S.OPTION: 'विकल्प',
  S.ANSWER: 'उत्तर',
  S.QUESTION_DELETE_NOTE:
      'आप हटाने के बाद प्रश्नों को पुनर्स्थापित नहीं कर सकते। आपकी बनाई गई परीक्षाएँ सुरक्षित हैं और यह विलोपन उन्हें प्रभावित नहीं करता है।',
  S.QUESTION_EDIT_NOTE:
      'यहां प्रश्न संपादन आपके बनाए या अनुसूचित परीक्षा को प्रभावित नहीं करेगा।',
  S.QUESTION_DISCARD: 'क्या आप इस प्रश्न को बिना सहेजे छोड़ देना चाहते हैं?',

  // Classroom
  S.ADD_CLASSROOM: 'क्लासरूम जोड़ें',
  S.CLASSROOM_TITLE: 'क्लासरूम का शीर्षक',
  S.CLASSROOM_DESCRIPTION: 'क्लासरूम विवरण',
  S.CLASSROOM_PRIVACY: 'क्लासरूम की गोपनीयता',
  S.WHO_CAN_JOIN: 'कौन शामिल हो सकता है?',
  S.ANYONE_CAN_JOIN: 'कोई भी शामिल हो सकते हैं!',
  S.ACCEPT_JOIN_REQUESTS: 'जुड़ने के अनुरोध स्वीकार करें!',
  S.WHO_CAN_SHARE_MESSAGES: 'संदेश कौन साझा कर सकता है?',
  S.ADMIN_ONLY: 'केवल व्यवस्थापक',
  S.ALL: 'सब',
  S.ADD_MEMBER: 'सदस्य जोड़ें',
  S.IMPORT_VIA_EXCEL: 'आयात Excel',
  S.ADMIN: 'व्यवस्थापक',
  S.SEARCH_PERSON: 'व्यक्ति खोजें',
  S.REMOVE: 'हटाएँ',
  S.MAKE_ADMIN: 'व्यवस्थापक बनाएं',
  S.NOT_ADMIN: 'व्यवस्थापक नहीं',
  S.MEMBERS: 'सदस्य',
  S.GO_TO_CHAT: 'चैट पर जाएं',
  S.SCHEDULE_EXAM: 'परीक्षा निर्धारित करें',
  S.CLASSROOM_NOTES: 'क्लासरूम नोट्स',
  S.PUBLIC_CLASSROOMS: 'सार्वजनिक क्लासरूम',
  S.CLASSROOM_DELETE_NOTE:
      'यह सभी संदेश, इस क्लासरूम के लिए परीक्षा और नोट्स साझाकरण को हटा देगा। आप इसे पुनर्स्थापित नहीं कर पाएंगे।',
  S.CLASSROOM_DELETED_BY_CREATOR:
      'निर्माता द्वारा क्लासरूम को हटा दिया गया है।',
  S.YOU_DO_NOT_HAVE_ACCESS_CLASSROOM: 'आपके पास इस क्लासरूम तक पहुँच नहीं है',
  S.DO_YOU_WANT_SEND_JOIN_REQUEST:
      '"@${C.TITLE}", क्या आप एक जुड़ने का अनुरोध भेजना चाहते हैं?',
  S.DELETE_JOIN_REQUEST: 'क्या आप जुड़ने के अनुरोध को हटाना चाहते हैं?',
  S.WANT_TO_JOIN: '"@${C.TITLE}", शामिल होना चाहते हैं',
  S.LEAVE_CLASSROOM_MESSAGE:
      'आप संदेशों, परीक्षा, नोट्स को नहीं देख पाएंगे, जो इस कक्षा में हैं।',
  S.CLASSROOM_DISCARD: 'क्या आप इन क्लासरूम परिवर्तनों को छोड़ना चाहते हैं?',
  S.YOU_HAVE_REQUESTED_TO_JOIN: 'आपने जुड़ने का अनुरोध किया है',
  S.JOIN_REQUESTS: ' जुड़ने के अनुरोध',
  S.ACCEPT: 'स्वीकार करें',

  S.RUNNING_EXAM: 'चल रही परीक्षा',
  S.UPCOMING_EXAM: 'आगामी परीक्षा',
  S.COMPLETED_EXAM: 'पूर्ण परीक्षा',

  S.VIEW_ALL_RUNNING_EXAMS: 'सभी चल रही परीक्षाएं देखें',
  S.VIEW_ALL_UPCOMING_EXAMS: 'सभी आगामी परीक्षाएं देखें',
  S.VIEW_ALL_COMPLETED_EXAMS: 'सभी पूर्ण परीक्षाएं देखें',

  S.JUST_NOW: 'अभी',
  S.SECONDS_AGO: 'सेकंड पहले',
  S.MINUTES_AGO: 'मिनट पहले',
  S.HOURS_AGO: 'घंटे पहले',

  S.SEE_PUBLIC_CLASSROOMS: 'सार्वजनिक क्लासरूम देखें',

  // Exam Conducted
  S.SELECT_EXAM: 'परीक्षा का चयन करें',
  S.CREATE_NEW_EXAM: 'नई परीक्षा बनाएँ',
  S.RANDOM_QUESTION_EXAM: 'रैंडम प्रश्न परीक्षा',
  S.MUST_JOIN_ON_START: 'परीक्षा शुरू होते ही शामिल होना चाहिए',
  S.DELAY_ALLOWED: "कितने विलंबित की अनुमति है",
  S.MUST_FINISH_WITHIN_TIME: 'समय के भीतर खत्म करना होगा',
  S.ALLOW_RESUME_EXAM: 'परीक्षा फिर से शुरू करने की अनुमति दें',
  S.ALLOW_TO_ATTEND_MULTIPLE_TIME: 'कई बार प्रयास करने दें',
  S.SCHEDULE_EXAM_FOR_LATER: 'परीक्षा बाद में शुरू करें',
  S.EXAM_START_TIME: 'परीक्षा प्रारंभ समय',
  S.SELECT_START_TIME: 'प्रारंभ समय का चयन करें',
  S.CAN_EXAM_EXPIRE: 'क्या परीक्षा एक्सपायर हो सकती है?',
  S.EXAM_EXPIRE_TIME: 'परीक्षा का एक्सपायर समय',
  S.SELECT_EXPIRE_TIME: 'एक्सपायरी समय का चयन करें',
  S.SHOW_SOLUTION_AND_ANSWER: 'समाधान दिखाएं और जवाब बताएं',
  S.CAN_ASK_DOUBT: 'संदेह पूछ सकते हैं?',
  S.PLEASE_SELECT_DATE_TIME: 'कृपया दिनांक और समय चुनें।',
  S.PLEASE_EXPIRE_TIME_AFTER_START_TIME:
      'कृपया प्रारंभ समय के बाद का एक्सपायरी समय चुनें।।',
  S.JOIN: 'शामिल हों',
  S.VIEW_RESULT: 'परिणाम देखें',
  S.START_TIME: 'प्रारंभ समय',
  S.EXPIRE_TIME: 'एक्सपायरी समय',
  S.NO_EXPIRE_TIME: 'कोई एक्सपायरी समय नहीं',
  S.SEND_REQUEST: 'अनुरोध भेजें',
  S.NUMBER_OF_QUESTIONS: 'प्रश्नों की संख्या',
  S.NUMBER_OF_QUESTIONS_HELPER_TEXT: 'यह आपके बनाए हुए प्रश्नों को ही उठाएगा',
  S.DELETE_RUNNING_EXAM_NOTE:
      'यदि आप इस परीक्षा को हटा देते हैं, तो परीक्षा देने वाला कोई भी व्यक्ति परीक्षा स्क्रीन से बाहर निकल जाएगा और इस परीक्षा का कोई रिकॉर्ड नहीं बचेगा।',
  S.DELETE_UPCOMING_EXAM_NOTE: 'इस परीक्षा को कोई नहीं दे पाएगा',
  S.DELETE_COMPLETED_EXAM_NOTE:
      'यदि आप इस परीक्षा को यहां से हटाते हैं, तो आप परिणाम खो देंगे और फिर से परिणाम नहीं देख पाएंगे, यह सभी के लिए परिणाम हटा देगा।',
  S.REASON_OF_DELETION: 'हटाने का कारण',
  S.ENTER_REASON: 'कारण दर्ज करें',
  S.PLEASE_SELECT_EXAM_TO_SCHEDULE: 'कृपया परीक्षा का चयन करें।',

  // Running Exam
  S.START: 'शुरू',
  S.SUBMIT: 'सबमिट',
  S.PREVIOUS: 'पहले',
  S.NEXT: 'अगला',
  S.CLEAR: 'साफ़',
  S.CORRECT_ANSWER_IS: 'सही उत्तर है',
  S.YOU_SUBMITTED_CORRECT_ANSWER: 'सही उत्तर सबमिट किया',
  S.YOU_SUBMITTED_WRONG_ANSWER: 'गलत उत्तर सबमिट किया',
  S.I_HAVE_DOUBT: 'मुझे शक है',
  S.SHOW_SOLUTION: 'समाधान दिखाएं',
  S.PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT:
      'कृपया उत्तर चुनें और फिर सबमिट करें।',
  S.PLEASE_ENTER_ANSWER_AND_THEN_SUBMIT:
      'कृपया जवाब दर्ज करें और फिर सबमिट करें।',
  S.RESULT: 'परिणाम',
  S.STARTED_AT: 'शुरू करने का समय',
  S.EXAM_COMPLETED_IN: 'में परीक्षा पूर्ण',
  S.MINUS_MARKS: 'माइनस अंक',
  S.MAXIMUM_MARKS: 'अधिकतम अंक',
  S.PERCENTAGE: 'प्रतिशत',
  S.WITHOUT_MINUS_MARKS: 'बिना माइनस के अंक',
  S.SHOW_ANSWERS: 'जवाब दिखाएँ',
  S.YOU_LATE: 'तुम देरी से हो',
  S.EXAM_ENDED: 'परीक्षा समाप्त हुई',
  S.OUT_OF_TIME_EXAM_WLL_BE_SAVED: 'आप समय से बाहर हैं परीक्षा सहेज दी जाएगी।',
  S.YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW:
      'क्षमा करें, आपको इस परीक्षा के लिए देर हो चुकी है। अब आप परीक्षा में शामिल नहीं हो सकते।',
  S.EXAM_EXPIRED: 'परीक्षा समाप्त',
  S.THIS_EXAM_IS_EXPIRED: 'क्षमा करें, यह परीक्षा समाप्त हो गई है।',
  S.ATTEND_AGAIN: 'फिर से प्रयास करें',
  S.WOULD_YOU_GIVE_EXAM_AGAIN_OLD_EXAM_DELETED:
      'क्या आप फिर से परीक्षा देना चाहेंगे? पुरानी परीक्षा को हटा दिया जाएगा।',
  S.NO: 'नहीं',
  S.YES: 'हाँ',
  S.YOU_CAN_NOT_GIVE_EXAM_AGAIN: 'आप फिर से परीक्षा नहीं दे सकते हैं।',
  S.RESUME_EXAM: 'परीक्षा फिर से शुरू करें',
  S.YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME:
      'आप परीक्षा को फिर से शुरू नहीं कर सकते। क्योंकि आप समय से बाहर हैं।',
  S.YOU_CAN_NOT_RESUME_EXAM: 'आप परीक्षा को फिर से शुरू नहीं कर सकते।',
  S.THIS_EXAM_IS_DELETED: '"@${C.TITLE}" परीक्षा हटा दी गई है',
  S.EXAM_DELETED_NOTE:
      '"@${C.TITLE}" परीक्षा के निर्माता द्वारा परीक्षा को हटा दिया जाता है, इस परीक्षा के रद्द होने का कारण है - \n@${C.REASON}',
  S.SWITCH_QUESTIONS: 'प्रश्न स्विच करें',
  S.DISCARD_RUNNING_EXAM:
      'क्या आप वास्तव में इस परीक्षा से बाहर निकलना चाहते हैं? आपके सभी सबमिट किए गए उत्तर संग्रहीत हैं।',
  S.SUBMIT_EXAM: 'परीक्षा समाप्त करें',
  S.SUBMIT_EXAM_MESSAGE:
      'क्या आपने सभी सवालों के जवाब दिए हैं? क्या आप इस परीक्षा को समाप्त करना चाहते हैं?',

  // Chat
  S.TYPE_HERE: 'यहा लिखो...',
  S.MESSAGED_DELETED: 'यह संदेश हटा दिया गया है',
  S.COPY: 'प्रतिलिपि',
  S.MESSAGE_COPIED: 'संदेश की प्रतिलिपि बनाई गई',

  // Share
  S.SHARE: 'शेयर',
  S.SHARE_TO_CLASSROOM: 'क्लासरूम में',
  S.SHARE_OUTSIDE: 'शेयर',

  // Drawer
  S.CHANGE_LANGUAGE: 'भाषा बदलें',
  S.LOG_OUT: 'लॉग आउट',
  S.LIGHT_MODE: 'प्रकाश मोड',
  S.DARK_MODE: 'डार्क मोड',
  S.INVITE: 'आमंत्रण',
  S.RATE_US: 'रेटिंग',
  S.NEED_HELP: 'मदद',
  S.ABOUT: 'बारे में',

  // Languages
  S.ENGLISH_USA: 'अंग्रेजी (यूएसए)',
  S.ENGLISH_IN: 'अंग्रेजी (भारत)',
  S.HINDI_IN: 'हिंदी (भारत)',

  // Sharing
  S.CLASSROOM_DETAILS_SHARING_TEXT:
      '@${C.TITLE}\nक्लासरूम को @${C.USER} ने आपके साथ साझा किया है।\nइसे यहाँ @${C.LINK} से खोलें',
  S.NOTE_DETAILS_SHARING_TEXT:
      '@${C.TITLE}\nनोट्स को @${C.USER} ने आपके साथ साझा किया है।\nइसे यहाँ @${C.LINK} से खोलें',
  S.EXAM_DETAILS_SHARING_TEXT:
      '@${C.TITLE}\nपरीक्षा को @${C.USER} ने आपके साथ साझा किया है।\nइसे यहाँ @${C.LINK} से खोलें',

  // Buttons
  S.CONTINUE: 'जारी रखें',
  S.OKAY: 'अच्छा जी',
  S.PLUS_ADD: '+ जोड़ें',
  S.CANCEL: 'रद्द करें',

  // Video
  S.QUALITY: 'गुणवत्ता',
  S.SPEED: 'स्पीड',
  S.FILE_NOT_ALLOWED: 'फ़ाइल की अनुमति नहीं है',
  S.COMPLETE_GUIDE_LINE: 'फ़ाइल 200MB से कम होनी चाहिए',

  // Social Media
  S.TWITTER: 'ट्विटर',
  S.FACEBOOK: 'फेसबुक',
  S.INSTAGRAM: 'इंस्टाग्राम',
  S.YOUTUBE: 'यूट्यूब',
};
