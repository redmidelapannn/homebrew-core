class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"

  stable do
    url "https://swift.im/downloads/releases/swift-3.0/swift-3.0.tar.gz"
    sha256 "8aa490431190294e62a9fc18b69ccc63dd0f561858d7d0b05c9c65f4d6ba5397"

    # Patch to fix build error of dynamic library with Apple's Secure Transport API
    # Fixed upstream: https://swift.im/git/swift/commit/?id=1d545a4a7fb877f021508094b88c1f17b30d8b4e
    patch :DATA
  end

  bottle do
    revision 2
    sha256 "33a8196b8e4dd2f03fa3d911ce80b650c21774a3b4e35f0c88b3a4760f02cf1a" => :el_capitan
    sha256 "f53b26dbcf2dab8fd78158707fd1fa51bbe1d02bcb81cd227ce8d0cb440fe39b" => :yosemite
    sha256 "5801e62b0aa3e7920ca358c88d3674e82d77591d45cc2824ac6fdde058dda3fe" => :mavericks
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua" => :recommended

  def install
    boost = Formula["boost"]
    libidn = Formula["libidn"]

    args = %W[
      -j #{ENV.make_jobs}
      V=1
      optimize=1 debug=0
      allow_warnings=1
      swiften_dll=1
      boost_includedir=#{boost.include}
      boost_libdir=#{boost.lib}
      libidn_includedir=#{libidn.include}
      libidn_libdir=#{libidn.lib}
      SWIFTEN_INSTALLDIR=#{prefix}
      openssl=no
    ]

    if build.with? "lua"
      lua = Formula["lua"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}"
      args << "lua_libdir=#{lua.lib}"
    end

    args << prefix

    scons *args

    unless build.stable?
      man1.install "Swift/Packaging/Debian/debian/swiften-config.1"
    end
  end

  test do
    system bin/"swiften-config"
  end
end

__END__
diff --git a/Swiften/TLS/SConscript b/Swiften/TLS/SConscript
index f5eb053..c1ff425 100644
--- a/Swiften/TLS/SConscript
+++ b/Swiften/TLS/SConscript
@@ -20,7 +20,7 @@ if myenv.get("HAVE_OPENSSL", 0) :
	myenv.Append(CPPDEFINES = "HAVE_OPENSSL")
 elif myenv.get("HAVE_SCHANNEL", 0) :
	swiften_env.Append(LIBS = ["Winscard"])
-	objects += myenv.StaticObject([
+	objects += myenv.SwiftenObject([
			"CAPICertificate.cpp",
			"Schannel/SchannelContext.cpp",
			"Schannel/SchannelCertificate.cpp",
@@ -29,7 +29,7 @@ elif myenv.get("HAVE_SCHANNEL", 0) :
	myenv.Append(CPPDEFINES = "HAVE_SCHANNEL")
 elif myenv.get("HAVE_SECURETRANSPORT", 0) :
	#swiften_env.Append(LIBS = ["Winscard"])
-	objects += myenv.StaticObject([
+	objects += myenv.SwiftenObject([
			"SecureTransport/SecureTransportContext.mm",
			"SecureTransport/SecureTransportCertificate.mm",
			"SecureTransport/SecureTransportContextFactory.cpp",
