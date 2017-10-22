class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.1.tar.gz"
  sha256 "9d0dd07f05a9a59b865041417dc61f16a664d85415f0271eb854412638e52e47"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3fbaf73665a54fb008dec5cfb5594c05b10f99614e7ca07156782d15617d4564" => :high_sierra
    sha256 "0ccae82daac0bd6bfdb810d1ea485f470a18974de0f9fb5eb81907672cde71c1" => :sierra
    sha256 "a330706ff9a8fb025a11fa1b8e12e5e10e72d0d1e0360943eb9d7b713c095588" => :el_capitan
  end

  option "with-config-x86_64", "Build Compcert with ./configure 'x86_64'"

  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = buildpath/"opamroot"
    (buildpath/"opamroot").mkpath
    system "opam", "init", "--no-setup"
    system "opam", "config", "exec", "--", "opam", "install", "coq=8.6.1"

    args = ["-prefix", prefix]
    args << (build.with?("config-x86_64") ? "x86_64-macosx" : "ia32-macosx")
    system "opam", "config", "exec", "--", "./configure", *args
    system "opam", "config", "exec", "--", "make", "all"
    system "opam", "config", "exec", "--", "make", "install"
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
