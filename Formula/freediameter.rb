class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.2.1.tar.gz"
  sha256 "bd7f105542e9903e776aa006c6931c1f5d3d477cb59af33a9162422efa477097"
  head "http://www.freediameter.net/hg/freeDiameter", :using => :hg

  bottle do
    sha256 "19c0010721e89c4c3a1bb2d7121ef526d19d2def86c12d6a32d3448fc7ed7c37" => :sierra
    sha256 "6c9b5efa0d21ecdcbc3682309018d8e3a87be085c33d5c3cb9af59cf34373e07" => :el_capitan
    sha256 "b1dc119ec4d3693e89761e8e4262c04b1d18244a768cd06c55a786eceb3c2956" => :yosemite
  end

  option "with-all-extensions", "Enable all extensions"

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  if build.with? "all-extensions"
    depends_on :postgresql
    depends_on :mysql
    depends_on "swig" => :build
  end

  def install
    # Support libidn 2.x. Upstream Trac is DOA.
    # Emailed help@freediameter.net on 26/04/2017 with patch.
    %w[
      cmake/Modules/FindIDNA.cmake
      include/freeDiameter/CMakeLists.txt
      libfdproto/ostr.c
    ].each { |f| inreplace f, "idna.h", "idn2.h" }
    inreplace "cmake/Modules/FindIDNA.cmake", "NAMES idn", "NAMES idn2"

    args = std_cmake_args + %W[
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
      -DIDNA_INCLUDE_DIR=#{Formula["libidn"].opt_include}
    ]
    args << "-DALL_EXTENSIONS=ON" if build.with? "all-extensions"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    prefix.install "doc", "contrib"
  end

  def post_install
    unless File.exist?(etc/"freeDiameter.conf")
      cp prefix/"doc/freediameter.conf.sample", etc/"freeDiameter.conf"
    end
  end

  def caveats; <<-EOS.undent
    To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

    Sample configuration files can be found in #{opt_prefix}/doc

    For more information about freeDiameter configuration options, read:
      http://www.freediameter.net/trac/wiki/Configuration

    Other potentially useful files can be found in #{opt_prefix}/contrib
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/freeDiameterd</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
