class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200402.tar.gz"
  sha256 "cf15f204ad8eea3396c2c7179b5ec0cffb06c9628b6f91050c6f2cbcaabb8928"

  bottle do
    sha256 "791bcb4dd437155d7771c72000062beabf78e216d44b4b28b8b6ad33a54fef54" => :catalina
    sha256 "eb71acc9382ec79c173bbe193847531e29488c402fed5b7669d454dacc63cae7" => :mojave
    sha256 "47b6c68f8c58858549362de3658879a8960baa8aabaf008b462546cd7b020640" => :high_sierra
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
