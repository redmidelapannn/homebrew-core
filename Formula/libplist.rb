class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libplist-2.0.0.tar.bz2"
  sha256 "3a7e9694c2d9a85174ba1fa92417cfabaea7f6d19631e544948dc7e17e82f602"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3d0c696177d9c5402c531970567a8163195252295d2da5c23558dd38b858bdb5" => :high_sierra
    sha256 "9ad3a15078960b6171ca1d5465a11185a61622a197b352bb225d27f138633659" => :sierra
    sha256 "59aa09cbfc157556603bc20f28731141b49e8b461d88cd1d3245322f2373fbfa" => :el_capitan
  end

  head do
    url "https://git.sukimashita.com/libplist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-cython", "Skip building Cython Python bindings"

  deprecated_option "with-python" => "without-cython"

  depends_on "pkg-config" => :build
  depends_on "cython" => [:build, :recommended]

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--without-cython" if build.without? "cython"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install", "PYTHON_LDFLAGS=-undefined dynamic_lookup"
  end

  test do
    (testpath/"test.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>test</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/echo</string>
        </array>
      </dict>
      </plist>
    EOS
    system bin/"plistutil", "-i", "test.plist", "-o", "test_binary.plist"
    assert_predicate testpath/"test_binary.plist", :exist?,
                     "Failed to create converted plist!"
  end
end
