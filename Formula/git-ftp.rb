class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.2.tar.gz"
  sha256 "a6bf52f6f1d30c4d8f52fd0fbd61dc9f32e66099e3e9c4994bec65094305605b"
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d4d1796bb292667310fa38df91cc6145a8f57dc5bf1b23e78d992b497ae1083" => :mojave
    sha256 "d9aa444626a4292598f15a13bf19708e66b048a1b5dc9f1472e9a49ece57e44e" => :high_sierra
    sha256 "492ffb2da92fc0f9f5a563c7a67b38c21aa82af1e6efdb4fab09bb904d9c3c50" => :sierra
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"
  uses_from_macos "zlib"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.62.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.62.0.tar.bz2"
    sha256 "7802c54076500be500b171fde786258579d60547a3a35b8c5a23d8c88e8f9620"
  end

  def install
    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-ares",
                            "--with-darwinssl",
                            "--with-libssh2",
                            "--without-brotli",
                            "--without-ca-bundle",
                            "--without-ca-path",
                            "--without-gssapi",
                            "--without-libmetalink",
                            "--without-librtmp"
      system "make", "install"
    end

    system "make", "prefix=#{prefix}", "install"
    system "make", "-C", "man", "man"
    man1.install "man/git-ftp.1"
    (libexec/"bin").install bin/"git-ftp"
    (bin/"git-ftp").write_env_script(libexec/"bin/git-ftp", :PATH => "#{libexec}/bin:$PATH")
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
