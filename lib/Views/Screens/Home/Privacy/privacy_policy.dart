import 'package:flutter/material.dart';

import '../../../../Utils/constants.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.mainColor,
        title: const Center(
            child: Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 10,
              // ),
              Text(
                "Introduction:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  "At Molle, we are committed to protecting your privacy and ensuring that your personal information is handled securely. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app, Molle. By accessing or using the app, you agree to the collection and use of your information in accordance with this policy."),
              SizedBox(
                height: 7,
              ),
              Text(
                "Information We Collect:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'When you use Molle, we may collect the following types of information'),
              SizedBox(
                height: 7,
              ),
              Text(
                  'A. Personal Information: We may collect personal information that you voluntarily provide to us, such as:\n1- Name \n2- Email \n3- address \n4- Contactinformation \n5- Dateofbirth \n6- Paymentinformation(processed by third-party payment providers)\n7- Locationdata'),
              SizedBox(
                height: 7,
              ),
              Text(
                  'B. Non-Personal Information: We may also collect non-personal information automatically when you use the app, such as:\n1- Device information (e.g.Browser type)\n2- App usage data \n3- Cookies and similar tracking technologies'),
              SizedBox(
                height: 7,
              ),
              Text(
                "How We Use Your Information:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'We use the information we collect for the following purposes:\n1- To Provide and Maintain the Service: To allow you to create and manage an account, host or attend events, and interact with other users.\n2- To Process Payments: To securely process payments for events and transfer funds to hosts after the event. \n3- To Communicate with You: To send you notifications about your account, events, or app updates \n4- To Improve the App: To analyse usage patterns and improve the functionality and performance of the app \n5- For Marketing and Promotions: With your consent, we may send you promotional materials, offers, or other information related to Molle.'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Sharing Your Information:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'We will not share your personal information with third parties except in the following circumstances:\n1- With Service Providers: We may share your information with third-party vendors who help us operate Molle (e.g., payment processors, hosting providers).\n2- For Legal Compliance: We may disclose your information if required by law or in response to valid legal requests by public authorities \n3- To Protect Rights and Safety: We may disclose your information when necessary to protect Molle’s rights, your safety, or the safety of others'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Data Security:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'We take the security of your personal information seriously and implement reasonable technical, administrative, and physical safeguards to protect it. However, no method of data transmission or storage is completely secure, and we cannot guarantee absolute security'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Data Retention:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'We will retain your personal information only for as long as necessary to fulfil the purposes outlined in this policy, unless a longer retention period is required or permitted by law. Once your data is no longer needed, we will securely dispose.'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Your Rights:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'Depending on your location, you may have certain rights regarding your personal data, including:Access and Correction: You may access and correct the personal information we hold about you.Deletion: You may request that we delete your personal information, subject to certain exceptions (e.g., legal obligations).Data Portability: You may request a copy of your personal information in a structured, machine-readable format.Opt-Out: You may opt-out of receiving marketing communications from us at any time by following the unsubscribe instructions in those communications.To exercise your rights, please contact us at [molle.app@gmail.com]'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Location Data:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'Molle uses location data to show relevant events near you. By enabling location services in the app, you consent to the collection and use of your location data. You can manage your location preferences in your device settings'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Payments:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'Molle uses third-party payment processors to handle transactions. These payment processors comply with industry standards for secure payment processing. Molle does not store your payment information directly but relies on the security measures of the payment provider. By hosting events, you agree that payment will be transferred to you after the event takes place'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Third-Party Links:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'Molle may contain links to third-party websites, services, or offers. We are not responsible for the privacy practices or the content of these third parties. We encourage you to review the privacy policies of those third parties before providing any personal information'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Changes to This Privacy Policy:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'We may update this Privacy Policy from time to time to reflect changes in our practices or for legal, operational, or regulatory reasons. We will notify you of any significant changes by updating the "Effective Date" at the top of this policy. Continued use of the app after the update constitutes your acceptance of the updated policy'),
              SizedBox(
                height: 7,
              ),
              Text(
                "Contact Us:",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                  'If you have any questions or concerns about this Privacy Policy or your data, please contact us at:\nEmail: [molle.app@gmail.com]\nContact No: [9328212269]'),
            ],
          ),
        ),
      ),
    );
  }
}
