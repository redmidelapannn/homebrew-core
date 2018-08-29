class Badtouch < Formula
  desc "Scriptable network authentication cracker"
  homepage "https://github.com/kpcyrd/badtouch"
  url "https://github.com/kpcyrd/badtouch/archive/v0.6.1.tar.gz"
  sha256 "62181ac05a68a552e1984dd42206f6a5ca195e51addc48cbfdf55a60afc7c3ae"

  bottle do
    rebuild 1
    sha256 "310dac17430016c0ce60e9e0abdca4fd18b2a913af6f6f37726e999ae6fd1d60" => :mojave
    sha256 "b3062463bb281299bd13b6706e6dbb7eaf6934a31aa3d93b04a099a97304d1a6" => :high_sierra
    sha256 "47bfe9dfa0a2fc1b2979af8d4def7682e27fa4d3bf26530441557f14543f033e" => :sierra
    sha256 "6673e8b7d42b910d24847ea2b814d81cc415fd487b60c310bbee8995fe33f9ff" => :el_capitan
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Prevent cargo from linking against a different library
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib

    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "docs/badtouch.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      descr = "always true"

      function verify(user, password)
          return true
      end
    EOS
    system "#{bin}/badtouch", "oneshot", "-vvx", testpath/"true.lua", "foo"
  end
end
