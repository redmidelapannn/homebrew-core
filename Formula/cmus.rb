class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.7.1.tar.gz"
  sha256 "8179a7a843d257ddb585f4c65599844bc0e516fe85e97f6f87a7ceade4eb5165"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    rebuild 1
    sha256 "2025838eca93df14ad5a645e9b1978294c1cb94536e8ce26f3545c4eb0fe9ebb" => :mojave
    sha256 "037e94781ab970d4419b48650daaf3117ea654234bb3ce9ef27f6b76cf9ae3d0" => :high_sierra
    sha256 "d90ac499aaea22ad3e86d64c4028228aa2cb28f2ced550f3559bb021804a4563" => :sierra
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
  depends_on "ffmpeg" => :optional
  depends_on "jack" => :optional
  depends_on "opusfile" => :optional

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
