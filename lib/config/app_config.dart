class AppConfig {

  /// To test the app
  /// Please use this base url : https://spn11.freeschoolsoftware.in/infixedu_v8

 static String domainName = 'https://app.edustutor.com'; //** Replace with your domain name
 //static String domainName = 'https://school.quickmartshop.com';
 //http://edustutorapp.test
  static String appName = "EDUS Tutor";

  static String appLogo = 'assets/config/app_logo.png';
  
  static String appLogoBlue = 'assets/config/app_logo1.png';

  static String splashScreenBackground = 'assets/config/splash_bg.png';

  static String splashTopLine = 'assets/config/splash_top_line.png';

  static String loginBackground = 'assets/config/login_bg.png';

  static String appToolbarBackground = 'assets/config/app_toolbar_bg.png';

  static bool isDemo = false;

}

///
///PAYPAL
///
const String paypalDomain = "https://api.sandbox.paypal.com"; // "https://api.paypal.com"; // for production mode
const String paypalCurrency = 'USD';
const String paypalClientId =
    'AQgAWV4PlM9g81xZ51TLtVi68KjB89s4mpcchFschs7OvTM-3p4zsQTDqHOkv5Sw44k9goHlE-VAC7zj';
const String paypalClientSecret =
    'ELLoQfnZ4kRbDkul81U_RNRsgHgFPDumlUloCcX6nO6ziXRXKob8gVYaTn6CGCeNVJtBqsfv7VtbsuR2';

///
/// Paystack
///
const String payStackPublicKey =
    "pk_test_cb290d59b9ec539d7bc3617d1fee3d8a9cdb78b3";

///
/// Stripe
///
const String stripeServerURL =
    'https://us-central1-amazcart-341610.cloudfunctions.net/expressApp';
const String stripeCurrency = "usd";
const String stripeMerchantID = "merchant.thegreatestmarkeplace";
const String stripePublishableKey =
    "pk_test_51JAWNlKS0igSTFP16dhgcM1fBayh6DStrpu5OA7jjAzYiFX3Bht0X8ARULBpIAVkgmws7PWEliNi4Q35Iyk8ThQL00aoNnF3OE";
const String appPackageName = "com.infix.lms";

///
/// XENDIT
///
const String xenditPublicKey =
    "xnd_public_development_UIBiS69fidQVPPVhTwqQ199Zt0RfmWHwenXCnv9Oefzu9MYJWnE8CQTw7TqRpzG";
const String xenditSecretKey =
    "xnd_development_Qdl0DRhGng5Aad7k5ZZ69Ba74zWZa9soTpNxpd08PIexvZ1u4AbnKtCiNYpN2J7";

const String khaltiPublicKey = "test_public_key_ed62083738dc438cb4e76df410290040";

const String razorPayApiKey = "rzp_test_7fODedNb1rxd38";


