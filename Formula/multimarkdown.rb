class Multimarkdown < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "https://fletcher.github.io/MultiMarkdown-6/"
  url "https://github.com/fletcher/MultiMarkdown-6/archive/6.5.1.tar.gz"
  sha256 "e8710777566d7710100b44e829a15d0ec2fce20271477aebea7caac319e1b20f"
  head "https://github.com/fletcher/MultiMarkdown-6.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "148e68aab42cc06fcf6b96c4c7280b79c49d9121005d72cfda3786e3aba27923" => :catalina
    sha256 "05b81d9f1837f6f4f1a01dbc23e15ced518c3fd905fa1271488c96dea8641a0c" => :mojave
    sha256 "b865bf7407cda8d229eb7706baf071574873d368881edffa736bc51e05056efd" => :high_sierra
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f =~ /\.bat$/ }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>\n", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
