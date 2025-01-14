import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

double getWidth(context) => MediaQuery.of(context).size.width;
double getHeight(context) => MediaQuery.of(context).size.height;
double setSp(num value) => ScreenUtil().setSp(value);
double setWidth(num value) => ScreenUtil().setWidth(value);
double setHeight(num value) => ScreenUtil().setHeight(value);

final GetIt getIt = GetIt.instance;

bool isLowercase = false,
    isUppercase = false,
    isSymbol = false,
    isNumber = false,
    isGreaterThan8 = false;

String naira = "₦";

BuildContext? globalContext;

int currentTheme = 1;

class AppRegex {
  static RegExp onlyNumbers = RegExp(r'\d+');
  static RegExp onlyUppercase = RegExp(r'[A-Z]');
  static RegExp onlyLowercase = RegExp(r'[a-z]');
  static RegExp onlySpecialCharacter = RegExp(r'[^\w\s]');
}

const privacyPolicy = """
<p class="sample" style="color: red; text-align: center;"><span style=" color: rgb(0, 0, 0); font-size: 32px; font-weight:600">Privacy Policy</span></p>
<p style="line-height: 1.5;text-align: center;"><span style="color: rgb(65, 168, 95); font-family: Georgia, serif; font-size: 18px;">Updated as of 01/20/2024</span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">SpaceVilla Africa is committed to protecting the privacy of our users. This Privacy Policy outlines the types of personal information we collect, how we use it, and the measures we take to ensure its security.</span></p>
<p><br></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-family: Georgia, serif;"><strong><span style="font-size: 24px;">What information do we collect?</span></strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Personal Information:</span></p>
<ul>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Full name</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Contact information (email address, phone number)</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Address</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Government-issued identification details</span></li>
</ul>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Property-related Information:</span></p>
<ul>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Property preferences</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Transaction history</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Financial information for transactions</span></li>
</ul>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Usage Data:</span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Log files, IP addresses, browser type, pages visited, and other usage data when interacting with our website or mobile application.</span></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><strong><span style="font-size: 24px;">How do we use your information?</span></strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Service Provision:</span></p>
<ul>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">To provide personalized real estate services based on your preferences.</span></li>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Facilitate property transactions and agreements.</span></li>
</ul>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Communication:</span></p>
<ul>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Send updates, newsletters, and promotional material related to real estate services.</span></li>
</ul>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Legal Compliance:</span></p>
<ul>
    <li style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Comply with legal requirements and regulations in Nigeria.</span></li>
</ul>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-family: Georgia, serif;"><strong><span style="font-size: 24px;">Data Security</span></strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">SpaceVilla Africa employs industry-standard security measures to protect your personal information. This includes encryption, access controls, and regular security audits.</span></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-size: 24px; font-family: Georgia, serif;"><strong>Third-Party Disclosure</strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as required by law or in connection with the sale, merger, or acquisition of our company.</span></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><br></p>
<p><span style="font-size: 24px; font-family: Georgia, serif;"><strong>Cookies and Tracking Technologies</strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">We use cookies and similar technologies to enhance user experience, analyze website traffic, and personalize content. By using our services, you consent to the use of these technologies.</span></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-size: 24px; font-family: Georgia, serif;"><strong>Your Rights</strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">You have the right to access, correct, or delete your personal information. To exercise these rights or inquire about our privacy practices, contact us at [<a data-fr-linked="true" href="mailto:contact@spacevillaafrica.com">contact@spacevillaafrica.com</a>].</span></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-size: 24px; font-family: Georgia, serif;"><strong>Changes to This Policy</strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">SpaceVilla Africa reserves the right to update this Privacy Policy at any time. We will notify users of any material changes via email or through our website.</span></p>
<p><br></p>
<p><span style="font-family: Georgia, serif;"><br></span></p>
<p><span style="font-size: 24px; font-family: Georgia, serif;"><strong>Contact Information</strong></span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">If you have any questions or concerns regarding this Privacy Policy, please contact us at:</span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">Abuja, Nigeria</span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">spacevillaafrica.org</span></p>
<p style="line-height: 1.5;"><span style="font-family: Georgia, serif; font-size: 18px;">+234-9726289100</span></p>
""";

