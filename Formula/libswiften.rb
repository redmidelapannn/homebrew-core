class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  url "https://swift.im/downloads/releases/swift-3.0/swift-3.0.tar.gz"
  sha256 "8aa490431190294e62a9fc18b69ccc63dd0f561858d7d0b05c9c65f4d6ba5397"
  revision 1

  # Patch to fix build error of dynamic library with Apple's Secure Transport API
  # Fixed upstream: https://swift.im/git/swift/commit/?id=1d545a4a7fb877f021508094b88c1f17b30d8b4e
  patch :DATA

  bottle do
    rebuild 1
    sha256 "c32cc077d5357bf0e3b9df3a9540dda72953fee20b05015feaac914279adea21" => :sierra
    sha256 "5ddf00fb3efa0944feb9bde0324ee2729313c87c819d1fd03647c7debd8d18d1" => :el_capitan
    sha256 "319d0362bdca805a9ed1f0205584ead08335e27a3ed60ec49788d9486b9d407d" => :yosemite
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
    ]

    if build.with? "lua"
      lua = Formula["lua"]
      args << "SLUIFT_INSTALLDIR=#{prefix}"
      args << "lua_includedir=#{lua.include}"
      args << "lua_libdir=#{lua.lib}"
    end

    args << prefix

    scons *args
    man1.install "Swift/Packaging/Debian/debian/swiften-config.1" unless build.stable?
  end

  test do
    system "#{bin}/swiften-config"
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
