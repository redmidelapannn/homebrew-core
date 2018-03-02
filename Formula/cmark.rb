class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "http://commonmark.org"
  url "https://github.com/jgm/cmark/archive/0.28.3.tar.gz"
  sha256 "acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f88daf5a2dd8bb37330d8da4fc6f5d681e9f28a6b5df082b29480669c6bd9dcb" => :high_sierra
    sha256 "328d574f41cd84568bcdd19449702a0a57aea59a294b2726f75347ea2e09377d" => :sierra
    sha256 "53c690fddc3c8e1c37fd8da3557236c16c64c010181da4714ea5729e768464dd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
