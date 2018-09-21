class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.5.0/abcl-src-1.5.0.tar.gz"
  sha256 "920ee7d634a7f4ceca0a469d431d3611a321c566814d5ddb92d75950c0631bc2"
  revision 1
  head "https://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "816ee918682324d9c382c0d409552e740ca05b26f3336cebce1629870a4294ac" => :high_sierra
    sha256 "68e32832b66dea1ffe1ca66507dc0d9ea5ea649c107fe7c290156bebf76bc93b" => :sierra
    sha256 "1c86b3978b3cd8f711ced750f0d36655ef9b5584003cabbb45dbc72178101c06" => :el_capitan
  end

  depends_on "ant"
  depends_on :java => "1.8"
  depends_on "rlwrap"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<~EOS
      #!/bin/sh
      export JAVA_HOME=$(#{cmd})
      rlwrap java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
