class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.6.tar.gz"
  sha256 "5d6313ba3679b2089b2eca6c1ac45ed968790d103378f24588bf870318f48192"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b3fdceaad3d6f5297628b83f3e29a910a2a4fc5a7823e20ded6ee61b7bdc03cb" => :sierra
    sha256 "45719a9898e53cb0198d0182b66e4ac430f0b97ce9712c61463d4b56791ed404" => :el_capitan
    sha256 "ba20d32cda5b51b0f2ec57afcdb064e2cd026c8ce13d589cb2bf8cba099cf02c" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
