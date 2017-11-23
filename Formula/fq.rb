class Fq < Formula
  desc "Brokered message queue optimized for performance"
  homepage "https://github.com/circonus-labs/fq"
  url "https://github.com/circonus-labs/fq/archive/v0.10.8.tar.gz"
  sha256 "b7d1886b027cf3a29c341d0fa900ff5804011035c3864352001c1d164670214c"
  head "https://github.com/circonus-labs/fq.git"

  bottle do
    sha256 "5fab145414eed8acfb1104bb24776fe0f3bfdfda5afbe8dd1937f717dff80fec" => :high_sierra
    sha256 "3391c78cb7c83ae27f08fb60e2e28af0500270263bf4b539ebfc163833381fc6" => :sierra
    sha256 "03b0aa47f039214b013ff9f077a11c5b182724fa0fdf6cd01526ae818142ab06" => :el_capitan
  end

  depends_on "concurrencykit"
  depends_on :java => "1.8"
  depends_on "jlog"
  depends_on "openssl"

  patch :DATA

  def install
    inreplace "Makefile", "/usr/lib/dtrace", "#{lib}/dtrace"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
    bin.install "fqc", "fq_sndr", "fq_rcvr"
  end

  test do
    pid = fork { exec sbin/"fqd", "-D", "-c", testpath/"test.sqlite" }
    sleep 1
    begin
      assert_match /Circonus Fq Operational Dashboard/, shell_output("curl 127.0.0.1:8765")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Makefile b/Makefile
index 5dbd8d1..b0a3b0b 100644
--- a/Makefile
+++ b/Makefile
@@ -134,7 +134,7 @@ fqc:	$(FQC_OBJ)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(FQC_OBJ) $(LIBS)
 
 fq-sample.so:	$(FQD_SAMPLE_OBJ)
-	$(Q)$(MODULELD) $(EXTRA_SHLDFLAGS) $(SHLDFLAGS) -o $@ $(FQD_SAMPLE_OBJ)
+	$(Q)$(MODULELD) $(EXTRA_SHLDFLAGS) $(SHLDFLAGS) -o $@ $(FQD_SAMPLE_OBJ) $(CLIENT_OBJ_LO)
 
 fq_sndr:	fq_sndr.o libfq.a
 	@echo " - linking $@"

