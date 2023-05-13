import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/src/widgets/placeholder.dart';

class Conditions extends StatefulWidget {
  const Conditions({super.key});

  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
             Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text('You must be at least 18 years old to use our app and participate in the pet adoption ',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            Text('You must be a resident of the India to adopt pets through our app.',              
            style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our app provides a platform for users to browse and search for available pets for adoption.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'By expressing your interest in adopting a pet, you agree to follow our adoption process, which may include completing an application, attending an adoption interview, and paying the adoption fee.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'The final decision regarding the pet adoption rests with the pet owner or adoption agency.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Users listing pets for adoption are responsible for providing accurate and up-to-date information about the pets.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'We do not guarantee the accuracy or completeness of the information provided by pet owners or adoption agencies.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'If you adopt a pet through our app, you are responsible for providing proper care, including food, shelter, and medical attention, to the adopted pet.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'You must comply with all local laws and regulations regarding pet ownership, licensing, and vaccinations.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'You are solely responsible for the interactions and arrangements made with pet owners or adoption agencies through our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Adoption fees or charges may apply when adopting a pet through our app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'The adoption fees are determined by the pet owner or adoption agency and will be clearly communicated before the adoption process begins.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our app serves as a platform for connecting pet owners or adoption agencies with potential adopters. We do not guarantee the availability, health, or behavior of any pet listed for adoption.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'We are not responsible for any actions, damages, or consequences resulting from the pet adoption process or interactions between users.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'You use our app at your own risk, and we recommend taking necessary precautions when interacting with other users.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'By using our app, you agree to the terms of our privacy policy, which outlines how we collect, store, and use your personal information. Please review our privacy policy for more information.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'All content, including trademarks, logos, images, and text, used within our app is the property of their respective owners.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'You may not use, modify, or distribute any content from our app without explicit permission from the respective owners.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'We reserve the right to terminate or suspend user accounts or access to our app if there is a violation of these terms and conditions or inappropriate behavior.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'We may also remove or modify any pet listing or content at our discretion.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'These terms and conditions are governed by the laws of the India.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Any disputes arising from the use of our app shall be subject to the exclusive jurisdiction of the courts',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
