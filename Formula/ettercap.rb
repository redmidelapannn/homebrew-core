class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  url "https://github.com/Ettercap/ettercap/archive/v0.8.3.tar.gz"
  sha256 "d561a554562e447f4d7387a9878ba745e1aa8c4690cc4e9faaa779cfdaa61fbb"
  head "https://github.com/Ettercap/ettercap.git"

  bottle do
    rebuild 1
    sha256 "8da11e91ef46159da4b05adb0177bb23b1dda12382f952b019d6b2c1775b3fd0" => :mojave
    sha256 "9981069d7e41103bc63d7d869802582be50aacebd54b6700918628c02c882dbe" => :high_sierra
    sha256 "417dc5eb2294e54e758e1fd8af1888fd7215980e7f91374fb294f063ded928fe" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl"
  depends_on "pcre"

  def install
    # Work around a CMake bug affecting harfbuzz headers and pango
    # https://gitlab.kitware.com/cmake/cmake/issues/19531
    ENV.append_to_cflags "-I#{Formula["harfbuzz"].opt_include}/harfbuzz"

    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
