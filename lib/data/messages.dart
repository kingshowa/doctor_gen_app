import 'package:doctor_gen_app/models/message.dart';

List<Message> messages = [
  Message(
    type: MessageType.media,
    sender: MessageSender.user,
    mediaUrl: 'assets/images/Designer.jpeg',
  ),
  Message(
    type: MessageType.text,
    sender: MessageSender.bot,
    text: "I see you've shared an image. What would you like to know about it?",
  ),
  Message(
    type: MessageType.text,
    sender: MessageSender.user,
    text:
        "I've been feeling very tired lately even though I sleep well. I also find it hard to concentrate and sometimes feel lightheaded. It’s been like this for two weeks. Should I be worried?",
  ),
  Message(
    type: MessageType.media,
    sender: MessageSender.bot,
    mediaUrl: 'assets/images/Designer.jpeg',
    text:
        "To boost your energy, focus on foods rich in protein, complex carbs, and healthy fats. Here are some great options: bananas, oats, eggs, nuts, and yogurt. These help maintain steady energy levels throughout the day.",
  ),
];
