class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 3
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8d1a19289416a7150baee1822b5a6b30b7a42f700d5aa1677ac615bc4fea0a60" => :high_sierra
    sha256 "93ee12072296d4a3c9e5db478b1644f05b227077f0f7f3d017f782673bf1aaaf" => :sierra
    sha256 "451db0c6cf413eb4704becf57cfaaa4ee96f33abf1c9033ea65aefdaec8f9689" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.57.0.tar.bz2"
    mirror "http://curl.askapache.com/download/curl-7.57.0.tar.bz2"
    sha256 "c92fe31a348eae079121b73884065e600c533493eb50f1f6cee9c48a3f454826"
  end

  def install
    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--with-darwinssl",
                            "--without-ca-bundle",
                            "--without-ca-path",
                            "--with-libssh2",
                            "--without-libmetalink",
                            "--without-gssapi",
                            "--without-librtmp",
                            "--disable-ares"
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
