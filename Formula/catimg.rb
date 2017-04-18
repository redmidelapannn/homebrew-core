class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.3.0.tar.gz"
  sha256 "2481bdc4966edaf65eef8bb97f102f089954641956b60b5e5e505f5d38ea48ae"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48a5093cde194d85bac9a716aaa1ad9d82c44bf2f9afb8a1d88fd2340ee3db07" => :sierra
    sha256 "530d0ccc957358de466efe28e5d28b77da4ef3925008792305044e148708f45f" => :el_capitan
    sha256 "25b4dd1b0969e545b70c54be0a47350bcd17a5eb31d0df17726b3812a1debfb9" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DMAN_OUTPUT_PATH=#{man1}", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
