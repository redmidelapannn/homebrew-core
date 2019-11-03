class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://www.gprolog.org/gprolog-1.4.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/g/gprolog/gprolog_1.4.5.orig.tar.gz"
  sha256 "bfdcf00e051e0628b4f9af9d6638d4fde6ad793401e58a5619d1cc6105618c7c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "97fc2ccb63cbe917da6f86be077e4569ee5811a6eb0c2cc7064e4fe2b395a2f6" => :mojave
    sha256 "9ba0f90506f38da51e554d4fad1fa697a5074b8a121e35894ef172f6d4f66cda" => :high_sierra
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match /Hello World!/, shell_output("./test")
  end
end
