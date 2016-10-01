class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 6

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    sha256 "cb0992b7325e05b9c04e6a2f18f24335e0ccfa3966dc13a0c9c6bd3d532972a4" => :sierra
    sha256 "321eb138806d4689f526a6795911506f161ddb8f40e221f955c80608aa6f8aba" => :el_capitan
    sha256 "7c992f3a27413ae281209d7240c8bee039677b5e4b8e8e7ea06f9e28a57519dd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glm" => :build
  depends_on "glew"
  depends_on "jpeg"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "freetype"
  depends_on :x11 => :optional

  if MacOS.version < :mavericks
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-x" if build.without? "x11"
    system "autoreconf", "-f", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    begin
      pid = fork do
        exec bin/"mal4s", "-t", "2", "-o", "out", pkgshare/"sample--newns.mal4s"
      end
      sleep 1
      assert File.exist?("out"), "Failed to output PPM stream!"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
