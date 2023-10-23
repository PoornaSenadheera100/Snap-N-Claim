import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:snap_n_claim/keys/keys.dart';

class EmailService {
  static void mailPayment(String claimNo, double amount) async {
    final mailer = Mailer(Keys.sendGridAPIKey);
    final toAddress = Address('subasinghasanuthi@gmail.com');
    final toAddress1 = Address('poornasenadheeraonline@gmail.com');
    final fromAddress = Address('spshayurvedic@gmail.com');
    final content = Content('text/plain',
        'Your reimbursement claim with claim number $claimNo has been successfully processed. The approved amount of Rs.${amount.toStringAsFixed(2)} has been credited to your account.');
    final subject = 'Payment Confirmation for Claim $claimNo';
    final personalization = Personalization([toAddress, toAddress1]);

    final email =
        Email([personalization], fromAddress, subject, content: [content]);
    mailer.send(email).then((result) {
      print(result.toString());
    }).catchError((e) {
      print(e);
    });
  }
}
