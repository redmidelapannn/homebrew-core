class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.0/qpdf-8.4.0.tar.gz"
  sha256 "39018f3bff700c68e41f6d44ea9f7842e2a5af200a80b2cdec7fa32a4abac4a0"

  bottle do
    cellar :any
    sha256 "0e7e9dd6cfc0eaa71666c60ee6b2ecda696889857b718c2bae2c08b2d3c88c29" => :mojave
    sha256 "1136864d5047401a6d53fa4603571b446cb627837985567cc91d125d885669cf" => :high_sierra
    sha256 "ad2e7a0c1923d503ed180889467d41dd75d187dc16839460d553eff6bf1efad3" => :sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
