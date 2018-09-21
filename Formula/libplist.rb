class Libplist < Formula
  desc "Library for Apple Binary- and XML-Property Lists"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libplist-2.0.0.tar.bz2"
  sha256 "3a7e9694c2d9a85174ba1fa92417cfabaea7f6d19631e544948dc7e17e82f602"

  bottle do
    cellar :any
    rebuild 1
    sha256 "af6d64134583cac1fa5e72cd6c65066d437fbabb01ed00ec889df5c49fce17c1" => :mojave
    sha256 "06cf334dff69a2d60c4b9db18cb1ffb0b724e15ac7e1ea35817a96fc38f663a5" => :high_sierra
    sha256 "6fd7002f75f2847a837fc0c7989db22a9638c203dee02cba47b9a6e4c0d3fd84" => :sierra
    sha256 "c8f00bdb4ce3a62fcca25313a57491e4dd42bc7a07d789386f2f58062462a4a3" => :el_capitan
  end

  head do
    url "https://git.sukimashita.com/libplist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cython" => :build
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

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
