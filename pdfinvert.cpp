#include <iostream>
#include <string>
#include <poppler/cpp/poppler-document.h>
#include <poppler/cpp/poppler-page.h>
#include <poppler/cpp/poppler-image.h>

int main(int argc, char *argv[]) {
  if (argc != 3) {
    std::cerr << "Usage: " << argv[0] << " input.pdf output.pdf" << std::endl;
    return 1;
  }

  poppler::document *doc = poppler::document::load_from_file(argv[1]);
  if (!doc) {
    std::cerr << "Failed to load PDF document" << std::endl;
    return 1;
  }

  for (int i = 0; i < doc->pages(); ++i) {
    poppler::page *page = doc->create_page(i);
    if (!page) {
      std::cerr << "Failed to load page " << i << std::endl;
      return 1;
    }

    poppler::image image = page->render_to_image(72, 72);
    image.set_color_model(poppler::image::color_model_grayscale);

    // Save the modified image to disk
    image.save(argv[2], "pdf");
  }

  return 0;
}

