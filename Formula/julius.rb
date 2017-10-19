class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.4.2.1.tar.gz"
  sha256 "784730d63bcd9e9e2ee814ba8f79eef2679ec096300e96400e91f6778757567f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5ec45291c526f4fe0fc16fd97486f658805cd9b65fc37621192b431081a6ebac" => :high_sierra
    sha256 "627af31ca4adee6a73392886e5bb1c750e475b1fab3ae874c266a68637bee2e4" => :sierra
    sha256 "d12c946e966a37c23e693d2c712377ea356563ace66bf213b1171cfb606197e5" => :el_capitan
  end

  depends_on "libsndfile"

  # Upstream PR from 9 Sep 2017 "ensure pkgconfig directory exists during
  # installation"
  patch do
    url "https://github.com/julius-speech/julius/pull/73.patch?full_index=1"
    sha256 "b1d2d233a7f04f0b8f1123e1de731afd618b996d1f458ea8f53b01c547864831"
  end

  def install
    # Upstream issue "4.4.2.1 parallelized build fails"
    # Reported 10 Sep 2017 https://github.com/julius-speech/julius/issues/74
    ENV.deparallelize

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius --help", 1)
  end
end
