class Libswiften < Formula
  desc "C++ library for implementing XMPP applications"
  homepage "https://swift.im/swiften"
  revision 1
  head "git://swift.im/swift"

  stable do
    url "https://swift.im/downloads/releases/swift-3.0/swift-3.0.tar.gz"
    sha256 "8aa490431190294e62a9fc18b69ccc63dd0f561858d7d0b05c9c65f4d6ba5397"

    # Patch to fix build error of dynamic library with Apple's Secure Transport API
    # Fixed upstream: https://swift.im/git/swift/commit/?id=1d545a4a7fb877f021508094b88c1f17b30d8b4e
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 "99016044755aea8fb6349f5f760526f2d659fc5f8d1ca7f676f2fb5f5398ed66" => :sierra
    sha256 "c42f8bf0d70f954f683b5044793ee4c02d651ca437b173f417284e4b3dab260b" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "libidn"
  depends_on "lua" => :recommended

  def install
    inreplace "Sluift/main.cpp", "#include <string>",
                                 "#include <iostream>\n#include <string>"

    inreplace "BuildTools/SCons/SConstruct",
              /(\["BOOST_SIGNALS_NO_DEPRECATION_WARNING")\]/,
              "\\1, \"__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0\"]"

    system "2to3", "--write", "--fix=print", "SConstruct",
           "BuildTools/SCons/SConstruct", "3rdParty/LibIDN/SConscript",
           "Slimber/SConscript", "Sluift/SConscript", "Swift/SConscript"

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
