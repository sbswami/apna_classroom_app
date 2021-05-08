import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';

class S {
  // Basic
  static const String APP_NAME = 'app_name';
  static const String APP_DESCRIPTION = 'app_description';
  static const String APP_N = 'app_n';
  static const String APP_VERSION = 'app_version';

  // Sharing and etc things
  static const String SHARING_NOTE = 'sharing_note';

  // Design Info
  static const String SOMETHING_WENT_WRONG = 'something_went_wrong';
  static const String THIS_SHOULD_NOT_HAPPEN = 'this_should_not_happen';
  static const String PROCESSING = 'processing';
  static const String NUMBER_HINT = 'number_hint';
  static const String BAD_REQUEST = 'bad_request';
  static const String BAD_REQUEST_PLEASE_GIVE_US_FEEDBACK =
      'bad_request_please_give_us_feedback';

  // Update
  static const String NEW_UPDATE = 'new_update';
  static const String SKIP_THIS_VERSION = 'skip_this_version';
  static const String UPDATE = 'update';

  // Maintenance
  static const String UNDER_MAINTENANCE = 'under_maintenance';
  static const String UNDER_MAINTENANCE_MSG = 'under_maintenance_msg';

  // Empty State
  static const String NOT_FOUND = 'not_found';
  static const String NOT_FOUND_MSG = 'not_found_msg';
  static const String CLEAR_FILTER = 'clear_filter';
  static const String START_CHAT = 'start_chat';
  static const String START_CHAT_MSG = 'start_chat_msg';
  static const String NO_MEDIA_MSG = 'no_media_msg';

  // Login
  static const String LOGIN = 'login';
  static const String PHONE_NUMBER_LABEL = 'phone_number_label';
  static const String PLEASE_ENTER_VALID_PHONE_NUMBER =
      'please_enter_valid_phone_number';
  static const String LOGIN_FAILED = 'login_failed';
  static const String WRONG_PHONE_NUMBER_LIMIT_EXCEED =
      'wrong_phone_number_limit_exceed';
  static const String CODE_SENT = 'code_sent';
  static const String LOGGED_IN_WITH_NEW_DEVICE = 'logged_in_with_new_device';
  static const String LOGGED_OUT_FROM_THIS_DEVICE =
      'logged_out_from_this_device';
  static const String CODE = 'code';
  static const String WRONG_OTP = 'wrong_otp';
  static const String OTP_MESSAGE = 'otp_message';

  // Profile
  static const String PROFILE = 'profile';
  static const String ENTER_YOUR_NAME = 'enter_your_name';
  static const String USERNAME = 'username';
  static const String USERNAME_INVALID = 'username_invalid';
  static const String USERNAME_ALREADY_EXISTS = 'username_already_exists';
  static const String NAME_INVALID = 'name_invalid';
  static const String RESEND_OTP = 'resend_otp';
  static const String HIDE_MY_PHONE_NUMBER = 'hide_my_phone_number';
  static const String PHONE_NUMBER = 'phone_number';
  static const String SAVE = 'save';

  static const String CAMERA = 'camera';
  static const String GALLERY = 'gallery';
  static const String DELETE = 'delete';

  // Home
  static const String CLASSROOM = 'classroom';
  static const String QUIZ = 'quiz';
  static const String NOTES = 'notes';

  // Notes + Quiz + Classroom
  static const String ENTER_SUBJECT = 'enter_subject';
  static const String ADD_ALL_LAST_USED = 'add_all_last_used';
  static const String PUBLIC = 'public';
  static const String PRIVATE = 'private';
  static const String NOT_A_VALID_TITLE = 'not_a_valid_title';
  static const String ADD_AT_LEAST_ONE_SUBJECT = 'add_at_least_one_subject';
  static const String PDF_VIEWER = 'pdf_viewer';
  static const String IMAGE_VIEWER = 'image_viewer';
  static const String SEARCH = 'search';
  static const String OPEN_IMAGE = 'open_image';
  static const String EDIT = 'edit';
  static const String ADD_AT_LEAST_ONE_EXAM = 'add_at_least_one_exam';
  static const String SUBJECT = 'subject';
  static const String ARE_YOU_SURE_YOU_WANT_TO_DELETE =
      'are_you_sure_you_want_to_delete';
  static const String ARE_YOU_SURE_YOU_WANT_TO_LEAVE =
      'are_you_sure_you_want_to_leave';
  static const String ARE_YOU_SURE_YOU_WANT_TO_EDIT =
      'are_you_sure_you_want_to_edit';
  static const String CAN_NOT_DELETE_NOW = 'can_not_delete_now';
  static const String IMAGE = 'image';
  static const String PDF = 'pdf';
  static const String VIDEO = 'video';
  static const String LEAVE = 'leave';
  static const String REPORT = 'report';
  static const String ENTER_YOUR_COMPLAIN = 'enter_your_complain';
  static const String REPORT_SUBMITTED_MESSAGE = 'report_submitted_message';
  static const String ARE_YOU_SURE_YOU_WANT_TO_DISCARD =
      'are_you_sure_you_want_to_discard';
  static const String DISCARD = 'discard';

