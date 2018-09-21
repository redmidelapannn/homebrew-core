class Newlisp < Formula
  desc "Lisp-like, general-purpose scripting language"
  homepage "http://www.newlisp.org/"
  url "http://www.newlisp.org/downloads/newlisp-10.7.1.tgz"
  sha256 "2e300c8bed365a564d284bf3ad6c49e036256e7fc3f469ebda0b45e6e196a7cc"

  bottle do
    rebuild 1
    sha256 "b9c24452a2764a50fe918801f07879a32553cab4ae19f31c07cb7e5a92d166be" => :mojave
    sha256 "c198046d87ef5ef3069c66bf317b3c4f42aed6f85e9afc2a1c62a5807167f55b" => :high_sierra
    sha256 "511865cf1617361926b5f9b0b22aad8cb497ed91e33c64d49351cd1752889941" => :sierra
    sha256 "e5997990197a11c673ee0ade6b5ddcf34de32eae5b7424b0f26a2522181729f0" => :el_capitan
  end

  depends_on "readline"

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

  def caveats; <<~EOS
    If you have brew in a custom prefix, the included examples
    will need to be be pointed to your newlisp executable.
  EOS
  end

  test do
    path = testpath/"test.lsp"
    path.write <<~EOS
      (println "hello")
      (exit 0)
    EOS

    assert_equal "hello\n", shell_output("#{bin}/newlisp #{path}")
  end
end
