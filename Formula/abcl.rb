class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "http://abcl.org"
  url "http://abcl.org/releases/1.5.0/abcl-src-1.5.0.tar.gz"
  sha256 "920ee7d634a7f4ceca0a469d431d3611a321c566814d5ddb92d75950c0631bc2"
  head "http://abcl.org/svn/trunk/abcl/", :using => :svn

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f0e8fad7d4d6af1c101d468ef52ba07acc1e3f8f5a5979d6a7edf510ff7458c4" => :sierra
    sha256 "3a8c5eb65230ad60855b1f9a6a2cd38e544d580a6934982f2d490e9fd667d5b1" => :el_capitan
    sha256 "50062e15ef2b58121f039e6bb28043cbbcf931b69aceb930f57b3f520c22a9d5" => :yosemite
  end

  depends_on "ant"
  depends_on :java => "1.5+"
  depends_on "rlwrap" => :recommended

  def install
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write <<-EOS.undent
      #!/bin/sh
      #{"rlwrap " if build.with?("rlwrap")}java -cp #{libexec}/abcl.jar:"$CLASSPATH" org.armedbear.lisp.Main "$@"
    EOS
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match /"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip
  end
end
