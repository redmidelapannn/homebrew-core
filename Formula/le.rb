class Le < Formula
  desc "Text editor with block and binary operations"
  homepage "https://github.com/lavv17/le"
  url "https://github.com/lavv17/le/releases/download/v1.16.5/le-1.16.5.tar.xz"
  sha256 "258d586f83e8abd55144dc3f09d9ddaf6ef55e8a90543fdb0932fb77d089dd78"

  bottle do
    rebuild 1
    sha256 "46ca26ffe6570bef39bd74ae0e9a3250d2f463d2bbc372635879ac25bea64a58" => :high_sierra
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/le --help", 1)
  end
end
