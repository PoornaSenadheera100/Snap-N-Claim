import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:snap_n_claim/keys/keys.dart';

class EmailService{
  static void sendEmail() async{

    final mailer = Mailer(
        Keys.sendGridAPIKey);
    final toAddress = Address('subasinghasanuthi@gmail.com');
    final fromAddress = Address('spshayurvedic@gmail.com');
    final content = Content('text/plain', 'Hello World!');
    final subject = 'Your Claim is Approved by HOD';
    final personalization = Personalization([toAddress]);

    final email = Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      print(result.toString());
    }).catchError((e) {
      print(e);
    });
  }
}