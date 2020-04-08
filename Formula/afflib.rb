class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.18.tar.gz"
  sha256 "5481cd5d8dbacd39d0c531a68ae8afcca3160c808770d66dcbf5e9b5be3e8199"
  revision 3

  bottle do
    cellar :any
    sha256 "cfd0fcec5db93c2082f3b7366b22ccf284fa0d370b1fa20df25f7e9f7894f2a6" => :catalina
    sha256 "7934659c7ac511da2437b31ed9c0ecb575bbf87c2e01e1de62c1822607ba2dae" => :mojave
    sha256 "32d4b34e82a876f4cd1f4e21b88896b524d073499b280056d39483c377f995ff" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def install
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
