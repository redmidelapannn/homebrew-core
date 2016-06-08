class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.0.tgz"
  sha256 "c4963bf32d67eef7e4957f7118632a0c40350fd0e28064bce095865b383137bb"

  bottle do
    revision 1
    sha256 "9ce1f844524215fcf5ec36e2231e6c8f2db40971c6dc7558f25c1a857aec6409" => :el_capitan
    sha256 "abef850727f8c27021bdaad31020f4f20af617d1c0bc2f56d5c9ec9814edca66" => :yosemite
    sha256 "8f210e99955b4d9f1b955afdc281010916c3376c68de44792ef2f53b59e45e06" => :mavericks
  end

  devel do
    url "http://www.newlisp.org/downloads/development/inprogress/newlisp-10.7.1.tgz"
    sha256 "9e019f876f4179601c569e0324dbe2e48f28aa67b1c9e61ee194b700be6c1067"
  end

  depends_on "readline" => :recommended

  def install
    # Required to use our configuration
    ENV.append_to_cflags "-DNEWCONFIG -c"

    # fix the prefix in a source file
    inreplace "guiserver/newlisp-edit.lsp" do |s|
      s.gsub! "#!/usr/local/bin/newlisp", "#!/usr/bin/env newlisp"
      s.gsub! "/usr/local/bin/newlisp", "#{opt_bin}/newlisp"
    end

    system "./configure-alt", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
    EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<-EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
