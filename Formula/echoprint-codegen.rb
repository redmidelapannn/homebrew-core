class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "c40eb79af3abdb1e785b6a48a874ccfb0e9721d7d180626fe29c72a29acd3845"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "654ecd3e7b5c3b2008ab817a5bc2c5e327c05159b6903849880c214c33b5e4a9" => :sierra
    sha256 "98b779ddfe18cde8fc703c1eea2aeb389ed946be9cd07d79cad88512df73dd67" => :el_capitan
    sha256 "9b1585b78ca2b06735b1276e870662cc74bb2777d0f67fd50b0f8a5442d94929" => :yosemite
  end

  depends_on "ffmpeg"
  depends_on "taglib"
  depends_on "boost"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.diff"
    sha256 "0ab8e1ffafeeb44195246a78923d0d943d583279442b404c0af65ac1c5cbe74c"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