const legal = """ 

    <p class="sample" style="color: red; text-align: center;"><span style=" color: rgb(0, 0, 0); font-size: 32px; font-weight:600;">Legal</span></p>
    <p class="sample" style="color: red; text-align: center;"><span style="background-color: rgb(255, 255, 255); color: rgb(3, 152, 85); font-size: 13px;font-weight:600;">Updated as of 01/20/2024</span></p>
    <p class="sample" style="color: red; line-break: anywhere; fontWeight: 400;line-height:1.5;"><span style="background-color: rgb(255, 255, 255); color: rgb(102, 112, 133); font-size: 18px;">This Agreement ("Agreement") is entered  on this [Date] and between SpaceVilla Africa, a real company located at [Address] ("Company"),and the undersigned party ("Client" or "Agent").</span></p>
    <p><br></p>
    
    <p><strong><span style="font-size: 20px;font-weight:600;font-weight: 600;color:rgb(57,57,57);">1. Fraud Prevention:</span></strong></p>
    
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">1.1 Client Verification:</span></p>
    
    <ul>
        <li style="color: rgb(102, 112, 133);font-size:18px;font-weight:400;">The Client acknowledges Africa may employ verification processes to confirm the identity and legitimacy of clients.false  or engaging in fraudulent activities may in legal action.</li>
    </ul>
    
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">1.2 Transaction Transparency:</span></p>
   
    <ul>
        <li style="color: rgb(102, 112, 133); font-size: 18px;font-weight:400;">Both parties agree to maintain transparency in  real estate transactions facilitated through SpaceVilla Africa. Any to or misrepresent information related to property transactions will be considered a breach of Agreement.</li>
    </ul>
   
    <p><span style="font-size: 20px; color: rgb(57, 57, 57);font-weight: 600;">2. Real Estate Rights Protection:</span></p>
  
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">2.1 Intellectual Property:</span></p>
   
    <ul>
        <li style="color: rgb(102, 112, 133);font-size:18px;font-weight:400;"><span style="font-size: 18px;">Africa retains all  property rights associated its website, application, branding, proprietary real estate data. Unauthorized use, reproduction, or distribution  prohibited.</span></li>
    </ul>
  
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">2.2 Confidentiality:</span></p>
    
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">Both the Client and the Agent agree to keep confidential all proprietary and sensitive information obtained the of their engagement with SpaceVilla Africa, including but not to client details, transaction data, and business strategies.</li>
    </ul>
   
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">2.3 Exclusive Right to Represent:</span></p>
   
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">The Client acknowledges that SpaceVilla Africa has an exclusive to represent them in real estate facilitated through the platform. Attempts to engage other outside of the SpaceVilla Africa platform may result in termination services.</li>
    </ul>
   
    <p><span style="font-size: 20px; color: rgb(57, 57, 57);font-weight: 600;">3. Legal Consequences:</span></p>
  
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">3.1 Breach of Agreement:</span></p>
    
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">Any breach of this Agreement, including fraudulent activities violation of real estate rights, may result in legal action, termination of services, and other remedies available under Nigerian law.</li>
    </ul>
    
    <p><span style="font-size: 20px; color: rgb(57, 57, 57);font-weight: 600;">4. Governing Law and Dispute Resolution:</span></p>

    <p><span style="color: rgb(57, 57, 57); font-size: 18px;font-weight: 400;">4.1 Governing Law:</span></p>
   
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;"> Agreement shall be governed by construed in accordance with the of Nigeria.</li>
    </ul>
   
    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight: 400;">4.2 Dispute Resolution:</span></p>
    
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">Any arising out of or in connection with this Agreement shall resolved through in accordance with the rules of [Arbitration Institution] in Nigeria.</li>
    </ul>
   
    <p><span style="text-align: start; color: rgb(57, 57, 57); font-size: 20px;font-weight:600;">5. Miscellaneous:</span></p>

    <p><span style="font-size: 18px; color: rgb(57, 57, 57);font-weight:400;">5.1 Amendments:</span></p>
    
    <ul>
        <li style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">This Agreement may only be in writing and signed  both parties.</li>
    </ul>
    
    <p><span style="font-size: 18px; color: rgb(102, 112, 133);font-weight:400;">IN WITNESS WHEREOF, the hereto have executed this Agreement as of the date first written.</span></p>


""";
