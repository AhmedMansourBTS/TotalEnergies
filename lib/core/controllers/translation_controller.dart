import 'package:get/get.dart';

class TranslationController extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // Login Page
          'login_page.title': 'Welcome',
          'login_page.phone_no': 'Phone Number',
          'login_page.phone_no_hint': 'Enter your phone number',
          'login_page.password': 'Password',
          'login_page.password_hint': 'Enter your password',
          'login_page.all_verification': 'Invalid Credentials',
          'login_page.empty_verification': 'This Field required',
          'login_page.pass_verification': 'Password is required',
          'login_page.pass_verification1':
              'Password must be at least 8 characters',
          // Forget Page
          'forget_page.title': 'Forget Password',
          'forget_page.phone_no': 'Phone Number',
          'forget_page.empty_verification': 'This Field required',
          'forget_page.phone_no_hint': 'Enter your phone number',
          'forget_page.otp_label': 'Enter OTP',
          'forget_page.otp_hint': 'Enter OTP number',
          // Register Page labels
          'register_page.username_label': 'Full Name',
          'register_page.phone_no_label': 'Phone Number',
          'register_page.email_label': 'Email',
          'register_page.birth_date_label': 'Birth Date',
          'register_page.car_brand_label': 'Car Brand',
          'register_page.car_brand_year_label': 'Car Brand Year',
          'register_page.password_label': 'Password',
          'register_page.confrim_password_label': 'Confrim Password',
          'register_page.gender_label': 'Gender',
          'register_page.gov_label': 'Select Governorate',
          // Register Page hints
          'register_page.username_hint': 'Enter your full name',
          'register_page.phone_no_hint': 'Enter your phone number',
          'register_page.email_hint': 'Enter your email',
          'register_page.birth_date_hint': 'Select your birth date',
          'register_page.car_brand_hint': 'Enter your car brand',
          'register_page.car_brand_year_hint':
              'Enter your car manufacture year',
          'register_page.password_hint': 'Enter your password',
          'register_page.confrim_password_hint': 'Re-enter your password',
          'register_page.gender_hint1': 'Male',
          'register_page.gender_hint2': 'Female',
          'register_page.gov_hint': 'Choose your governorate',
          // terms & conditions
          'register_page.term&cond':
              'I agree to send and store my data with Total Energies Marketing Egypt to receive messages and offers by e-mail, SMS, and commercial phone calls for promotions that fit my profile',
          // Register Page Verifications
          'register_page.empty_verification': 'This Field required',
          'register_page.unmatched_conf_pass':
              'Password Confirmaction doesn\'t match',
          'register_page.terms_verification':
              'You must agree to the terms to register.',
          'register_page.success_verification': 'Registration successful',
          'register_page.fail_verification': 'Failed',
          'register_page.email_verification': 'Enter a valid email address',
          'register_page.name_verification':
              'Enter a valid name (only letters, min 3 characters)',
          'register_page.pass_verification':
              'Password must be at least 8 characters',
          'register_page.date_verification': 'Invalid date format.',
          'register_page.age_verification':
              'You must be at least 16 years old.',
          'register_page.year_verification': 'Enter a valid 4-digit year',
          'register_page.year_verification1':
              'Year must be between 1990 and 2030',
          // Profile page
          'profile_page.acc_inf': 'Account Information',
          'profile_page.name': 'Username',
          'profile_page.phone_number': 'Phone Number',
          'profile_page.email': 'Email',
          'profile_page.gender': 'Gender',
          // buttons
          'btn.edit_profile': 'Edit Profile',
          'btn.logout': 'Logout',
          'btn.save_change': 'Save Changes',
          'btn.reg_btn': 'Register Now',
          'btn.login_btn': 'Login',
          'btn.login_page_reg_btn': 'Register Now',
          'btn.forget_btn': 'Forget Password ?',
          'btn.forget_page_forget_btn': 'Send OTP',
          'btn.submit_otp_btn': 'Verify OTP',
          'btn.promotions_det_pag_redeem': 'Redeem Promotion',
          'btn.profile_page_history_btn': 'Previous Promotions',
          // Profile page
          'edit_profile.name': 'Username',
          'edit_profile.phone_number': 'Phone Number',
          'edit_profile.email': 'Email',
          'profile_page.acc_info': 'Account Information',
          'profile_page.acc_history': 'Your History',
          'profile_page.change_lang': 'Change language',
          // App Bar
          'app_bar.hi_txt': 'Hello',
          // Promotions page
          'promotion_page.flt_all': 'All',
          'promotion_page.flt_curr': 'Ongoing',
          'promotion_page.flt_old': 'Old',
          // Bottom bar
          'bottom_bar.promotions': 'Promotions',
          'bottom_bar.stations': 'Stations',
          'bottom_bar.profile': 'Profile',
          // Stations Page
          'stations_page.search': 'Search Stations',
          'stations_page.station_address': 'No address available',
          'stations_page.failed_load': 'Failed to load stations',
          'stations_page.no_stations': 'No stations available',
          // promotions Details
          'promotion_det_page.select_station': 'Selected Station:',
          'promotion_det_page.activity': 'Remaining: ',
          'promotion_det_page.max_user': 'Maximum users : ',
          // current card
          'curr_card.activity': 'The remaining times : ',
          'curr_card.start_date': 'Start date : ',
          'curr_card.end_date': 'End date : ',
          // all card
          'all_card.apply': 'Apply >> ',
          'all_card.start_date': 'Start date : ',
          'all_card.end_date': 'End date : ',
          'all_card.apply_btn': 'Apply',
        },
        'ar_AE': {
          // Login Page
          'login_page.title': 'مرحبا',
          'login_page.phone_no': 'رقم الهاتف',
          'login_page.phone_no_hint': 'ادخل رقم الهاتف',
          'login_page.password': 'كلمة المرور',
          'login_page.password_hint': 'ادخل كلمة المرور',
          'login_page.all_verification': 'بيانات اعتماد غير صالحة',
          'login_page.empty_verification': 'هذا الحقل مطلوب',
          'login_page.pass_verification': 'كلمة المرور مطلوبة',
          'login_page.pass_verification1':
              'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
          // Forget Page
          'forget_page.title': 'نسيت كلمة المرور',
          'forget_page.phone_no': 'رقم الهاتف',
          'forget_page.empty_verification': 'هذا الحقل مطلوب',
          'forget_page.phone_no_hint': 'ادخل رقم الهاتف',
          'forget_page.otp_label': 'أدخل  OTP',
          'forget_page.otp_hint': 'أدخل OTP رقم',
          // Register Page
          // labels
          'register_page.username_label': 'الاسم كامل',
          'register_page.phone_no_label': 'رقم الهاتف',
          'register_page.email_label': 'الايميل',
          'register_page.birth_date_label': 'تاريخ الميلاد',
          'register_page.car_brand_label': 'نوع السيارة',
          'register_page.car_brand_year_label': 'سنة صنع السيارة',
          'register_page.password_label': 'كلمة المرور',
          'register_page.confrim_password_label': 'تاكيد كلمة المرور',
          'register_page.gender_label': 'حدد الجنس',
          'register_page.gov_label': 'اختار محافظة',
          // hints
          'register_page.username_hint': 'ادخل الاسم كامل',
          'register_page.phone_no_hint': 'ادخل رقم الهاتف',
          'register_page.email_hint': 'ادخل البريد الاكتروني',
          'register_page.birth_date_hint': 'اختار تاريخ ميلادك',
          'register_page.car_brand_hint': 'ادخل نوع السيارة',
          'register_page.car_brand_year_hint': 'ادخل سنة صنع السيارة',
          'register_page.password_hint': 'ادخل كلمة المرور',
          'register_page.confrim_password_hint': 'اعد ادخال كلمة المرور',
          'register_page.gender_hint1': 'ذكر',
          'register_page.gender_hint2': 'انثي',
          'register_page.gov_hint': 'اختار محافظة',
          // terms & conditions
          'register_page.term&cond':
              'انا أوافق على إرسال  بياناتي وتخزينها عند شركة توتال إنرجيز للتسويق إيجيبت لتلقي رسائل وعروض عن طريق البريد الإلكتروني و الرسائل القصيرة والاتصالات التجارية التي تناسب ملف التعريف الخاص بي',
          // verifications
          'register_page.empty_verification': 'هذا الحقل مطلوب',
          'register_page.unmatched_conf_pass': 'كلمة المرور غير متطابقة',

          'register_page.terms_verification':
              'يجب عليك الموافقة على شروط التسجيل.',
          'register_page.success_verification': 'تم التسجيل بنجاح',
          'register_page.fail_verification': 'فشل',
          'register_page.email_verification': 'أدخل عنوان بريد إلكتروني صالحًا',
          'register_page.name_verification':
              'أدخل اسمًا صالحًا (أحرف فقط، 3 أحرف على الأقل)',
          'register_page.pass_verification':
              'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل',
          'register_page.date_verification': 'تنسيق التاريخ غير صالح.',
          'register_page.age_verification':
              'يجب أن يكون عمرك 16 عامًا على الأقل.',
          'register_page.year_verification': 'أدخل سنة صالحة مكونة من 4 أرقام',
          'register_page.year_verification1':
              'يجب أن يكون العام بين 1990 و 2030',
          // Profile page
          'profile_page.acc_inf': 'معلومات الحساب',
          'profile_page.name': 'اسم المستخدم',
          'profile_page.phone_number': 'رقم التليفون',
          'profile_page.email': 'بريد إلكتروني',
          'profile_page.gender': 'جنس',
          // buttons
          'btn.edit_profile': 'تحرير الملف الشخصي',
          'btn.logout': 'تسجيل الخروج',
          'btn.save_change': 'حفظ التغييرات',
          'btn.reg_btn': 'تسجيل الان',
          'btn.login_btn': 'دخول',
          'btn.login_page_reg_btn': 'تسجيل دخول',
          'btn.forget_btn': 'نسيت كلمة المرور ؟',
          'btn.forget_page_forget_btn': 'ارسال OTP',
          'btn.submit_otp_btn': 'تحقق من رمز OTP',
          'btn.promotions_det_pag_redeem': 'تفعيل العرض',
          'btn.profile_page_history_btn': 'العروض السابقة',
          // Profile page
          'edit_profile.name': 'اسم المستخدم',
          'edit_profile.phone_number': 'رقم التليفون',
          'edit_profile.email': 'بريد إلكتروني',
          'profile_page.acc_info': 'بيانات الحساب',
          'profile_page.acc_history': 'العروض المنهية',
          'profile_page.change_lang': 'غير اللغة',
          // App Bar
          'app_bar.hi_txt': 'أهلاً',
          // Promotions page
          'promotion_page.flt_all': 'الجميع',
          'promotion_page.flt_curr': 'الحالية',
          'promotion_page.flt_old': 'القديم',
          // Bottom bar
          'bottom_bar.promotions': 'عروض',
          'bottom_bar.stations': 'محطات',
          'bottom_bar.profile': 'حساب',
          // Stations Page
          'stations_page.search': 'البحث في المحطات',
          'stations_page.station_address': 'لا يوجد عنوان',
          'stations_page.failed_load': 'فشل في تحميل المحطات',
          'stations_page.no_stations': 'لا توجد محطات',
          // promotions Details
          'promotion_det_page.select_station': 'اختر محطة: ',
          'promotion_det_page.activity': 'باقي : ',
          'promotion_det_page.max_user': 'اقصي عدد للمستخدمين : ',
          // current card
          'curr_card.activity': 'المرات المتبقية : ',
          'curr_card.start_date': 'تاريخ البداية :',
          'curr_card.end_date': 'تاريخ الانتهاء : ',
          // all card
          'all_card.apply': 'سجل الان >>',
          'all_card.start_date': 'تاريخ البداية :',
          'all_card.end_date': 'تاريخ الانتهاء : ',
          'all_card.apply_btn': 'سجل',
        },
      };
}
