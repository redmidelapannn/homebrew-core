class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.16/krb5-1.16.tar.gz"
  sha256 "faeb125f83b0fb4cdb2f99f088140631bb47d975982de0956d18c85842969e08"

  bottle do
    rebuild 1
    sha256 "7118c3cce933d59e0236633b00e752d811ace158c3608948c15d0f315ec7a12b" => :high_sierra
    sha256 "4a2efa99152cd3274585f2a4e79e0144731808f8ee7286f0649520eae323a387" => :sierra
    sha256 "67e72387bb98c5c96d31e114e9cda88c9ffd21af7cd8201c8e5479144f662edd" => :el_capitan
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--without-system-verto"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
