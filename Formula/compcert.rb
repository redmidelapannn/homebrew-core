class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.7.tar.gz"
  sha256 "ceee1b2ed6c2576cb66eb7a0f2669dcf85e65c0fc68385f0781b0ca4edb87eb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "135183e0aeb212282e23a94a463d68a0084d48f64aa05bc070f1b58f352ff851" => :catalina
    sha256 "903f6c866ff30560869424a6a9b82698bc58a054173c6c67fa11a2dfc7503676" => :mojave
    sha256 "43808655baef1f1f1b3cc64bbfa8c6d505705029d4006400d2a319e8c3f46932" => :high_sierra
  end

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  def install
    # We pass -ignore-coq-version, otherwise every new version of coq
    # breaks the strict version check.
    system "./configure", "-prefix", prefix, "x86_64-macosx",
                          "-ignore-coq-version"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