  // Quiz + Notes
  static const String OPEN_EDITOR = 'open_editor';
  static const String UPLOAD_FILE = 'upload_file';
  static const String UPLOAD = 'upload';
  static const String UPLOADED = 'uploaded';
  static const String ACCEPTED_FORMATS = 'accepted_formats';
  static const String EDITOR = 'editor';
  static const String UPLOADING_FILE = 'uploading_file';
  static const String DOWNLOADING_FILE = 'downloading_file';
  static const String DOWNLOADED = 'downloaded';
  static const String UPLOADING_BY_CREATOR = 'uploading_by_creator';

  // Notes
  static const String ADD_NOTES = 'add_notes';
  static const String ENTER_NOTES_TITLE = 'enter_notes_title';
  static const String NOTE_TITLE_CAN_T_BE_EMPTY = 'note_title_can_t_be_empty';
  static const String NO_NOTES_TO_SAVE = 'no_notes_to_save';
  static const String NOTE_TITLE = 'note_title';
  static const String MOVE_UP = 'move_up';
  static const String MOVE_DOWN = 'move_down';
  static const String MOVE_TO_TOP = 'move_to_top';
  static const String MOVE_TO_BOTTOM = 'move_to_bottom';
  static const String PLEASE_ENTER_THE_NOTE_TITLE =
      'please_enter_the_note_title';
  static const String NOTE_DELETE_NOTE = 'note_delete_note';
  static const String NOTE_LIST_DELETE_NOTE = 'note_list_delete_note';
  static const String NOTES_ARE_DELETED_BY_CREATOR =
      'notes_are_deleted_by_creator';
  static const String NOTE_EDIT_NOTE = 'note_edit_note';
  static const String YOU_DO_NOT_HAVE_ACCESS_NOTE =
      'you_do_not_have_access_note';
  static const String NOTE_DISCARD = 'note_discard';
  static const String TEXT_EDITOR_DISCARD = 'text_editor_discard';

  // Quiz + Exam
  static const String EXAM = 'exam';
  static const String ADD_EXAM = 'add_exam';
  static const String ENTER_EXAM = 'enter_exam';
  static const String EXAM_TITLE = 'exam_title';
  static const String EXAM_INSTRUCTION = 'exam_instruction';
  static const String PLUS_QUESTION = 'plus_question';
  static const String MINUS_MARKING = 'minus_marking';
  static const String MINUS_MARKS_PER_QUESTION = 'minus_marks_per_question';
  static const String EXAM_SOLVING_TIME = 'exam_solving_time';
  static const String EXAM_MARKS = 'exam_marks';
  static const String EXAM_PRIVACY = 'exam_privacy';
  static const String DIFFICULTY_LEVEL = 'difficulty_level';
  static const String THIS_FIELD_IS_REQUIRED = 'this_field_is_required';
  static const String EASY = 'easy';
  static const String NORMAL = 'normal';
  static const String HARD = 'hard';
  static const String SOLVING_TIME_HELPER_TEXT = 'solving_time_helper_text';
  static const String EXAM_MARKS_HELPER_TEXT = 'exam_marks_helper_text';
  static const String PLEASE_ADD_AT_LEAST_1_QUESTION =
      'please_add_at_least_1_question';
  static const String QUESTION_ADDED = 'question_added';
  static const String CREATE_EXAM = 'create_exam';
  static const String EXAM_DELETE_NOTE = 'exam_delete_note';
  static const String EXAM_DISCARD = 'exam_discard';

