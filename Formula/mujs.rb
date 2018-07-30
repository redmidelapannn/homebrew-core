class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      :tag => "1.0.3",
      :revision => "25821e6d74fab5fcc200fe5e818362e03e114428"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "11a679f64bd081ec45ee3be3a4f9d0ae1c7b145749d00ac45f5f93879e17656d" => :high_sierra
    sha256 "62e27b0944f614c9c4cd96e849dc1673704575bf448bd8529274151dcdbff9b5" => :sierra
    sha256 "1b8ed7cff95bedc3c12da7c0cb65765cc65f07f0c13547c21e2da3c8a238f076" => :el_capitan
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
