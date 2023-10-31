class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({this.image = '', this.title = '', this.discription = ''});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Welcome to Fridgering',
      image: 'assets/images/onboard1.png',
      discription: "Have you ever faced the challenge of"
          "opening your fridge and not knowing "
          "what to eat?"),
  UnbordingContent(
      title: 'Find Recipes',
      image: 'assets/images/onboard2.png',
      discription: "Have you ever faced the challenge of"
          "finding a recipe from the chaos of your "
          "fridge?"),
  UnbordingContent(
      title: "Embrace the Ease with "
          "Fridgering",
      image: 'assets/images/onboard3.png',
      discription: "Fridgering will come to solve this problem"
          "for you!"),
];
