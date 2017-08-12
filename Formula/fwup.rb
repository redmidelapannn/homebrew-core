class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.15.4/fwup-0.15.4.tar.gz"
  sha256 "0594ae5dd1014a610881b21289a8415c8b78ea012d2a5567d57f986625669167"

  bottle do
    cellar :any
    sha256 "819be337b851be08b0996bef273befc2d57ca8e4c8cad1540440620ff5772d62" => :sierra
    sha256 "e936d51d544f3cf906bead78b679328577be00dd02c875b147be9f9db408f91f" => :el_capitan
    sha256 "572d68bf7e3f7b1ce205d494ffc7ff1096f03790fa753ab9b830dd3ea163de0a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
