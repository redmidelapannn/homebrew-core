class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/archive/znc-1.7.1.tar.gz"
  sha256 "44cfea7158ea05dc2547c7c6bc22371e66c869def90351de0ab90a9c200d39c4"

  bottle do
    rebuild 1
    sha256 "481804fd08aa115df42d8ed99865ec133e67d052b97b5c14868da5d2cff320a5" => :mojave
    sha256 "069df8ff6d4f941bb2855ed890c8723f940cd3116396db01094a7bed685a3829" => :high_sierra
    sha256 "2d726dd5a8ac2df5fd7d9a7696d15b26b32f3604cd3d651b080f54f0190b2248" => :sierra
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-icu4c", "Build with icu4c for charset support"
  option "with-python3", "Build with mod_python support, allowing Python ZNC modules"

  deprecated_option "with-python3" => "with-python"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "icu4c" => :optional
  depends_on "python" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

    args = ["--prefix=#{prefix}"]
    args << "--enable-python" if build.with? "python"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "znc --foreground"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/znc</string>
          <string>--foreground</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/znc.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/znc.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>StartInterval</key>
        <integer>300</integer>
      </dict>
    </plist>
  EOS
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end
