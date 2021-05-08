// Prod endpoint
const String API_ROOT_GET_PROD = 'cqn-api.srewa.com';
const String API_ROOT_PROD = 'http://$API_ROOT_GET_PROD';

// Dev endpoint
const String API_ROOT_GET_DEV = 'cqn-api-dev.srewa.com';
const String API_ROOT_DEV = 'http://$API_ROOT_GET_DEV';

// API Root
String apiRoot = API_ROOT_PROD;
String apiRootGet = API_ROOT_GET_PROD;

// User Routes
const String USER_ROOT = '/user';

const String USER_CREATE = '$USER_ROOT/create';
const String USER_GET = '$USER_ROOT/get';
const String USER_CHECK_USERNAME = '$USER_ROOT/check-username';
const String USER_UPDATE = '$USER_ROOT/update';
const String USER_SEARCH_PERSON = '$USER_ROOT/search';
const String USER_GET_PERSON = '$USER_ROOT/get-person';
const String USER_SUBJECTS = '$USER_ROOT/subjects';
const String USER_EXAMS = '$USER_ROOT/exams';

// User Details Routes
const String USER_DETAILS_ROOT = '/user-details';

const String USER_DETAILS_CREATE = '$USER_DETAILS_ROOT/create';
const String USER_DETAILS_UNSEEN = '$USER_DETAILS_ROOT/unseen';

// Notes Routes
const String NOTE_ROOT = '/note';

const String NOTE_CREATE = '$NOTE_ROOT/create';
const String NOTE_GET = '$NOTE_ROOT/get';
const String NOTE_LIST = '$NOTE_ROOT/list';
const String NOTE_DELETE = '$NOTE_ROOT/delete';
const String NOTE_ADD_TO_ACCESS_LIST = '$NOTE_ROOT/add-to-access-list';

// Question Routes
const String QUESTION_ROOT = '/question';

const String QUESTION_CREATE = '$QUESTION_ROOT/create';
const String QUESTION_GET = '$QUESTION_ROOT/get';
const String QUESTION_LIST = '$QUESTION_ROOT/list';
const String QUESTION_DELETE = '$QUESTION_ROOT/delete';

// Exam Routes
const String EXAM_ROOT = '/exam';

const String EXAM_CREATE = '$EXAM_ROOT/create';
const String EXAM_GET = '$EXAM_ROOT/get';
const String EXAM_LIST = '$EXAM_ROOT/list';
const String EXAM_DELETE = '$EXAM_ROOT/delete';
const String EXAM_ADD_TO_ACCESS_LIST = '$EXAM_ROOT/add-to-access-list';

// Classroom
const String CLASSROOM_ROOT = '/classroom';

const String CLASSROOM_CREATE = '$CLASSROOM_ROOT/create';
const String CLASSROOM_GET = '$CLASSROOM_ROOT/get';
const String ADD_MEMBERS_CREATE = '$CLASSROOM_ROOT/add-members';
const String REMOVE_MEMBER = '$CLASSROOM_ROOT/remove-member';
const String CLASSROOM_LIST = '$CLASSROOM_ROOT/list';
const String CLASSROOM_DELETE = '$CLASSROOM_ROOT/delete';

// Exam Conducted Routes
const String EXAM_CONDUCTED_ROOT = '/exam-conducted';

const String EXAM_CONDUCTED_CREATE = '$EXAM_CONDUCTED_ROOT/create';
const String EXAM_CONDUCTED_GET = '$EXAM_CONDUCTED_ROOT/get';
const String EXAM_CONDUCTED_LIST = '$EXAM_CONDUCTED_ROOT/list';
const String EXAM_CONDUCTED_DELETE = '$EXAM_CONDUCTED_ROOT/delete';

// Solved Exam Routes
const String SOLVED_EXAM_ROOT = '/solved-exam';

const String SOLVED_EXAM_CREATE = '$SOLVED_EXAM_ROOT/create';
const String SOLVED_EXAM_GET = '$SOLVED_EXAM_ROOT/get';
const String SOLVED_EXAM_ADD_ANSWER = '$SOLVED_EXAM_ROOT/add-answer';
const String SOLVED_EXAM_RESULT_ONE = '$SOLVED_EXAM_ROOT/result-one';
const String SOLVED_EXAM_RESULT_ALL = '$SOLVED_EXAM_ROOT/result-all';
const String SOLVED_EXAM_DELETE = '$SOLVED_EXAM_ROOT/delete';

// Media Routes
const String MEDIA_ROOT = '/media';

const String MEDIA_CREATE = '$MEDIA_ROOT/create';
const String MEDIA_GET = '$MEDIA_ROOT/get';
const String MEDIA_LIST = '$MEDIA_ROOT/list';

// Text Routes
const String TEXT_ROOT = '/text';

const String TEXT_CREATE = '$TEXT_ROOT/create';
const String TEXT_GET = '$TEXT_ROOT/get';

// Message Routes
const String MESSAGE_ROOT = '/message';

const String MESSAGE_CREATE = '$MESSAGE_ROOT/create';
const String MESSAGE_CREATE_LIST = '$MESSAGE_ROOT/create-list';
const String MESSAGE_GET = '$MESSAGE_ROOT/get';
const String MESSAGE_LIST = '$MESSAGE_ROOT/list';
const String MESSAGE_NOTE = '$MESSAGE_ROOT/note';
const String MESSAGE_DELETE = '$MESSAGE_ROOT/delete';

// Report Routes
const String REPORT_ROOT = '/report';

const String REPORT_CREATE = '$REPORT_ROOT/create';
const String REPORT_GET = '$REPORT_ROOT/get';
const String REPORT_LIST = '$REPORT_ROOT/list';

// Join Request Routes
const String JOIN_REQUEST_ROOT = '/join-request';

const String JOIN_REQUEST_CREATE = '$JOIN_REQUEST_ROOT/create';
const String JOIN_REQUEST_DELETE = '$JOIN_REQUEST_ROOT/delete';
const String JOIN_REQUEST_LIST = '$JOIN_REQUEST_ROOT/list';
