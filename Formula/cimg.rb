class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_2.0.0.zip"
  sha256 "f6ee5c6b16fac167c120a060998ab6864856ff0a2bbb78134472db7ca0f26889"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b49f27614223ffaeeeab299ea368c6c9f4a19c9c04ac8b1d7d379e8ebe4f76f" => :sierra
    sha256 "dbad13ab3934309880d681cafe7f1eed602678bb08fc4bd02b97351752bc1335" => :el_capitan
    sha256 "dbad13ab3934309880d681cafe7f1eed602678bb08fc4bd02b97351752bc1335" => :yosemite
  end

  def install
    include.install "CImg.h"

    doc.install %w[
      README.txt
      Licence_CeCILL-C_V1-en.txt
      Licence_CeCILL_V2-en.txt
      examples
      plugins
    ]
  end

  test do
    cp_r doc/"examples", testpath
    cp_r doc/"plugins", testpath
    system "make", "-C", "examples", "mmacosx"
    system "examples/image2ascii"
  end
end
