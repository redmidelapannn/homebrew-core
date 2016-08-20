class Txt2man < Formula
  desc "Convert flat ASCII text to man page format"
  homepage "https://github.com/mvertes/txt2man"
  url "https://github.com/mvertes/txt2man/archive/txt2man-1.6.0.tar.gz"
  sha256 "f6939e333a12e1ecceccaa547b58f4bf901a580cd2d8f822f8c292934c920c99"
  head "https://github.com/mvertes/txt2man.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "68182189940521e349f90cbb4eff485c4927eec64575ed520f625b8029832d28" => :el_capitan
    sha256 "6bfb01216278e2d28a605547fbb81997f732721e8a2b104c664cf08e69947d7c" => :yosemite
    sha256 "6bfb01216278e2d28a605547fbb81997f732721e8a2b104c664cf08e69947d7c" => :mavericks
  end

  depends_on "gawk"
  depends_on "coreutils"

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    system "make", "install", "prefix=#{prefix}"
    bin.env_script_all_files(libexec/"bin", :PATH => "#{HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH")
  end

  test do
    # txt2man
    (testpath/"test.txt").write <<-EOS.undent
      A TITLE

      blah blah blah
    EOS

    assert_match(/\.SH A TITLE/, shell_output("#{bin}/txt2man test.txt"))

    # src2man
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>

      /** 3
      * main - do stuff
      **/
      int main(void) { return 0; }
    EOS

    assert_equal "main.3\n", shell_output("#{bin}/src2man test.c 2>&1")
    assert_match(/\\fBmain\ \\fP\-\ do\ stuff\n/, File.read("main.3").lines.to_a[4])

    # bookman
    system "#{bin}/bookman", "-t", "Test", "-o", "test", *Dir["#{man1}/*"]
    assert File.exist?("test")
  end
end