  // Quiz + Question
  static const String QUESTION = 'question';
  static const String ADD_QUESTION = 'add_question';
  static const String NOT_A_VALID_QUESTION = 'not_a_valid_question';
  static const String ADD_IMAGE = 'add_image';
  static const String IMAGE_NAME = 'image_name';
  static const String PLEASE_ENTER_IMAGE_NAME = 'please_enter_image_name';
  static const String ANSWER_TYPE = 'answer_type';
  static const String MULTI_CHOICE = 'multi_choice';
  static const String SINGLE_CHOICE = 'single_choice';
  static const String DIRECT_ANSWER = 'direct_answer';
  static const String ENTER_OPTION = 'enter_option';
  static const String NOT_A_VALID_ANSWER = 'not_a_valid_answer';
  static const String ENTER_ANSWER = 'enter_answer';
  static const String ANSWER_FORMAT = 'answer_format';
  static const String ANSWER_FORMAT_HINT = 'answer_format_hint';
  static const String ANSWER_HINT = 'answer_hint';
  static const String SOLVING_TIME = 'solving_time';
  static const String HOUR = 'hour';
  static const String MINUTE = 'minute';
  static const String SECOND = 'second';
  static const String ENTER_MARKS = 'enter_marks';
  static const String ADD_SOLUTION = 'add_solution';
  static const String PLEASE_SELECT_CORRECT_ANSWER =
      'please_select_correct_answer';
  static const String PLEASE_ADD_AT_LEAST_OPTIONS =
      'please_add_at_least_options';
  static const String MARKS = 'marks';
  static const String OPTION = 'option';
  static const String ANSWER = 'answer';
  static const String QUESTION_DELETE_NOTE = 'question_delete_note';
  static const String QUESTION_EDIT_NOTE = 'question_edit_note';
  static const String QUESTION_DISCARD = 'question_discard';

  // Classroom
  static const String ADD_CLASSROOM = 'add_classroom';
  static const String CLASSROOM_TITLE = 'classroom_title';
  static const String CLASSROOM_DESCRIPTION = 'classroom_description';
  static const String CLASSROOM_PRIVACY = 'classroom_privacy';
  static const String WHO_CAN_JOIN = 'who_can_join';
  static const String ANYONE_CAN_JOIN = 'anyone_can_join';
  static const String ACCEPT_JOIN_REQUESTS = 'accept_join_requests';
  static const String WHO_CAN_SHARE_MESSAGES = 'who_can_share_messages';
  static const String ADMIN_ONLY = 'admin_only';
  static const String ALL = 'all';
  static const String ADD_MEMBER = 'add_member';
  static const String IMPORT_VIA_EXCEL = 'import_via_excel';
  static const String ADMIN = 'admin';
  static const String SEARCH_PERSON = 'search_person';
  static const String REMOVE = 'remove';
  static const String MAKE_ADMIN = 'make_admin';
  static const String NOT_ADMIN = 'not_admin';
  static const String MEMBERS = 'members';
  static const String GO_TO_CHAT = 'go_to_chat';
  static const String SCHEDULE_EXAM = 'schedule_exam';
  static const String CLASSROOM_NOTES = 'classroom_notes';
  static const String PUBLIC_CLASSROOMS = 'public_classrooms';
  static const String CLASSROOM_DELETE_NOTE = 'classroom_delete_note';
  static const String CLASSROOM_DELETED_BY_CREATOR =
      'classroom_deleted_by_creator';
  static const String DO_YOU_WANT_SEND_JOIN_REQUEST =
      'do_you_want_send_join_request';
  static const String DELETE_JOIN_REQUEST = 'delete_join_request';
  static const String YOU_DO_NOT_HAVE_ACCESS_CLASSROOM =
      'you_do_not_have_access';
  static const String WANT_TO_JOIN = 'want_to_join';
  static const String LEAVE_CLASSROOM_MESSAGE = 'leave_classroom_message';
  static const String CLASSROOM_DISCARD = 'classroom_discard';
  static const String YOU_HAVE_REQUESTED_TO_JOIN = 'you_have_requested_to_join';
  static const String JOIN_REQUESTS = 'join_requests';
  static const String ACCEPT = 'accept';

  static const String RUNNING_EXAM = 'running_exam';
  static const String UPCOMING_EXAM = 'upcoming_exam';
  static const String COMPLETED_EXAM = 'completed_exam';

  static const String VIEW_ALL_RUNNING_EXAMS = 'view_all_running_exams';
  static const String VIEW_ALL_UPCOMING_EXAMS = 'view_all_upcoming_exams';
  static const String VIEW_ALL_COMPLETED_EXAMS = 'view_all_completed_exams';

  static const String JUST_NOW = 'just_now';
  static const String SECONDS_AGO = 'seconds_ago';
  static const String MINUTES_AGO = 'minutes_ago';
  static const String HOURS_AGO = 'hours_ago';

