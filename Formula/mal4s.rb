class Mal4s < Formula
  desc "Malicious host finder based on gource"
  homepage "https://github.com/secure411dotorg/mal4s/"
  url "https://service.dissectcyber.com/mal4s/mal4s-1.2.8.tar.gz"
  sha256 "1c40ca9d11d113278c4fbd5c7ec9ce0edc78d6c8bd1aa7d85fb6b9473e60f0f1"
  revision 5

  head "https://github.com/secure411dotorg/mal4s.git"

  bottle do
    rebuild 2
    sha256 "cf57e167f5a672a05fdd237fa5c74cef8934198c7b6746a441155883905c6967" => :sierra
    sha256 "d2be76a17b3885bcf60402b8bf5ff0f586fe9e55d0fbb2bc8ee97bc0a027606c" => :el_capitan
    sha256 "ad7b67a4d4b824f658d437c65284c4b5b6ac27a394dca1d3dda04ecddfed0307" => :yosemite
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
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
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
      sleep 60
      assert File.exist?("out"), "Failed to output PPM stream!"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
