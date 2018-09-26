class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.8.tar.gz"
  mirror "https://fossies.org/linux/www/source-highlight-3.1.8.tar.gz"
  sha256 "01336a7ea1d1ccc374201f7b81ffa94d0aecb33afc7d6903ebf9fbf33a55ada3"
  revision 10

  bottle do
    sha256 "81826982318da13cca56a7001a77aeed1cfe86dfd13cf8f5662bcff48df46e01" => :mojave
    sha256 "73e5f7f909b45d7d9a188ff0397aebfd60bfc7e50a6d7a7e5baa543bd78452f9" => :high_sierra
    sha256 "b102851a6a5f10c04445d41c1842641673b4b2f83466af2ba40ce9283a9e2ec2" => :sierra
  end

  depends_on "boost"

  needs :cxx11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
