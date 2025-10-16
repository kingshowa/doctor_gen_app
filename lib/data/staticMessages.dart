import 'package:doctor_gen_app/models/message.dart';

List<Message> staticMessages = [
  Message(
    type: MessageType.text,
    sender: MessageSender.user,
    text: "Hello! I have a question about my health.",
  ),
  Message(
    type: MessageType.text,
    sender: MessageSender.bot,
    text: "Sure! What would you like to know?",
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
    mediaUrl:
        'https://calfreshhealthyliving.cdph.ca.gov/en/PublishingImages/eat-healthy/fruitPlate.jpg',
    text:
        "To boost your energy, focus on foods rich in protein, complex carbs, and healthy fats. Here are some great options: bananas, oats, eggs, nuts, and yogurt. These help maintain steady energy levels throughout the day.",
  ),
];
