class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "dc80133839195838975757c5f6cada01d8e09d0aac622a8a4aa23755a5a9ae6d"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "d03e7845d6de91601cfe49fa888ce975dd0c72d420ac1295e7c5254e3c80a6cf" => :high_sierra
    sha256 "e1cb6fdb75e48a9c0d00d2349f5de787ad58deb0314b964b92bf589809870e01" => :sierra
    sha256 "1ceaac06a70c286f13936267c76832c8086fc5ec61e6c77a3e2005911231f126" => :el_capitan
  end

  depends_on "ffmpeg"
  depends_on "taglib"
  depends_on "boost"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.diff?full_index=1"
    sha256 "713bffc8a02e2f53c7a0479f7efb6df732346f20cb055a4fda67da043bcf1c12"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
