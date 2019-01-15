class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.5.tar.gz"
  sha256 "0c4f946e873e26777423e1bab37392220aec9382ae818866d2e3a52b3c976cf1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef57bc5a2321bbb1c95e541940341015526f17655e1dc988bf85084eafd4010b" => :mojave
    sha256 "530ff40ba42cd52ee587aac535a48067796689a59dbbdd0003c14352112e755e" => :high_sierra
    sha256 "dd9ac5eb80ba056d01fae7dac792f4f6b702bb062f4f169b13e6a27158cfcae8" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
