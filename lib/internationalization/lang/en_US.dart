import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/util/c.dart';

const EN_US = {
  // Basic
  S.APP_NAME: 'Apna Classroom',
  S.APP_N: 'Apna',

  // Sharing and etc things
  S.SHARING_NOTE:
      'Hey There, I am using this amazing application and I loved it. This app is helpful for student and teachers.\nDownload it now!\n@link',

  // Design
  S.SOMETHING_WENT_WRONG: 'Something Went Wrong',
  S.THIS_SHOULD_NOT_HAPPEN: 'This should not happen, Please provide feedback',
  S.PROCESSING: 'Processing . . .',
  S.NUMBER_HINT: 'eg. 10',
  S.BAD_REQUEST: 'Bad Request',
  S.BAD_REQUEST_PLEASE_GIVE_US_FEEDBACK:
      'Bad request, Please give us feedback!',

  // Design
  S.NEW_UPDATE: 'New Upload',
  S.SKIP_THIS_VERSION: 'Skip this version',
  S.UPDATE: 'Update',

  // Empty State
  S.NOT_FOUND: 'Not Found',
  S.NOT_FOUND_MSG: 'We did not find anything',
  S.CLEAR_FILTER: 'Clear Filter',
  S.START_CHAT: 'Start Chat',
  S.START_CHAT_MSG: 'Share Notes, Photos, PDF, Exam and lot more.',
  S.NO_MEDIA_MSG: 'We did not find any media uploaded.  ',

  // LOGIN
  S.LOGIN: 'Login',
  S.PHONE_NUMBER_LABEL: 'Enter 10 digit phone number',
  S.PLEASE_ENTER_VALID_PHONE_NUMBER: 'Enter valid phone number',
  S.LOGIN_FAILED: 'Login Failed',
  S.WRONG_PHONE_NUMBER_LIMIT_EXCEED:
      'Either wrong phone number or you exceed the limit of verification in 4 Hours. Try with the correct phone number or Try after 4 Hours',
  S.CODE_SENT: 'Code Sent',
  S.LOGGED_IN_WITH_NEW_DEVICE: 'You have logged in with new device',
  S.LOGGED_OUT_FROM_THIS_DEVICE:
      'You are logged out from this device, only one device can logged in at a time',

  // Profile
  S.PROFILE: 'Profile',
  S.ENTER_YOUR_NAME: 'Enter your name',
  S.USERNAME: 'Username',
  S.USERNAME_INVALID: 'Username is not valid',
  S.USERNAME_ALREADY_EXISTS: 'Username already exists',
  S.NAME_INVALID: 'Name is not valid',
  S.RESEND_OTP: 'Resend OTP?',
  S.HIDE_MY_PHONE_NUMBER: 'Hide my Phone Number',
  S.PHONE_NUMBER: 'Phone Number',
  S.SAVE: 'Save',

  S.CAMERA: 'Camera',
  S.GALLERY: 'Gallery',
  S.DELETE: 'Delete',

  // Home
  S.CLASSROOM: 'Classroom',
  S.QUIZ: 'Quiz',
  S.NOTES: 'Notes',

  // Notes + Quiz + Classroom
  S.ENTER_SUBJECT: 'Enter Subject',
  S.ADD_ALL_LAST_USED: 'Add all last used',
  S.PUBLIC: 'Public',
  S.PRIVATE: 'Private',
  S.NOT_A_VALID_TITLE: 'Please enter valid title, Character limit to 100',
  S.ADD_AT_LEAST_ONE_SUBJECT: 'Add at least one subject!',
  S.PDF_VIEWER: 'PDF Viewer',
  S.IMAGE_VIEWER: 'Image Viewer',
  S.SEARCH: 'Search',
  S.OPEN_IMAGE: 'Open Image',
  S.EDIT: 'Edit',
  S.ADD_AT_LEAST_ONE_EXAM: 'Add at lease one exam!',
  S.SUBJECT: 'Subject',
  S.ARE_YOU_SURE_YOU_WANT_TO_DELETE: 'Are you sure you want to delete?',
  S.ARE_YOU_SURE_YOU_WANT_TO_LEAVE:
      'Are you sure you want to leave @${C.TITLE}?',
  S.CAN_NOT_DELETE_NOW:
      'Can not delete now, Please try again later or send us feedback.',
  S.ARE_YOU_SURE_YOU_WANT_TO_EDIT: 'Are you sure you want to edit?',
  S.IMAGE: 'Image',
  S.PDF: 'PDF',
  S.VIDEO: 'Video',
  S.LEAVE: 'Leave',
  S.REPORT: 'Report',
  S.ENTER_YOUR_COMPLAIN: 'Enter your complain',
  S.REPORT_SUBMITTED_MESSAGE:
      'We got your report, we will check and resolve as soon as possible.',
  S.ARE_YOU_SURE_YOU_WANT_TO_DISCARD: 'Are you sure you want to discard?',
  S.DISCARD: 'Discard',

  // Notes + Quiz
  S.OPEN_EDITOR: 'Open Editor',
  S.UPLOAD_FILE: 'Upload File',
  S.ACCEPTED_FORMATS: 'PDF, JPEG, MP4',
  S.EDITOR: 'Editor',
  S.UPLOAD: 'Upload',

  // Notes
  S.ADD_NOTES: 'Add Notes',
  S.ENTER_NOTES_TITLE: 'Enter Notes title',
  S.NOTE_TITLE_CAN_T_BE_EMPTY: 'Note title, can\'t be empty',
  S.NO_NOTES_TO_SAVE: 'No notes to save',
  S.NOTE_TITLE: 'Note Title',
  S.MOVE_UP: 'Move up',
  S.MOVE_DOWN: 'Move down',
  S.MOVE_TO_TOP: 'Move to top',
  S.MOVE_TO_BOTTOM: 'Move to bottom',
  S.PLEASE_ENTER_THE_NOTE_TITLE: 'Please enter the note Title',
  S.NOTE_DELETE_NOTE:
      'No body can access this note after deletion, This note will be deleted from Classrooms as well.',
  S.NOTE_LIST_DELETE_NOTE:
      'Notes which are created by you, only these Notes will be deleted. No body can access this note after deletion, This note will be deleted from Classrooms as well.',
  S.NOTES_ARE_DELETED_BY_CREATOR: 'Notes are deleted by the Creator',
  S.NOTE_EDIT_NOTE: 'Notes will be updated in all Classroom as well.',
  S.YOU_DO_NOT_HAVE_ACCESS_NOTE:
      'You don\'t have access to this Note. Ask creator to share this Note in a Classroom.',
  S.NOTE_DISCARD: 'Do you really want to discard this Note?',
  S.TEXT_EDITOR_DISCARD: 'Do you really want to discard this Text?',

  // Quiz + Exam
  S.EXAM: 'Exam',
  S.ADD_EXAM: 'Add Exam',
  S.ENTER_EXAM: 'Enter Exam',
  S.EXAM_TITLE: 'Exam Title',
  S.EXAM_INSTRUCTION: 'Exam Instruction',
  S.PLUS_QUESTION: '+ Question',
  S.MINUS_MARKING: 'Minus Marking',
  S.MINUS_MARKS_PER_QUESTION: 'Minus marking per question',
  S.EXAM_SOLVING_TIME: 'Exam Solving Time',
  S.EXAM_MARKS: 'Exam Marks',
  S.EXAM_PRIVACY: 'Exam Privacy',
  S.DIFFICULTY_LEVEL: 'Difficulty Level',
  S.THIS_FIELD_IS_REQUIRED: 'This field is required!',
  S.EASY: 'Easy',
  S.NORMAL: 'Normal',
  S.HARD: 'Hard',
  S.SOLVING_TIME_HELPER_TEXT: 'Time will be equally divided for each question.',
  S.EXAM_MARKS_HELPER_TEXT: 'Marks will be equally divided for each question.',
  S.PLEASE_ADD_AT_LEAST_1_QUESTION: 'Please add at least 1 Question',
  S.QUESTION_ADDED: 'Question Added',
  S.CREATE_EXAM: 'Create Exam',
  S.EXAM_DELETE_NOTE:
      'You will not able to restore this exam. Your scheduled exam will not effected by deletion of this exam.',
  S.EXAM_DISCARD: 'Do you really want to discard this Exam?',

  // Quiz + Question
  S.QUESTION: 'Question',
  S.ADD_QUESTION: 'Add Question',
  S.NOT_A_VALID_QUESTION: 'Please enter valid question, Character limit to 500',
  S.ADD_IMAGE: '+ Image',
  S.IMAGE_NAME: 'Image name',
  S.PLEASE_ENTER_IMAGE_NAME: 'Please enter image name',
  S.ANSWER_TYPE: 'Answer Type',
  S.MULTI_CHOICE: 'Multi choice',
  S.SINGLE_CHOICE: 'Single choice',
  S.DIRECT_ANSWER: 'Direct answer',
  S.ENTER_OPTION: 'Enter Option',
  S.NOT_A_VALID_ANSWER: 'Not a valid answer',
  S.ENTER_ANSWER: 'Enter Answer',
  S.ANSWER_FORMAT: 'Answer Format',
  S.ANSWER_FORMAT_HINT: 'eg. Only Number',
  S.ANSWER_HINT: 'Answer Hint',
  S.SOLVING_TIME: 'Solving Time',
  S.HOUR: 'Hour',
  S.MINUTE: 'Minute',
  S.SECOND: 'Second',
  S.ENTER_MARKS: 'Enter Marks',
  S.ADD_SOLUTION: 'Add Solution',
  S.PLEASE_SELECT_CORRECT_ANSWER: 'Please select correct answer!',
  S.PLEASE_ADD_AT_LEAST_OPTIONS: 'Please add at least 2 options',
  S.MARKS: 'Marks',
  S.OPTION: 'Option',
  S.ANSWER: 'Answer',
  S.QUESTION_DELETE_NOTE:
      'You can not restore question after delete. Your created exams are safe and this deletion does not effect them.',
  S.QUESTION_EDIT_NOTE:
      'Question editing here will not effect any of your created or scheduled exams.',
  S.QUESTION_DISCARD: 'Do you really want to discard this Question?',

  // Classroom
  S.ADD_CLASSROOM: 'Add Classroom',
  S.CLASSROOM_TITLE: 'Classroom Title',
  S.CLASSROOM_DESCRIPTION: 'Classroom Description',
  S.CLASSROOM_PRIVACY: 'Classroom Privacy',
  S.WHO_CAN_JOIN: 'Who can join?',
  S.ANYONE_CAN_JOIN: 'Anyone can join!',
  S.ACCEPT_JOIN_REQUESTS: 'Accept join requests!',
  S.WHO_CAN_SHARE_MESSAGES: 'Who can share messages?',
  S.ADMIN_ONLY: 'Admin Only',
  S.ALL: 'All',
  S.ADD_MEMBER: 'Add Member',
  S.IMPORT_VIA_EXCEL: 'Import Via Excel',
  S.ADMIN: 'Admin',
  S.SEARCH_PERSON: 'Search Person',
  S.REMOVE: 'Remove',
  S.MAKE_ADMIN: 'Make Admin',
  S.NOT_ADMIN: 'Not Admin',
  S.MEMBERS: 'Members',
  S.GO_TO_CHAT: 'Go to Chat',
  S.SCHEDULE_EXAM: 'Schedule Exam',
  S.CLASSROOM_NOTES: 'Classroom Note',
  S.PUBLIC_CLASSROOMS: 'Public Classrooms',
  S.CLASSROOM_DELETE_NOTE:
      'It will delete all messages, Exams for this Classroom, and Notes sharing. You will not able to restore this.',
  S.CLASSROOM_DELETED_BY_CREATOR: 'Classroom is deleted by Creator.',
  S.YOU_DO_NOT_HAVE_ACCESS_CLASSROOM:
      'You don\'t have access to this Classroom',
  S.DO_YOU_WANT_SEND_JOIN_REQUEST: '"@title", do you want send join request?',
  S.WANT_TO_JOIN: '"@${C.TITLE}", want to join',
  S.LEAVE_CLASSROOM_MESSAGE:
      'You will not be able to see messages, Exams, Notes belongs to this Classroom.',
  S.CLASSROOM_DISCARD: 'Do you really want to discard this Classroom?',

  S.RUNNING_EXAM: 'Running Exam',
  S.UPCOMING_EXAM: 'Upcoming Exam',
  S.COMPLETED_EXAM: 'Completed Exam',

  S.VIEW_ALL_RUNNING_EXAMS: 'View all running exams',
  S.VIEW_ALL_UPCOMING_EXAMS: 'View all upcoming exams',
  S.VIEW_ALL_COMPLETED_EXAMS: 'View all completed exams',

  S.JUST_NOW: 'Just now',
  S.SECONDS_AGO: 'seconds ago',
  S.MINUTES_AGO: 'minutes ago',
  S.HOURS_AGO: 'hours ago',

  S.SEE_PUBLIC_CLASSROOMS: 'See Public Classrooms',

  // Exam Conducted
  S.SELECT_EXAM: 'Select Exam',
  S.CREATE_NEW_EXAM: 'Create New Exam',
  S.RANDOM_QUESTION_EXAM: 'Random Question Exam',
  S.MUST_JOIN_ON_START: 'Must Join on Start',
  S.DELAY_ALLOWED: "Allowed Delay",
  S.MUST_FINISH_WITHIN_TIME: 'Must finish within time',
  S.ALLOW_RESUME_EXAM: 'Allow resume exam',
  S.ALLOW_TO_ATTEND_MULTIPLE_TIME: 'Allow to attend multiple time',
  S.SCHEDULE_EXAM_FOR_LATER: 'Schedule exam for later',
  S.EXAM_START_TIME: 'Exam start time',
  S.SELECT_START_TIME: 'Select start time',
  S.CAN_EXAM_EXPIRE: 'Can exam expire?',
  S.EXAM_EXPIRE_TIME: 'Exam expire time',
  S.SELECT_EXPIRE_TIME: 'Select expire time',
  S.SHOW_SOLUTION_AND_ANSWER: 'Show solution and answer',
  S.CAN_ASK_DOUBT: 'Can ask doubt?',
  S.PLEASE_SELECT_DATE_TIME: 'Please select date and time.',
  S.PLEASE_EXPIRE_TIME_AFTER_START_TIME:
      'Please select expire time after start time.',
  S.JOIN: 'Join',
  S.VIEW_RESULT: 'View Result',
  S.START_TIME: 'Start Time',
  S.EXPIRE_TIME: 'Expire Time',
  S.NO_EXPIRE_TIME: 'No expire time',
  S.SEND_REQUEST: 'Send request',
  S.NUMBER_OF_QUESTIONS: 'Number of questions',
  S.NUMBER_OF_QUESTIONS_HELPER_TEXT: 'It will pick your created questions only',
  S.DELETE_RUNNING_EXAM_NOTE:
      'If you delete this exam, anyone giving exam will be exit form exam screen and no record left for this exam.',
  S.DELETE_UPCOMING_EXAM_NOTE: 'No one will able to give this exam',
  S.DELETE_COMPLETED_EXAM_NOTE:
      'If you delete this exam from here, You will lose result and will not able to see results again, this will delete result for all.',
  S.REASON_OF_DELETION: 'Reason of deletion',
  S.ENTER_REASON: 'Enter Reason',
  S.PLEASE_SELECT_EXAM_TO_SCHEDULE: 'Please select exam to schedule.',

  // Running Exam
  S.START: 'Start',
  S.SUBMIT: 'Submit',
  S.PREVIOUS: 'Previous',
  S.NEXT: 'Next',
  S.CLEAR: 'Clear',
  S.CORRECT_ANSWER_IS: 'Correct answer is',
  S.YOU_SUBMITTED_CORRECT_ANSWER: 'Submitted correct answer',
  S.YOU_SUBMITTED_WRONG_ANSWER: 'Submitted wrong answer',
  S.I_HAVE_DOUBT: 'I have doubt',
  S.SHOW_SOLUTION: 'Show Solution',
  S.PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT:
      'Please select answer and then submit.',
  S.PLEASE_ENTER_ANSWER_AND_THEN_SUBMIT: 'Please enter answer and then submit.',
  S.RESULT: 'Result',
  S.STARTED_AT: 'Started at',
  S.EXAM_COMPLETED_IN: 'Exam complete in',
  S.MINUS_MARKS: 'Minus marks',
  S.MAXIMUM_MARKS: 'Maximum marks',
  S.PERCENTAGE: 'Percentage',
  S.WITHOUT_MINUS_MARKS: 'Without minus marks',
  S.SHOW_ANSWERS: 'Show answers',
  S.YOU_LATE: 'You\'r late',
  S.EXAM_ENDED: 'Exam Ended',
  S.OUT_OF_TIME_EXAM_WLL_BE_SAVED: 'You are out of time. Exam will be save.',
  S.YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW:
      'Sorry, You are late for this exam. You can\'t Join Exam now.',
  S.EXAM_EXPIRED: 'Exam Expired',
  S.THIS_EXAM_IS_EXPIRED: 'Sorry, This exam is expired.',
  S.ATTEND_AGAIN: 'Attend Again',
  S.WOULD_YOU_GIVE_EXAM_AGAIN_OLD_EXAM_DELETED:
      'Would you like to give the exam again? The old exam will be deleted.',
  S.NO: 'No',
  S.YES: 'Yes',
  S.YOU_CAN_NOT_GIVE_EXAM_AGAIN: 'You Can\'t give the exam again.',
  S.RESUME_EXAM: 'Resume Exam',
  S.YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME:
      'You Can\'t resume the exam. Because you are out of time.',
  S.YOU_CAN_NOT_RESUME_EXAM: 'You Can\'t resume the exam.',
  S.THIS_EXAM_IS_DELETED: '"@${C.TITLE}" Exam is deleted',
  S.EXAM_DELETED_NOTE:
      '"@${C.TITLE}" Exam is deleted by the creator of exam, the reason for this exam cancellation is - \n@${C.REASON}',
  S.SWITCH_QUESTIONS: 'Switch Questions',
  S.DISCARD_RUNNING_EXAM:
      'Do you really want to exit this Exam? All your submitted answer are stored.',
  S.SUBMIT_EXAM: 'Finish Exam',
  S.SUBMIT_EXAM_MESSAGE:
      'Have you answered all questions? Do you want to Finish this exam?',

  // Chat
  S.TYPE_HERE: 'Type here...',
  S.MESSAGED_DELETED: 'This message is deleted',
  S.COPY: 'Copy',
  S.MESSAGE_COPIED: 'Message Copied',

  // Share
  S.SHARE: 'Share',
  S.SHARE_TO_CLASSROOM: 'Share to Classroom',
  S.SHARE_OUTSIDE: 'Share Outside',

  // Drawer
  S.CHANGE_LANGUAGE: 'Change language',
  S.LOG_OUT: 'Log out',
  S.LIGHT_MODE: 'Light mode',
  S.DARK_MODE: 'Dark mode',
  S.INVITE: 'Invite',

  // Languages
  S.ENGLISH_USA: 'English (USA)',
  S.ENGLISH_IN: 'English (India)',
  S.HINDI_IN: 'Hindi (India)',

  // Sharing
  S.CLASSROOM_DETAILS_SHARING_TEXT:
      '@title\nClassroom is shared by @user with you.\nopen it here @link',
  S.NOTE_DETAILS_SHARING_TEXT:
      '@title\nNote is shared by @user with you.\nopen it here @link',
  S.EXAM_DETAILS_SHARING_TEXT:
      '@title\nExam is shared by @user with you.\nopen it here @link',

  // Buttons
  S.CONTINUE: 'Continue',
  S.OKAY: 'Okay',
  S.PLUS_ADD: '+ Add',
  S.CANCEL: 'Cancel',

  // Video
  S.QUALITY: 'Quality',
  S.SPEED: 'Speed',
};