  static const String SEE_PUBLIC_CLASSROOMS = 'see_public_classrooms';

  // Exam Conducted
  static const String SELECT_EXAM = 'select_exam';
  static const String CREATE_NEW_EXAM = 'create_new_exam';
  static const String RANDOM_QUESTION_EXAM = 'random_question_exam';
  static const String MUST_JOIN_ON_START = 'must_join_on_start';
  static const String DELAY_ALLOWED = 'delay_allowed';
  static const String MUST_FINISH_WITHIN_TIME = 'must_finish_within_time';
  static const String ALLOW_RESUME_EXAM = 'allow_resume_exam';
  static const String ALLOW_TO_ATTEND_MULTIPLE_TIME =
      'allow_to_attend_multiple_time';
  static const String SCHEDULE_EXAM_FOR_LATER = 'schedule_exam_for_later';
  static const String EXAM_START_TIME = 'exam_start_time';
  static const String SELECT_START_TIME = 'select_start_time';
  static const String CAN_EXAM_EXPIRE = 'can_exam_expire';
  static const String EXAM_EXPIRE_TIME = 'exam_expire_time';
  static const String SELECT_EXPIRE_TIME = 'select_expire_time';
  static const String SHOW_SOLUTION_AND_ANSWER = 'show_solution_and_answer';
  static const String CAN_ASK_DOUBT = 'can_ask_doubt';
  static const String PLEASE_SELECT_DATE_TIME = 'please_select_date_time';
  static const String PLEASE_EXPIRE_TIME_AFTER_START_TIME =
      'please_expire_time_after_start_time';
  static const String JOIN = 'join';
  static const String VIEW_RESULT = 'view_result';
  static const String START_TIME = 'start_time';
  static const String EXPIRE_TIME = 'expire_time';
  static const String NO_EXPIRE_TIME = 'no_expire_time';
  static const String SEND_REQUEST = 'send_request';
  static const String NUMBER_OF_QUESTIONS = 'number_of_questions';
  static const String NUMBER_OF_QUESTIONS_HELPER_TEXT =
      'number_of_questions_helper_text';
  static const String DELETE_RUNNING_EXAM_NOTE = 'delete_running_exam_note';
  static const String DELETE_UPCOMING_EXAM_NOTE = 'delete_upcoming_exam_note';
  static const String DELETE_COMPLETED_EXAM_NOTE = 'delete_completed_exam_note';
  static const String REASON_OF_DELETION = 'reason_of_deletion';
  static const String ENTER_REASON = 'enter_reason';
  static const String PLEASE_SELECT_EXAM_TO_SCHEDULE =
      'please_select_exam_to_schedule';

  // Running Exam
  static const String START = 'start';
  static const String SUBMIT = 'submit';
  static const String PREVIOUS = 'previous';
  static const String NEXT = 'next';
  static const String CLEAR = 'clear';
  static const String CORRECT_ANSWER_IS = 'correct_answer_is';
  static const String YOU_SUBMITTED_CORRECT_ANSWER =
      'you_submitted_correct_answer';
  static const String YOU_SUBMITTED_WRONG_ANSWER = 'you_submitted_wrong_answer';
  static const String I_HAVE_DOUBT = 'i_have_doubt';
  static const String SHOW_SOLUTION = 'show_solution';
  static const String PLEASE_SELECT_ANSWER_AND_THEN_SUBMIT =
      'please_select_answer_and_then_submit';
  static const String PLEASE_ENTER_ANSWER_AND_THEN_SUBMIT =
      'please_enter_answer_and_then_submit';
  static const String RESULT = 'result';
  static const String STARTED_AT = 'started_at';
  static const String EXAM_COMPLETED_IN = 'exam_completed_in';
  static const String MINUS_MARKS = 'minus_marks';
  static const String MAXIMUM_MARKS = 'maximum_marks';
  static const String PERCENTAGE = 'percentage';
  static const String WITHOUT_MINUS_MARKS = 'without_minus_marks';
  static const String SHOW_ANSWERS = 'show_answers';
  static const String YOU_LATE = 'you_late';
  static const String EXAM_ENDED = 'exam_ended';
  static const String OUT_OF_TIME_EXAM_WLL_BE_SAVED =
      'out_of_time_exam_wll_be_saved';
  static const String YOU_ARE_LATE_CAN_NOT_JOIN_EXAM_NOW =
      'you_are_late_can_not_join_exam_now';
  static const String EXAM_EXPIRED = 'exam_expired';
  static const String THIS_EXAM_IS_EXPIRED = 'this_exam_is_expired';
  static const String ATTEND_AGAIN = 'attend_again';
  static const String WOULD_YOU_GIVE_EXAM_AGAIN_OLD_EXAM_DELETED =
      'would_you_give_exam_again_old_exam_deleted';
  static const String NO = 'no';
  static const String YES = 'yes';
  static const String YOU_CAN_NOT_GIVE_EXAM_AGAIN =
      'you_can_not_give_exam_again';
  static const String RESUME_EXAM = 'resume_exam';
  static const String YOU_CAN_NOT_RESUME_EXAM_BECAUSE_YOU_ARE_OUT_OF_TIME =
      'you_can_not_resume_exam_because_you_are_out_of_time';
  static const String YOU_CAN_NOT_RESUME_EXAM = 'you_can_not_resume_exam';
  static const String THIS_EXAM_IS_DELETED = 'this_exam_is_deleted';
  static const String EXAM_DELETED_NOTE = 'exam_deleted_note';
  static const String SWITCH_QUESTIONS = 'switch_questions';
  static const String DISCARD_RUNNING_EXAM = 'discard_running_exam';
  static const String SUBMIT_EXAM = 'submit_exam';
  static const String SUBMIT_EXAM_MESSAGE = 'submit_exam_message';

