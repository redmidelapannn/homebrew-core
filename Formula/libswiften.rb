class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-4.0/swift-4.0.tar.gz"
  sha256 "50b7b2069005b1474147110956f66fdde0afb2cbcca3d3cf47de56dc61217319"
  revision 2

  bottle do
    cellar :any
    sha256 "a31467c2c5a010b1581accc5885b0652f13c79020facd41998d9cd525687577d" => :mojave
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua@5.1"

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]
    lua = Formula["lua@5.1"]

    args = %W[
      -j #{ENV.make_jobs}
      V=1
      linkflags=-headerpad_max_install_names
      optimize=1 debug=0
      allow_warnings=1
      swiften_dll=1
      boost_includedir=#{boost.include}
      boost_libdir=#{boost.lib}
      libidn_includedir=#{libidn.include}
      libidn_libdir=#{libidn.lib}
      SWIFTEN_INSTALLDIR=#{prefix}
      openssl=no
      SLUIFT_INSTALLDIR=#{prefix}
      lua_includedir=#{lua.include}/lua-5.1
      lua_libdir=#{lua.lib}
      lua_libname=lua.5.1
      #{prefix}
    ]

    system "scons", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Swiften/Swiften.h>
      using namespace Swift;
      int main()
      {
        SimpleEventLoop eventLoop;
        BoostNetworkFactories networkFactories(&eventLoop);
        return 0;
      }
    EOS
    cflags = `#{bin}/swiften-config --cflags`
    ldflags = `#{bin}/swiften-config --libs`
    system "#{ENV.cxx} -std=c++11 test.cpp #{cflags.chomp} #{ldflags.chomp} -o test"
    system "./test"
  end
end
