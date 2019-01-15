class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "eb38663b392a2e1e1e90a70b8dc9f2a6f7016bca7da433fccd5d814dbfb545e1" => :mojave
    sha256 "b6d6b961d6840a80094723f62dec80a5f82dba23c33a4a885614da7a88387d68" => :high_sierra
    sha256 "e66bcc270246d7fb35fa9c1e1e04e2b47240f44c18d6d51e07af30255810a249" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "flac"
  depends_on "libao"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
