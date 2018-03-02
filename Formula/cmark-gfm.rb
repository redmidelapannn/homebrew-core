class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.12.tar.gz"
  version "0.28.3.gfm.12"
  sha256 "7f53d060a82df012859ae3493c62e2d63b8146cbea8af77e696cde41a62d7246"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ccfbc14e5d8c0a11211c005d9ab6a17a4dbb53398e7952b3771893133fac69d" => :high_sierra
    sha256 "f1a910375e1d06e94f1a7039f70169a87712e4c6a528c23c7a5b8038a43ae612" => :sierra
    sha256 "30ec64c9c39c95b0c438c0daf09f59efc34fec8a5f861215144bb4c5fbedfaae" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
