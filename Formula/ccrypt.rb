class Ccrypt < Formula
  desc "Encrypt and decrypt files and streams"
  homepage "https://ccrypt.sourceforge.io/"
  url "http://ccrypt.sourceforge.net/download/1.11/ccrypt-1.11.tar.gz"
  sha256 "b19c47500a96ee5fbd820f704c912f6efcc42b638c0a6aa7a4e3dc0a6b51a44f"

  bottle do
    rebuild 1
    sha256 "a1f0fa02b623955333f98118473c16a7af7e740c18455d48866133ce7dd9a97b" => :high_sierra
    sha256 "41561da9ecb852e0e704b6c9d6693f1eac65a02d0ff1419eb55b4221550d6aa7" => :sierra
    sha256 "006c8e5eb58e88305dec70559d6d64fd0203881dcaca36db50cbb44d3aaae61b" => :el_capitan
    sha256 "44efc492cc7cf2d4f1061f14fd5aa213517406434c41c96e297d9b4f06d7e1a7" => :yosemite
  end

  conflicts_with "ccat", :because => "both install `ccat` binaries"

  fails_with :clang do
    build 318
    cause "Tests fail when optimizations are enabled"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-lispdir=#{share}/emacs/site-lisp/ccrypt"
    system "make", "install"
    system "make", "check"
  end

  test do
    touch "homebrew.txt"
    system bin/"ccrypt", "-e", testpath/"homebrew.txt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt.cpt", :exist?
    refute_predicate testpath/"homebrew.txt", :exist?

    system bin/"ccrypt", "-d", testpath/"homebrew.txt.cpt", "-K", "secret"
    assert_predicate testpath/"homebrew.txt", :exist?
    refute_predicate testpath/"homebrew.txt.cpt", :exist?
  end
end
