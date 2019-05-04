class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://archie-public.s3.amazonaws.com/s3backer/s3backer-1.5.0.tar.gz"
  sha256 "82d93c54acb1e85828b6b80a06e69a99c7e06bf6ee025dac720e980590d220d2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a796c829b788e503b56c627cbab6345b9881167127ff685876e9188ef4aae416" => :mojave
    sha256 "831a5f0c399c527555128191f14155cbbc1a5d1717d420b99eb1f280a7ba8201" => :high_sierra
    sha256 "98ee61419315eaea5e6b9308fa4b85631b4ee1e0d0eda8f1db5ee723cf3ec158" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse

  def install
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
