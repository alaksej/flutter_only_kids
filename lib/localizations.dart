import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OnlyKidsLocalizations {
  OnlyKidsLocalizations(this.locale);

  final Locale locale;

  static OnlyKidsLocalizations of(BuildContext context) {
    return Localizations.of<OnlyKidsLocalizations>(context, OnlyKidsLocalizations);
  }

  _get(String key) {
    return _localizedValues[locale.languageCode][key];
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Only Kids',
      'appointments': 'Appointments',
      'gallery': 'Gallery',
      'contacts': 'Contacts',
      'upcoming': 'Upcoming',
      'past': 'Past',
      'upcomingListEmpty': 'You have no upcoming appointments',
      'pastListEmpty': 'You have no past appointments',
      'logInToManage': 'Please log in to manage your appointments',
      'logIn': 'Log In',
      'newAppointment': 'New Appointment',
      'editAppointment': 'Edit Appointment',
      'pastAppointment': 'Past Appointment',
      'delete': 'Delete',
      'timeslotsUnavailable': 'No time slots available for this date. \nPlease select a different date.',
      'save': 'Save',
      'book': 'Book',
      'comment': 'Comment',
      'writeComment': 'Write a comment...',
      'updateAppointment': 'Update Appointment',
      'areYouSureToUpdate': r'New appointment date: $date',
      'ok': 'OK',
      'createAppointment': 'Create Appointment',
      'areYouSureToAdd': r'Add appointment on: $date',
      'appointmentSaved': 'Appointment saved',
      'cancelAppointment': 'Cancel Appointment',
      'areYouSureToCancel': 'Are you sure you want to cancel this appointment?',
      'yes': 'Yes',
      'no': 'No',
      'removeAppointment': 'Remove Appointment',
      'areYouSureToRemove': 'Are you sure you want to remove this past appointment?',
      'appointmentRemoved': 'Appointment removed',
      'checkEmailForResetInfo': 'Check your email\n'
          'The information on how to reset your password has been sent',
      'onlyKidsGomel': 'Only Kids Gomel',
      'address': 'Ulitsa Rogachovskaya 2a, Homieĺ 246000',
      // TODO: use standard l10ns instead
      'monday': 'Monday',
      'tuesday': 'Tuesday',
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',

      'createNewAccount': 'Create new Only Kids account',
      'fullName': 'Full Name',
      'enterYourName': 'Enter your name',
      'yourEmailAddress': 'Your e-mail address',
      'password': 'Password',
      'enterPassword': 'Enter password',
      'passwordLengthValidation': r'Password should be at least $minPasswordLength characters',
      'create': 'Create',
      'forgotPassword': 'Forgot password?',
      'failedToCreateUser': 'Failed to create user',
      'useAccountViaEmail': 'Use the Only Kids account by entering your email address',
      'next': 'Next',
      'welcomeBack': 'Welcome back!\n'
          'Log in to your Only Kids account',
      'badUsernameOrPassword': 'Bad username or password',
      'continueWithGoogle': 'Continue with Google',
      'continueWithEmail': 'Continue with Email',
      'signInFailedCheckInternet': 'Could not sign in.\n'
          'Check your internet connection and try again',
      'ourLocation': 'Our location',
      'passwordReset': 'Password Reset',
      'errorResettingPassword': 'Error resetting password',
      'phoneNumber': 'Phone Number',
      'providePhone': 'Please provide your phone number',
      'whyProvidePhone': 'In case there is any issue with your appointment '
          'we may contact you using this phone number:',
      'phoneExample': 'e.g., +375 29 111 11 11',
      'close': 'Close',
      'failedToUpdatePhone': 'Failed to update phone number',
      'changesSaved': 'Changes saved',
      'profile': 'Profile',
      'signOut': 'Sign Out',
      'areYouSureToSignOut': 'Are you sure you want to log out?',
      'noPhoneNumber': 'No phone number',
    },
    'ru': {
      'title': 'Only Kids',
      'appointments': 'Записи',
      'gallery': 'Галерея',
      'contacts': 'Контакты',
      'upcoming': 'Предстоящие',
      'past': 'Прошедшие',
      'upcomingListEmpty': 'Предстоящие записи отсутствуют',
      'pastListEmpty': 'Прошедшие записи отсутствуют',
      'logInToManage': 'Войдите в систему чтобы управлять записями',
      'logIn': 'Войти',
      'newAppointment': 'Новая запись',
      'editAppointment': 'Изменить запись',
      'pastAppointment': 'Прошедшая запись',
      'delete': 'Удалить',
      'timeslotsUnavailable':
          'Свободное время для записи отсутствует в выбранный день. \n Пожалуйста, выберите другую дату.',
      'save': 'Сохранить',
      'book': 'Записаться',
      'comment': 'Комментарии',
      'writeComment': 'Оставьте комментарий...',
      'updateAppointment': 'Обновить запись',
      'areYouSureToUpdate': r'Перенести запись на $date?',
      'ok': 'OK',
      'createAppointment': 'Создать запись',
      'areYouSureToAdd': r'Добавить запись на $date?',
      'appointmentSaved': 'Запись сохранена',
      'cancelAppointment': 'Отменить запись',
      'areYouSureToCancel': 'Вы уверены что хотите отменить запись?',
      'yes': 'Да',
      'no': 'Нет',
      'removeAppointment': 'Удалить запись',
      'areYouSureToRemove': 'Вы уверены что хотите удалить прошедшую запись?',
      'appointmentRemoved': 'Запись удалена',
      'checkEmailForResetInfo': 'Проверьте свою электронную почту\n'
          'Инструкции по сбросу пароля были отправлены на указанный электронный адрес',
      'onlyKidsGomel': 'Only Kids Гомель',
      'address': 'ул. Рогачевская 2а, Гомель 246000',
      // TODO: use standard l10ns instead
      'monday': 'Понедельник',
      'tuesday': 'Вторник',
      'wednesday': 'Среда',
      'thursday': 'Четверг',
      'friday': 'Пятница',
      'saturday': 'Суббота',
      'sunday': 'Воскресенье',

      'createNewAccount': 'Создать учетную запись Only Kids',
      'fullName': 'Ваше полное имя',
      'enterYourName': 'Введите имя',
      'yourEmailAddress': 'Ваш электронный адрес',
      'password': 'Пароль',
      'enterPassword': 'Введите пароль',
      'passwordLengthValidation': r'Пароль должен быть минимум $minPasswordLength символов длиной',
      'create': 'Создать',
      'forgotPassword': 'Забыли пароль?',
      'failedToCreateUser': 'Ошибка при создании пользователя',
      'useAccountViaEmail': 'Войдите в учетную запись Only Kids используя свой электронный адрес',
      'next': 'Далее',
      'welcomeBack': 'Мы рады снова видеть Вас!\n'
          'Войдите в свою учетную запись Only Kids',
      'badUsernameOrPassword': 'Неверное имя пользователя или пароль',
      'continueWithGoogle': 'Продолжить с Google',
      'continueWithEmail': 'Продолжить с Email',
      'signInFailedCheckInternet': 'Ошибка авторизации.\n'
          'Проверьте подключение к интернету и попробуйте снова.',
      'ourLocation': 'Наше расположение',
      'passwordReset': 'Сброс пароля',
      'errorResettingPassword': 'Ошибка при сбросе пароля',
      'phoneNumber': 'Телефон',
      'providePhone': 'Пожалуйста, введите свой номер телефона',
      'whyProvidePhone':
          'Мы сможем связаться с Вами по этому номеру в случае если возникнут каки-либо сложности с вашей записью:',
      'phoneExample': 'например: +375 29 111 11 11',
      'close': 'Закрыть',
      'failedToUpdatePhone': 'Ошибка при сохранении номера телефона',
      'changesSaved': 'Изменения сохранены',
      'profile': 'Профиль',
      'signOut': 'Выйти',
      'areYouSureToSignOut': 'Вы уверены что хотите выйти из системы?',
      'noPhoneNumber': 'Телефон отсутствует',
    },
  };

  String get title {
    return _get('title');
  }

  String get appointments {
    return _get('appointments');
  }

  String get gallery {
    return _get('gallery');
  }

  String get contacts {
    return _get('contacts');
  }

  String get upcoming {
    return _get('upcoming');
  }

  String get past {
    return _get('past');
  }

  String get upcomingListEmpty {
    return _get('upcomingListEmpty');
  }

  String get pastListEmpty {
    return _get('pastListEmpty');
  }

  String get logInToManage {
    return _get('logInToManage');
  }

  String get logIn {
    return _get('logIn');
  }

  String get newAppointment {
    return _get('newAppointment');
  }

  String get editAppointment {
    return _get('editAppointment');
  }

  String get pastAppointment {
    return _get('pastAppointment');
  }

  String get delete {
    return _get('delete');
  }

  String get timeslotsUnavailable {
    return _get('timeslotsUnavailable');
  }

  String get save {
    return _get('save');
  }

  String get book {
    return _get('book');
  }

  String get comment {
    return _get('comment');
  }

  String get writeComment {
    return _get('writeComment');
  }

  String get updateAppointment {
    return _get('updateAppointment');
  }

  String get areYouSureToUpdate {
    return _get('areYouSureToUpdate');
  }

  String get ok {
    return _get('ok');
  }

  String get createAppointment {
    return _get('createAppointment');
  }

  String get areYouSureToAdd {
    return _get('areYouSureToAdd');
  }

  String get appointmentSaved {
    return _get('appointmentSaved');
  }

  String get cancelAppointment {
    return _get('cancelAppointment');
  }

  String get areYouSureToCancel {
    return _get('areYouSureToCancel');
  }

  String get yes {
    return _get('yes');
  }

  String get no {
    return _get('no');
  }

  String get removeAppointment {
    return _get('removeAppointment');
  }

  String get areYouSureToRemove {
    return _get('areYouSureToRemove');
  }

  String get appointmentRemoved {
    return _get('appointmentRemoved');
  }

  String get checkEmailForResetInfo {
    return _get('checkEmailForResetInfo');
  }

  String get onlyKidsGomel {
    return _get('onlyKidsGomel');
  }

  String get address {
    return _get('address');
  }

  String get monday {
    return _get('monday');
  }

  String get tuesday {
    return _get('tuesday');
  }

  String get wednesday {
    return _get('wednesday');
  }

  String get thursday {
    return _get('thursday');
  }

  String get friday {
    return _get('friday');
  }

  String get saturday {
    return _get('saturday');
  }

  String get sunday {
    return _get('sunday');
  }

  String get createNewAccount {
    return _get('createNewAccount');
  }

  String get fullName {
    return _get('fullName');
  }

  String get enterYourName {
    return _get('enterYourName');
  }

  String get yourEmailAddress {
    return _get('yourEmailAddress');
  }

  String get password {
    return _get('password');
  }

  String get enterPassword {
    return _get('enterPassword');
  }

  String get passwordLengthValidation {
    return _get('passwordLengthValidation');
  }

  String get create {
    return _get('create');
  }

  String get forgotPassword {
    return _get('forgotPassword');
  }

  String get failedToCreateUser {
    return _get('failedToCreateUser');
  }

  String get useAccountViaEmail {
    return _get('useAccountViaEmail');
  }

  String get next {
    return _get('next');
  }

  String get welcomeBack {
    return _get('welcomeBack');
  }

  String get badUsernameOrPassword {
    return _get('badUsernameOrPassword');
  }

  String get continueWithGoogle {
    return _get('continueWithGoogle');
  }

  String get continueWithEmail {
    return _get('continueWithEmail');
  }

  String get signInFailedCheckInternet {
    return _get('signInFailedCheckInternet');
  }

  String get ourLocation {
    return _get('ourLocation');
  }

  String get passwordReset {
    return _get('passwordReset');
  }

  String get errorResettingPassword {
    return _get('errorResettingPassword');
  }

  String get phoneNumber {
    return _get('phoneNumber');
  }

  String get providePhone {
    return _get('providePhone');
  }

  String get whyProvidePhone {
    return _get('whyProvidePhone');
  }

  String get phoneExample {
    return _get('phoneExample');
  }

  String get close {
    return _get('close');
  }

  String get failedToUpdatePhone {
    return _get('failedToUpdatePhone');
  }

  String get changesSaved {
    return _get('changesSaved');
  }

  String get profile {
    return _get('profile');
  }

  String get signOut {
    return _get('signOut');
  }

  String get areYouSureToSignOut {
    return _get('areYouSureToSignOut');
  }

  String get noPhoneNumber {
    return _get('noPhoneNumber');
  }
}

class OnlyKidsLocalizationsDelegate extends LocalizationsDelegate<OnlyKidsLocalizations> {
  const OnlyKidsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<OnlyKidsLocalizations> load(Locale locale) {
    return SynchronousFuture<OnlyKidsLocalizations>(OnlyKidsLocalizations(locale));
  }

  @override
  bool shouldReload(OnlyKidsLocalizationsDelegate old) => false;
}
