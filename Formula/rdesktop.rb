class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.8.4/rdesktop-1.8.4.tar.gz"
  sha256 "9b98b8e73aa83e93aa1d9ae82ce38c08395f64b67799edc24821bb26a84dcd2d"

  bottle do
    sha256 "86d8cbf1062d5a67a061bad2c7d7d0b2981fd32fbc1bb6c5009764f9e2c92ce1" => :mojave
    sha256 "5e5414eb53a19e13450d7c80bfcd490b89bb02997f796b829257f0a71ccb393f" => :high_sierra
    sha256 "8d0b4c1932e64113d042a14e6e0cca879203b691297e2b777f20ff7fb32b2376" => :sierra
  end

  depends_on "openssl"
  depends_on :x11

  # Note: The patch below is meant to remove the reference to the
  # undefined symbol SCARD_CTL_CODE.
  # upstream bug report: https://sourceforge.net/p/rdesktop/bugs/352/
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-credssp
      --enable-smartcard
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --x-includes=#{MacOS::X11.include}
      --x-libraries=#{MacOS::X11.lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdesktop -help 2>&1", 64)
  end
end

__END__
diff --git a/scard.c b/scard.c
index caa0745..5521ee9 100644
--- a/scard.c
+++ b/scard.c
@@ -2152,7 +2152,6 @@ TS_SCardControl(STREAM in, STREAM out)
	{
		/* Translate to local encoding */
		dwControlCode = (dwControlCode & 0x3ffc) >> 2;
-		dwControlCode = SCARD_CTL_CODE(dwControlCode);
	}
	else
	{
@@ -2198,7 +2197,7 @@ TS_SCardControl(STREAM in, STREAM out)
	}

 #ifdef PCSCLITE_VERSION_NUMBER
-	if (dwControlCode == SCARD_CTL_CODE(3400))
+	if (0)
	{
		int i;
		SERVER_DWORD cc;
