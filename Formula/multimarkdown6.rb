class Multimarkdown6 < Formula
  desc "Turn marked-up plain text into well-formatted documents"
  homepage "http://fletcherpenney.net/multimarkdown/"
  # Use git tag instead of the tarball to get submodules
  url "https://github.com/fletcher/MultiMarkdown-6.git",
    :tag => "6.0.7",
    :revision => "83275c7ea773d69154d377e66c2d206c13651e07"

  head "https://github.com/fletcher/MultiMarkdown-6.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "852e3db1db3a16c684837d0e6a6ebc185a5a6ac9eeacc745f9322a5fa707a691" => :sierra
    sha256 "60ab42029b7e6c800a1a964037e7b5c43bb527bccc418e57d7124cec2612cd38" => :el_capitan
    sha256 "2340ca5c7b39a5d191c67ae456692b86a4f643830d6199f73f723ae75b5b92ce" => :yosemite
  end

  depends_on "cmake" => :build

  conflicts_with "mtools", :because => "both install `mmd` binaries"
  conflicts_with "markdown", :because => "both install `markdown` binaries"
  conflicts_with "discount", :because => "both install `markdown` binaries"
  conflicts_with "multimarkdown", :because => "both install `multimarkdown` binaries"

  def install
    system "make"

    cd "build" do
      system "make"
      bin.install "multimarkdown"
    end

    bin.install Dir["scripts/*"].reject { |f| f =~ /\.bat$/ }
  end

  test do
    assert_equal "<p>foo <em>bar</em></p>", pipe_output(bin/"multimarkdown", "foo *bar*\n")
    assert_equal "<p>foo <em>bar</em></p>", pipe_output(bin/"mmd", "foo *bar*\n")
  end
end