  // Chat
  static const String TYPE_HERE = 'type_here';
  static const String MESSAGED_DELETED = 'messaged_deleted';
  static const String COPY = 'copy';
  static const String MESSAGE_COPIED = 'message_copied';

  // Share
  static const String SHARE = 'share';
  static const String SHARE_TO_CLASSROOM = 'share_to_classroom';
  static const String SHARE_OUTSIDE = 'share_outside';

  // Drawer
  static const String CHANGE_LANGUAGE = 'change_language';
  static const String LOG_OUT = 'log_out';
  static const String LIGHT_MODE = 'light_mode';
  static const String DARK_MODE = 'dark_mode';
  static const String INVITE = 'invite';
  static const String RATE_US = 'rate_us';
  static const String NEED_HELP = 'need_help';
  static const String ABOUT = 'about';

  // Languages
  static const String ENGLISH_USA = 'english_usa';
  static const String ENGLISH_IN = 'english_in';
  static const String HINDI_IN = 'hindi_in';

  // Sharing Texts
  static const String CLASSROOM_DETAILS_SHARING_TEXT =
      'classroom_details_sharing_text';
  static const String NOTE_DETAILS_SHARING_TEXT = 'note_details_sharing_text';
  static const String EXAM_DETAILS_SHARING_TEXT = 'exam_details_sharing_text';

  // Buttons
  static const String CONTINUE = 'continue';
  static const String OKAY = 'okay';
  static const String PLUS_ADD = 'plus_add';
  static const String CANCEL = 'cancel';

  // Video
  static const String QUALITY = 'quality';
  static const String SPEED = 'speed';
  static const String FILE_NOT_ALLOWED = 'file_not_allowed';
  static const String COMPLETE_GUIDE_LINE = 'complete_guide_line';

  // Social media
  static const String TWITTER = 'twitter';
  static const String FACEBOOK = 'facebook';
  static const String INSTAGRAM = 'instagram';
  static const String YOUTUBE = 'youtube';
}

String getDifficulty(String key) {
  switch (key) {
    case E.EASY:
      return S.EASY;
    case E.NORMAL:
      return S.NORMAL;
    case E.HARD:
      return S.HARD;
  }
  return '';
}

String getPrivacySt(String key) {
  switch (key) {
    case E.PRIVATE:
      return S.PRIVATE;
    case E.PUBLIC:
      return S.PUBLIC;
  }
  return '';
}

IconData getPrivacy(String key) {
  if (key == E.PRIVATE) return Icons.lock;
  return Icons.public;
}

String getWhoCanJoin(String key) {
  switch (key) {
    case E.ANYONE:
      return S.ANYONE_CAN_JOIN;
    case E.REQUEST_BEFORE_JOIN:
      return S.ACCEPT_JOIN_REQUESTS;
  }
  return '';
}

String getWhoCanShare(String key) {
  switch (key) {
    case E.ADMIN_ONLY:
      return S.ADMIN_ONLY;
    case E.ALL:
      return S.ALL;
  }
  return '';
}

String getBooleanSt(bool value) {
  if (value) return S.YES;
  return S.NO;
}
