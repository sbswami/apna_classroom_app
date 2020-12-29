import 'package:apna_classroom_app/util/constants.dart';
import 'package:flutter/material.dart';

class S {
  // Basic
  static const String APP_NAME = 'app_name';
  static const String APP_N = 'app_n';

  // Design Info
  static const String SOMETHING_WENT_WRONG = 'something_went_wrong';

  // Login
  static const String LOGIN = 'login';
  static const String PHONE_NUMBER_LABEL = 'phone_number_label';
  static const String PLEASE_ENTER_VALID_PHONE_NUMBER =
      'please_enter_valid_phone_number';
  static const String LOGIN_FAILED = 'login_failed';
  static const String WRONG_PHONE_NUMBER_LIMIT_EXCEED =
      'wrong_phone_number_limit_exceed';
  static const String CODE_SENT = 'code_sent';

  // Profile
  static const String PROFILE = 'profile';
  static const String ENTER_YOUR_NAME = 'enter_your_name';
  static const String USERNAME = 'username';
  static const String USERNAME_INVALID = 'username_invalid';
  static const String USERNAME_ALREADY_EXISTS = 'username_already_exists';
  static const String NAME_INVALID = 'name_invalid';
  static const String RESEND_OTP = 'resend_otp';
  static const String HIDE_MY_PHONE_NUMBER = 'hide_my_phone_number';

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

  // Quiz + Notes
  static const String OPEN_EDITOR = 'open_editor';
  static const String UPLOAD_FILE = 'upload_file';
  static const String ACCEPTED_FORMATS = 'accepted_formats';
  static const String EDITOR = 'editor';

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

  // Buttons
  static const String CONTINUE = 'continue';
  static const String OKAY = 'okay';
  static const String PLUS_ADD = 'plus_add';
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
