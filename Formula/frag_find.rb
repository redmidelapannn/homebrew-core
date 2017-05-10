class FragFind < Formula
  desc "Hash-based carver tool (formerly 'NPS Bloom Filter package')"
  homepage "https://github.com/simsong/frag_find"
  url "https://digitalcorpora.org/downloads/frag_find/frag_find-1.0.0.tar.gz"
  sha256 "0ef28c18bbf80da78cf1c7dea3a75ca4741e600b38b7c2c71a015a794d9ab466"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e213f0aeb2c55fd56a610830e4fa58d32d1d4b863909c4571789d51089bd011e" => :sierra
    sha256 "cad3a113b91bea521b896234e8565e519abd9b846674bf0c6912627090e96061" => :el_capitan
    sha256 "e97d64cdc6bf16f24424b8fb17f4f3d7f81e8865c28ca54a5c431e17ec06460c" => :yosemite
  end

  head do
    url "https://github.com/simsong/frag_find.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"

  def install
    if build.head?
      # don't run ./configure without arguments
      inreplace "bootstrap.sh", "./configure", ""
      system "./bootstrap.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    libexec.install bin/"frag_find.jar"
  end

  test do
    path = testpath/"test.raw"
    system "dd", "if=/dev/zero", "of=#{path}", "bs=1", "count=0", "seek=512"

    assert_match(/Total blocks of original file found: 1 \(100%\)/,
                 shell_output("#{bin}/frag_find #{path} #{path}"))
  end
end
