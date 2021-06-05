class RecipeModule {
  String label;
  String image;
  String source;
  String url;
  RecipeModule({
    this.label,
    this.image,
    this.source,
    this.url,
  });
  factory RecipeModule.fromMap(Map<String, dynamic> parsedjson) {
    return RecipeModule(
      url: parsedjson["url"],
      label: parsedjson['label'],
      image: parsedjson['image'],
      source: parsedjson['source'],
    );
  }
}
