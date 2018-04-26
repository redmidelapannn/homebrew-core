class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/archive/v4.2.5.tar.gz"
  sha256 "f33807105ce47f684c26751ce4e27a708a83ce120cbabbc614c8df21252b238c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dc8809555d1052d1852be568e4a21f506f2f1604e79c47772b69cdd1e84ad6f0" => :high_sierra
    sha256 "d277eef42246757a076bab2893ab41b1499bba15972dec5ba3c9dd0cb1e2cc3b" => :sierra
    sha256 "f6b4696228707942aa0e3837d7d44c6d804f8410e6176febe29367cd2d6e7939" => :el_capitan
  end

  head do
    url "https://github.com/zeromq/libzmq.git"
  end

  option "with-libpgm", "Build with PGM extension"
  option "with-norm", "Build with NORM extension"
  option "with-drafts", "Build and install draft classes and methods"

  deprecated_option "with-pgm" => "with-libpgm"

  depends_on "cmake" => [:build, :optional]
  if build.without? "cmake"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end
  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional
  depends_on "norm" => :optional

  def install
    if build.with? "cmake"
      args = std_cmake_args

      args << "-DWITH_OPENPGM=ON" if build.with? "libpgm"
      args << "-DWITH_LIBSODIUM=ON" if build.with? "libsodium"
      args << "-DENABLE_DRAFTS=ON" if build.with? "drafts"

      mkdir "build" do
        system "cmake", "..", *args
        system "cmake", "--build", ".", "--target", "install"
      end
    else
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

      args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

      args << "--with-pgm" if build.with? "libpgm"
      args << "--with-libsodium" if build.with? "libsodium"
      args << "--with-norm" if build.with? "norm"
      args << "--enable-drafts" if build.with?("drafts")

      ENV["LIBUNWIND_LIBS"] = "-framework System"
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      ENV["LIBUNWIND_CFLAGS"] = "-I#{sdk}/usr/include"

      system "./autogen.sh"
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
