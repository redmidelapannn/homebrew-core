class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.7.0.tar.gz"
  sha256 "1be554f28a234741cdc336891996969c49c16c80c8ca84dedb05e76b4ccac709"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "efab11826c6d761d1e9d449b9319f4a4e19cfdabb83585a97af967914dc6ed48" => :sierra
    sha256 "c8ed0ad43d37e6b1833db660883e1349d36d15b7334433ad708078caff04c79c" => :el_capitan
    sha256 "19b784e7799fa7576718b66c6d903da8ecd7890f9f9d3be3926a122cca75f829" => :yosemite
  end

  option "without-git", "Build without Git support"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    args = ["PREFIX=#{prefix}"]
    args << "FEATURES=" if build.without? "git"

    system "make", "install", *args
    bash_completion.install "contrib/completions.bash" => "exa"
    zsh_completion.install  "contrib/completions.zsh"  => "_exa"
    fish_completion.install "contrib/completions.fish" => "exa.fish"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
