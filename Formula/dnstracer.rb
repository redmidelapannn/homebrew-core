class Dnstracer < Formula
  desc "Trace a chain of DNS servers to the source"
  homepage "https://www.mavetju.org/unix/dnstracer.php"
  url "https://www.mavetju.org/download/dnstracer-1.9.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dnstracer/dnstracer_1.9.orig.tar.gz"
  sha256 "2ebc08af9693ba2d9fa0628416f2d8319ca1627e41d64553875d605b352afe9c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4c03c4115a747ef87f931628cf9d3506d6649793dac82f46804e3fcb9b416adf" => :high_sierra
    sha256 "7f4f1a2ddb7491e0fe57ef0192a9af28147c85e69bb4ffc874777f49499b35ad" => :sierra
    sha256 "7822ec8a8a7b10321c1e7821c6ad9794367f60023a8813da277ce55f30b03465" => :el_capitan
  end

  def install
    ENV.append "LDFLAGS", "-lresolv"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnstracer", "brew.sh"
  end
end
